import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class DateCalculationScreen extends StatefulWidget {
  const DateCalculationScreen({super.key});

  @override
  State<DateCalculationScreen> createState() => _DateCalculationScreenState();
}

class _DateCalculationScreenState extends State<DateCalculationScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  int? _daysDifference;
  String? _errorMessage;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  void _calculateDaysDifference() {
    if (_startDate != null && _endDate != null) {
      if (_endDate!.isBefore(_startDate!)) {
        setState(() {
          _errorMessage = 'End date cannot be before start date';
          _daysDifference = null;
        });
        return;
      }
      setState(() {
        _errorMessage = null;
        _daysDifference = _endDate!.difference(_startDate!).inDays;
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
        _calculateDaysDifference();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Date Calculations"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: theme.cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calculate Days Between Dates',
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildDateButton(
                      'Start Date',
                      _startDate,
                      () => _selectDate(context, true),
                      isDarkMode,
                    ),
                    const SizedBox(height: 16),
                    _buildDateButton(
                      'End Date',
                      _endDate,
                      () => _selectDate(context, false),
                      isDarkMode,
                    ),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.redAccent, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    if (_daysDifference != null && _errorMessage == null)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          'Time Difference: $_daysDifference days',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.bodyLarge!.color,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateButton(
      String label, DateTime? date, VoidCallback onPressed, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.teal),
              borderRadius: BorderRadius.circular(8),
              color: isDarkMode ? Colors.black54 : Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date != null ? _dateFormat.format(date) : 'Select Date',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 16,
                  ),
                ),
                const FaIcon(
                  FontAwesomeIcons.calendar,
                  color: Colors.teal,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
