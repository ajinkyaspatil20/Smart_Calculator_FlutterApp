import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  double? height; // in cm
  double? weight; // in kg
  double? bmiResult;
  String? bmiCategory;

  final FirebaseService _firebaseService = FirebaseService();

  void _calculateBMI() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        try {
          // BMI formula: weight (kg) / (height (m))²
          final heightInMeters = height! / 100;
          if (heightInMeters <= 0) {
            throw Exception('Invalid height value');
          }
          bmiResult = weight! / (heightInMeters * heightInMeters);
          if (bmiResult!.isInfinite || bmiResult!.isNaN) {
            throw Exception('Invalid calculation result');
          }

          // Determine BMI category
          if (bmiResult! < 18.5) {
            bmiCategory = 'Underweight';
          } else if (bmiResult! < 25) {
            bmiCategory = 'Normal weight';
          } else if (bmiResult! < 30) {
            bmiCategory = 'Overweight';
          } else {
            bmiCategory = 'Obese';
          }

          // Add to Firebase history
          _firebaseService.addCalculationToHistory(
            'Height: ${height!.toStringAsFixed(1)} cm, Weight: ${weight!.toStringAsFixed(1)} kg',
            'BMI: ${bmiResult!.toStringAsFixed(1)} ($bmiCategory)',
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Error calculating BMI. Please check your inputs.')),
          );
          return;
        }

        // Add to Firebase history
        _firebaseService.addCalculationToHistory(
          'Height: ${height!.toStringAsFixed(1)} cm, Weight: ${weight!.toStringAsFixed(1)} kg',
          'BMI: ${bmiResult!.toStringAsFixed(1)} ($bmiCategory)',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BMI Calculator',
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
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Height (cm)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.height),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your height';
                            }
                            final height = double.tryParse(value);
                            if (height == null || height <= 0) {
                              return 'Please enter a valid height';
                            }
                            if (height < 50 || height > 300) {
                              return 'Please enter a realistic height (50-300 cm)';
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
                              return 'Please enter your weight';
                            }
                            final weight = double.tryParse(value);
                            if (weight == null || weight <= 0) {
                              return 'Please enter a valid weight';
                            }
                            if (weight < 2 || weight > 500) {
                              return 'Please enter a realistic weight (2-500 kg)';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            weight = double.parse(value!);
                          },
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _calculateBMI,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Calculate BMI',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (bmiResult != null) ...[
                  SizedBox(height: 24),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Your BMI',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            bmiResult!.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            bmiCategory!,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
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
}
