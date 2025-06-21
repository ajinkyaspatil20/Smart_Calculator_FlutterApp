import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/firebase_service.dart';

class TemperatureConverterScreen extends StatefulWidget {
  const TemperatureConverterScreen({super.key});

  @override
  State<TemperatureConverterScreen> createState() =>
      _TemperatureConverterScreenState();
}

class _TemperatureConverterScreenState extends State<TemperatureConverterScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _fromUnit = 'Celsius';
  String _toUnit1 = 'Fahrenheit';
  String _toUnit2 = 'Kelvin';
  String _result1 = '', _result2 = '';

  final List<String> _units = ['Celsius', 'Fahrenheit', 'Kelvin'];
  final FirebaseService _firebaseService = FirebaseService();

  void _convert() {
    if (_inputController.text.isEmpty) return;
    try {
      double inputValue = double.parse(_inputController.text);
      double inCelsius;

      if (_fromUnit == 'Fahrenheit') {
        inCelsius = (inputValue - 32) * 5 / 9;
      } else if (_fromUnit == 'Kelvin') {
        inCelsius = inputValue - 273.15;
      } else {
        inCelsius = inputValue;
      }

      double result1 = _toUnit1 == 'Celsius'
          ? inCelsius
          : _toUnit1 == 'Fahrenheit'
              ? (inCelsius * 9 / 5 + 32)
              : (inCelsius + 273.15);

      double result2 = _toUnit2 == 'Celsius'
          ? inCelsius
          : _toUnit2 == 'Fahrenheit'
              ? (inCelsius * 9 / 5 + 32)
              : (inCelsius + 273.15);

      setState(() {
        _result1 = result1.toStringAsFixed(2);
        _result2 = result2.toStringAsFixed(2);
      });

      String historyEntry =
          '$inputValue $_fromUnit = $_result1 $_toUnit1, $_result2 $_toUnit2';
      _firebaseService.addCalculationToHistory(
        '$inputValue $_fromUnit = $_result1 $_toUnit1, $_result2 $_toUnit2', // Pass the history entry as the expression
        '${_result1} $_toUnit1', // Pass the result
      );

    } catch (e) {
      setState(() {
        _result1 = 'Invalid input';
        _result2 = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Temperature Converter')),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              TextField(
                controller: _inputController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration(
                    'Enter Temperature', FontAwesomeIcons.thermometerHalf),
              ),
              const SizedBox(height: 20),
              _buildDropdownRow('From', _fromUnit, (value) {
                setState(() {
                  _fromUnit = value!;
                });
              }),
              const SizedBox(height: 20),
              _buildDropdownRow('To', _toUnit1, (value) {
                setState(() {
                  _toUnit1 = value!;
                });
              }),
              const SizedBox(height: 20),
              _buildDropdownRow('To', _toUnit2, (value) {
                setState(() {
                  _toUnit2 = value!;
                });
              }),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _convert,
                  child: const Text('Convert'),
                ),
              ),
              const SizedBox(height: 30),
              _buildResultBox(_result1, _toUnit1),
              const SizedBox(height: 10),
              _buildResultBox(_result2, _toUnit2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownRow(String label, String value, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: _dropdownBoxDecoration(),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            dropdownColor: Colors.grey[900],
            style: const TextStyle(color: Colors.white),
            underline: Container(),
            items: _units
                .map((unit) =>
                    DropdownMenuItem<String>(value: unit, child: Text(unit)))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildResultBox(String result, String unit) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.5)),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          result.isNotEmpty ? '$result $unit' : '0 $unit',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black54),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blueAccent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      prefixIcon: Icon(icon, color: Colors.blueAccent),
    );
  }

  BoxDecoration _dropdownBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.blueAccent.withOpacity(0.5)),
      borderRadius: BorderRadius.circular(12),
    );
  }
}
