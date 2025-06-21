import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';
import '../services/firebase_service.dart';

class WaterIntakeCalculatorScreen extends StatefulWidget {
  const WaterIntakeCalculatorScreen({super.key});

  @override
  _WaterIntakeCalculatorScreenState createState() =>
      _WaterIntakeCalculatorScreenState();
}

class _WaterIntakeCalculatorScreenState
    extends State<WaterIntakeCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  double? weight; // in kg
  String activityLevel = 'Sedentary'; // default value
  double? waterIntake; // in liters

  final Map<String, double> activityMultipliers = {
    'Sedentary': 30,
    'Lightly Active': 35,
    'Moderately Active': 40,
    'Very Active': 45,
    'Extremely Active': 50,
  };

  final FirebaseService _firebaseService = FirebaseService();

  void _calculateWaterIntake() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        // Calculate water intake based on weight and activity level
        // Formula: Weight (kg) * activity multiplier (ml/kg) = Daily water needs in ml
        // Convert to liters
        waterIntake = (weight! * activityMultipliers[activityLevel]!) / 1000;

        // Add to Firebase history
        _firebaseService.addCalculationToHistory(
          'Weight: ${weight!.toStringAsFixed(1)} kg, Activity: $activityLevel',
          'Daily Water Intake: ${waterIntake!.toStringAsFixed(1)} L',
        );

        // Remove HistoryProvider section
        // final historyProvider =
        //     Provider.of<HistoryProvider>(context, listen: false);
        // historyProvider.addToHistory(
        //   'Water Intake Calculation',
        //   'Weight: ${weight!.toStringAsFixed(1)} kg, Activity: $activityLevel',
        //   'Daily Water Intake: ${waterIntake!.toStringAsFixed(1)} L',
        // );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Water Intake Calculator',
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
                            return null;
                          },
                          onSaved: (value) {
                            weight = double.parse(value!);
                          },
                        ),
                        SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Activity Level',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.directions_run),
                          ),
                          value: activityLevel,
                          items: activityMultipliers.keys.map((String level) {
                            return DropdownMenuItem<String>(
                              value: level,
                              child: Text(level),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              activityLevel = newValue!;
                            });
                          },
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _calculateWaterIntake,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Calculate Water Intake',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (waterIntake != null) ...[
                  SizedBox(height: 24),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Daily Water Intake',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${waterIntake!.toStringAsFixed(1)} L',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'or',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${(waterIntake! * 1000).toStringAsFixed(0)} ml',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Remember to adjust your intake based on climate, exercise intensity, and overall health.',
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
}
