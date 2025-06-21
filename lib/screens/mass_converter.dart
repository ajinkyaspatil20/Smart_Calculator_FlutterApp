import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/firebase_service.dart';

class MassConverterScreen extends StatefulWidget {
  const MassConverterScreen({super.key});

  @override
  State<MassConverterScreen> createState() => _MassConverterScreenState();
}

class _MassConverterScreenState extends State<MassConverterScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _fromUnit = 'Kilograms';
  String _toUnit1 = 'Grams';
  String _toUnit2 = 'Pounds';
  String _toUnit3 = 'Ounces';
  int _unitCount = 1;
  String _result1 = '', _result2 = '', _result3 = '';

  final List<String> _units = ['Kilograms', 'Grams', 'Pounds', 'Ounces'];
  final FirebaseService _firebaseService = FirebaseService();

  final Map<String, double> _toKilograms = {
    'Kilograms': 1,
    'Grams': 0.001,
    'Pounds': 0.453592,
    'Ounces': 0.0283495,
  };

  void _convert() {
    if (_inputController.text.isEmpty) return;
    try {
      double inputValue = double.parse(_inputController.text);
      double inKilograms = inputValue * _toKilograms[_fromUnit]!;
      setState(() {
        _result1 = (inKilograms / _toKilograms[_toUnit1]!).toStringAsFixed(6);
        _result2 = _unitCount >= 2
            ? (inKilograms / _toKilograms[_toUnit2]!).toStringAsFixed(6)
            : '';
        _result3 = _unitCount == 3
            ? (inKilograms / _toKilograms[_toUnit3]!).toStringAsFixed(6)
            : '';
      });

      // Add to Firebase history
      String historyEntry = '$inputValue $_fromUnit = $_result1 $_toUnit1';
      if (_unitCount >= 2 && _result2.isNotEmpty) {
        historyEntry += ', $_result2 $_toUnit2';
      }
      if (_unitCount == 3 && _result3.isNotEmpty) {
        historyEntry += ', $_result3 $_toUnit3';
      }
      _firebaseService.addCalculationToHistory(
        '$inputValue $_fromUnit = $_result1 $_toUnit1', // Pass the history entry as the expression
        '${_result1} $_toUnit1', // Pass the result
      );

    } catch (e) {
      setState(() {
        _result1 = 'Invalid input';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mass Converter'),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDropdownUnitCount(theme),
            const SizedBox(height: 20),
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              decoration: _inputDecoration(
                  'Enter Mass', FontAwesomeIcons.weight, theme),
            ),
            const SizedBox(height: 10),
            _buildDropdownRow('From', _fromUnit, (value) {
              setState(() {
                _fromUnit = value!;
              });
            }, theme),
            const SizedBox(height: 10),
            _buildDropdownRow('To', _toUnit1, (value) {
              setState(() {
                _toUnit1 = value!;
              });
            }, theme),
            if (_unitCount >= 2)
              _buildDropdownRow('Second To', _toUnit2,
                  (value) => setState(() => _toUnit2 = value!), theme),
            if (_unitCount == 3)
              _buildDropdownRow('Third To', _toUnit3,
                  (value) => setState(() => _toUnit3 = value!), theme),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _convert, child: const Text('Convert')),
            Expanded(
              child: ListView(
                children: [
                  _buildResultBox(_result1, _toUnit1, theme),
                  if (_unitCount >= 2) _buildResultBox(_result2, _toUnit2, theme),
                  if (_unitCount == 3) _buildResultBox(_result3, _toUnit3, theme),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownUnitCount(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: _dropdownBoxDecoration(theme),
      child: DropdownButton<int>(
        value: _unitCount,
        isExpanded: true,
        dropdownColor: theme.cardColor,
        style: TextStyle(color: theme.textTheme.bodyLarge?.color),
        underline: Container(),
        items: [1, 2, 3]
            .map((int count) => DropdownMenuItem<int>(
                value: count, child: Text('$count Units')))
            .toList(),
        onChanged: (value) => setState(() => _unitCount = value!),
      ),
    );
  }

  Widget _buildDropdownRow(
      String label, String value, Function(String?) onChanged, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: _dropdownBoxDecoration(theme),
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: theme.cardColor,
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              underline: Container(),
              items: _units
                  .map((unit) =>
                      DropdownMenuItem<String>(value: unit, child: Text(unit)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultBox(String result, String unit, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.primaryColor),
      ),
      child: Column(
        children: [
          Text(result.isNotEmpty ? '$result $unit' : '0',
              style: TextStyle(
                  color: theme.textTheme.bodyLarge?.color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon, ThemeData theme) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.primaryColor),
        borderRadius: BorderRadius.circular(8),
      ),
      prefixIcon: Icon(icon, color: theme.primaryColor),
    );
  }

  BoxDecoration _dropdownBoxDecoration(ThemeData theme) {
    return BoxDecoration(
      border: Border.all(color: theme.primaryColor),
      borderRadius: BorderRadius.circular(8),
    );
  }
}
