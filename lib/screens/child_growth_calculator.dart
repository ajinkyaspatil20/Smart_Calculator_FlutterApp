import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';
import '../services/firebase_service.dart';

class ChildGrowthCalculatorScreen extends StatefulWidget {
  const ChildGrowthCalculatorScreen({super.key});

  @override
  _ChildGrowthCalculatorScreenState createState() =>
      _ChildGrowthCalculatorScreenState();
}

class _ChildGrowthCalculatorScreenState
    extends State<ChildGrowthCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  double? age; // in years
  double? height; // in cm
  double? weight; // in kg
  String gender = 'Male'; // default value
  Map<String, dynamic>? results;

  final FirebaseService _firebaseService = FirebaseService();

  void _calculateGrowthPercentiles() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        // Simplified percentile calculation based on WHO standards
        // Note: In a real app, this would use actual WHO growth charts data
        double heightPercentile = _calculateSimplePercentile(height!);
        double weightPercentile = _calculateSimplePercentile(weight!);

        results = {
          'heightPercentile': heightPercentile,
          'weightPercentile': weightPercentile,
        };

        // Add to Firebase history
        _firebaseService.addCalculationToHistory(
          'Age: ${age!.toStringAsFixed(1)} years, Height: ${height!.toStringAsFixed(1)} cm, Weight: ${weight!.toStringAsFixed(1)} kg',
          'Height Percentile: ${results!["heightPercentile"].toStringAsFixed(1)}%, Weight Percentile: ${results!["weightPercentile"].toStringAsFixed(1)}%',
        );
      });
    }
  }

  // Simplified percentile calculation
  double _calculateSimplePercentile(double value) {
    // This is a simplified calculation for demonstration
    // In a real app, this would use WHO growth charts
    return ((value / 100) * 50).clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Child Growth Calculator',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.scaffoldBackgroundColor,
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                          value: gender,
                          items: ['Male', 'Female'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              gender = newValue!;
                            });
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Age (years)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter age';
                            }
                            final age = double.tryParse(value);
                            if (age == null || age <= 0 || age > 18) {
                              return 'Please enter a valid age (0-18 years)';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            age = double.parse(value!);
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Height (cm)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.height),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter height';
                            }
                            final height = double.tryParse(value);
                            if (height == null || height <= 0) {
                              return 'Please enter a valid height';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            height = double.parse(value!);
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Weight (kg)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.monitor_weight),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter weight';
                            }
                            final weight = double.tryParse(value);
                            if (weight == null || weight <= 0) {
                              return 'Please enter a valid weight';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            weight = double.parse(value!);
                          },
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _calculateGrowthPercentiles,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Calculate Growth Percentiles',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (results != null) ...[
                  SizedBox(height: 24),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Growth Percentiles',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          _buildPercentileRow('Height',
                              results!['heightPercentile'].toStringAsFixed(0)),
                          SizedBox(height: 8),
                          _buildPercentileRow('Weight',
                              results!['weightPercentile'].toStringAsFixed(0)),
                          SizedBox(height: 16),
                          Text(
                            'Note: These are approximate values. Consult your pediatrician for accurate growth assessment.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPercentileRow(String label, String percentile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label Percentile',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '$percentile%',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
