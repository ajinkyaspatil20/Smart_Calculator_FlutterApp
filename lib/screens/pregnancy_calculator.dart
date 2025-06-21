import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';
import '../services/firebase_service.dart';

class PregnancyCalculatorScreen extends StatefulWidget {
  const PregnancyCalculatorScreen({super.key});

  @override
  _PregnancyCalculatorScreenState createState() =>
      _PregnancyCalculatorScreenState();
}

class _PregnancyCalculatorScreenState extends State<PregnancyCalculatorScreen> {
  DateTime? lmpDate;
  DateTime? dueDate;
  int? weeksPregnant;
  String? trimester;

  final FirebaseService _firebaseService = FirebaseService();

  void _calculateDueDate() {
    if (lmpDate != null) {
      setState(() {
        // Add 280 days (40 weeks) to LMP date
        dueDate = lmpDate!.add(Duration(days: 280));

        // Calculate weeks pregnant
        final difference = DateTime.now().difference(lmpDate!);
        weeksPregnant = (difference.inDays / 7).floor();

        // Determine trimester
        if (weeksPregnant! <= 13) {
          trimester = 'First Trimester';
        } else if (weeksPregnant! <= 26) {
          trimester = 'Second Trimester';
        } else {
          trimester = 'Third Trimester';
        }

        // Add to Firebase history
        _firebaseService.addCalculationToHistory(
          'LMP Date: ${lmpDate!.toString().split(' ')[0]}',
          'Due Date: ${dueDate!.toString().split(' ')[0]} ($trimester)',
        );
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: lmpDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != lmpDate) {
      setState(() {
        lmpDate = picked;
        _calculateDueDate();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pregnancy Calculator',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last Menstrual Period (LMP)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: theme.colorScheme.primary,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today),
                              SizedBox(width: 16),
                              Text(
                                lmpDate == null
                                    ? 'Select Date'
                                    : lmpDate!.toString().split(' ')[0],
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (dueDate != null) ...[
                SizedBox(height: 24),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Pregnancy Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildDetailRow(
                            'Due Date', dueDate!.toString().split(' ')[0]),
                        SizedBox(height: 8),
                        _buildDetailRow(
                            'Weeks Pregnant', '$weeksPregnant weeks'),
                        SizedBox(height: 8),
                        _buildDetailRow('Current Stage', trimester!),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
