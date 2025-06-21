import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/firebase_service.dart';

class VolumeConverterScreen extends StatefulWidget {
  const VolumeConverterScreen({super.key});

  @override
  State<VolumeConverterScreen> createState() => _VolumeConverterScreenState();
}

class _VolumeConverterScreenState extends State<VolumeConverterScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _fromUnit = 'Liters';
  String _toUnit1 = 'Milliliters';
  String _toUnit2 = 'Gallons';
  String _toUnit3 = 'Cubic Meters';
  int _unitCount = 3;
  String _result1 = '', _result2 = '', _result3 = '';

  final List<String> _units = [
    'Liters',
    'Milliliters',
    'Gallons',
    'Cubic Meters'
  ];

  final FirebaseService _firebaseService = FirebaseService();

  final Map<String, double> _toLiters = {
    'Liters': 1,
    'Milliliters': 0.001,
    'Gallons': 3.78541,
    'Cubic Meters': 1000,
  };

  void _convert() {
    if (_inputController.text.isEmpty) return;
    try {
      double inputValue = double.parse(_inputController.text);
      double inLiters = inputValue * _toLiters[_fromUnit]!;

      setState(() {
        _result1 = (inLiters / _toLiters[_toUnit1]!).toStringAsFixed(6);
        _result2 = (inLiters / _toLiters[_toUnit2]!).toStringAsFixed(6);
        _result3 = (inLiters / _toLiters[_toUnit3]!).toStringAsFixed(6);
      });

      // Add to Firebase history
      String historyEntry =
          '$inputValue $_fromUnit = $_result1 $_toUnit1, $_result2 $_toUnit2, $_result3 $_toUnit3';
      _firebaseService.addCalculationToHistory(
        '$inputValue $_fromUnit = $_result1 $_toUnit1, $_result2 $_toUnit2, $_result3 $_toUnit3', // Pass the history entry as the expression
        '$_result1 $_toUnit1', // Pass the result
      );


    } catch (e) {
      setState(() {
        _result1 = 'Invalid input';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    bool isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Volume Converter')),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDropdownUnitCount(isDarkMode),
            const SizedBox(height: 20),
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              decoration: _inputDecoration(
                  'Enter Volume', FontAwesomeIcons.tint, theme),
            ),
            const SizedBox(height: 10),
            _buildDropdownRow('From', _fromUnit, (value) {
              setState(() {
                _fromUnit = value!;
              });
            }, isDarkMode),
            const SizedBox(height: 10),
            _buildDropdownRow('To', _toUnit1, (value) {
              setState(() {
                _toUnit1 = value!;
              });
            }, isDarkMode),
            if (_unitCount >= 2)
              _buildDropdownRow('Second To', _toUnit2,
                  (value) => setState(() => _toUnit2 = value!), isDarkMode),
            if (_unitCount == 3)
              _buildDropdownRow('Third To', _toUnit3,
                  (value) => setState(() => _toUnit3 = value!), isDarkMode),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convert,
              child: const Text('Convert'),
            ),
            const SizedBox(height: 20),
            _buildResultsSection(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownUnitCount(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: _dropdownBoxDecoration(isDarkMode),
      child: DropdownButton<int>(
        value: _unitCount,
        isExpanded: true,
        dropdownColor: isDarkMode ? Colors.grey[900] : Colors.white,
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        underline: Container(),
        items: [3] // Fixed to 3 for volume conversion
            .map((int count) => DropdownMenuItem<int>(
                value: count, child: Text('$count Units')))
            .toList(),
        onChanged: (value) => setState(() => _unitCount = value!),
      ),
    );
  }

  Widget _buildDropdownRow(String label, String value,
      Function(String?) onChanged, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: _dropdownBoxDecoration(isDarkMode),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        dropdownColor: isDarkMode ? Colors.grey[900] : Colors.white,
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        underline: Container(),
        items: _units
            .map((unit) =>
                DropdownMenuItem<String>(value: unit, child: Text(unit)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildResultsSection(bool isDarkMode) {
    return Column(
      children: [
        _buildResultBox(_result1, _toUnit1, isDarkMode),
        if (_unitCount >= 2) _buildResultBox(_result2, _toUnit2, isDarkMode),
        if (_unitCount == 3) _buildResultBox(_result3, _toUnit3, isDarkMode),
      ],
    );
  }

  Widget _buildResultBox(String result, String unit, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color:
            isDarkMode ? Colors.deepPurple.withOpacity(0.2) : Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.deepPurple.shade400),
      ),
      child: Center(
        child: Text(
          result.isNotEmpty ? '$result $unit' : '0',
          style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
      String label, IconData icon, ThemeData theme) {
    bool isDarkMode = theme.brightness == Brightness.dark;
    return InputDecoration(
      labelText: label,
      labelStyle:
          TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.deepPurple.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      prefixIcon: Icon(icon, color: Colors.deepPurple),
    );
  }

  BoxDecoration _dropdownBoxDecoration(bool isDarkMode) {
    return BoxDecoration(
      border: Border.all(color: Colors.deepPurple.shade400),
      borderRadius: BorderRadius.circular(8),
      color: isDarkMode ? Colors.grey[850] : Colors.white,
    );
  }
}
