import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LengthConverterScreen extends StatefulWidget {
  const LengthConverterScreen({super.key});

  @override
  State<LengthConverterScreen> createState() => _LengthConverterScreenState();
}

class _LengthConverterScreenState extends State<LengthConverterScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _fromUnit = 'Meters';
  int _outputCount = 1;
  List<String> _toUnits = ['Kilometers', 'Centimeters', 'Inches'];
  List<String> _results = ['', '', ''];

  final List<String> _units = ['Meters', 'Kilometers', 'Centimeters', 'Inches', 'Feet', 'Miles'];

  final Map<String, double> _toMeters = {
    'Meters': 1,
    'Kilometers': 1000,
    'Centimeters': 0.01,
    'Inches': 0.0254,
    'Feet': 0.3048,
    'Miles': 1609.34,
  };

  void _convert() {
    if (_inputController.text.isEmpty) return;
    try {
      double inputValue = double.parse(_inputController.text);
      double inMeters = inputValue * _toMeters[_fromUnit]!;

      setState(() {
        for (int i = 0; i < _outputCount; i++) {
          _results[i] = (inMeters / _toMeters[_toUnits[i]]!).toStringAsFixed(6);
        }
      });
    } catch (e) {
      setState(() {
        _results = List.filled(3, 'Invalid input');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Length Converter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration('Enter Length', FontAwesomeIcons.ruler, theme),
            ),
            const SizedBox(height: 10),
            _buildDropdownRow('From', _fromUnit, (value) => setState(() => _fromUnit = value!)),
            const SizedBox(height: 10),
            _buildOutputCountSelector(),
            const SizedBox(height: 10),
            for (int i = 0; i < _outputCount; i++)
              Column(
                children: [
                  _buildDropdownRow('To ${i + 1}', _toUnits[i], (value) => setState(() => _toUnits[i] = value!)),
                  const SizedBox(height: 10),
                ],
              ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _convert,
                child: const Text('Convert'),
              ),
            ),
            const SizedBox(height: 20),
            for (int i = 0; i < _outputCount; i++) _buildResultBox(_results[i], _toUnits[i]),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownRow(String label, String value, Function(String?) onChanged) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(labelText: label),
            items: _units.map((unit) => DropdownMenuItem(value: unit, child: Text(unit))).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildOutputCountSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Number of Outputs'),
        DropdownButton<int>(
          value: _outputCount,
          items: [1, 2, 3].map((e) => DropdownMenuItem(value: e, child: Text(e.toString()))).toList(),
          onChanged: (value) => setState(() => _outputCount = value!),
        ),
      ],
    );
  }

  Widget _buildResultBox(String result, String unit) {
    return Center(
      child: Text(
        result.isNotEmpty ? '$result $unit' : '0',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon, ThemeData theme) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      prefixIcon: Icon(icon),
    );
  }
}
