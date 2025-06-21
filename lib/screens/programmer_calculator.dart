import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class ProgrammerCalculatorScreen extends StatefulWidget {
  const ProgrammerCalculatorScreen({super.key});

  @override
  _ProgrammerCalculatorScreenState createState() =>
      _ProgrammerCalculatorScreenState();
}

class _ProgrammerCalculatorScreenState
    extends State<ProgrammerCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseService _firebaseService = FirebaseService();

  String _input = '0';
  String _currentBase = 'DEC'; // DEC, BIN, OCT, HEX
  int _decimalValue = 0;

  final Map<String, int> _bases = {
    'BIN': 2,
    'OCT': 8,
    'DEC': 10,
    'HEX': 16,
  };

  void _updateInput(String value) {
    setState(() {
      try {
        if (_currentBase == 'BIN' && !RegExp(r'^[01]+$').hasMatch(value)) {
          throw FormatException('Invalid binary digit');
        } else if (_currentBase == 'OCT' &&
            !RegExp(r'^[0-7]+$').hasMatch(value)) {
          throw FormatException('Invalid octal digit');
        } else if (_currentBase == 'HEX' &&
            !RegExp(r'^[0-9A-F]+$').hasMatch(value)) {
          throw FormatException('Invalid hexadecimal digit');
        }

        if (_input == '0') {
          _input = value;
        } else {
          _input += value;
        }
        _convertToDecimal();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid input: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });
  }

  void _convertToDecimal() {
    try {
      _decimalValue = int.parse(_input, radix: _bases[_currentBase]!);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Invalid input for ${_currentBase.toLowerCase()} number')),
      );
      _input = '0';
      _decimalValue = 0;
    }
  }

  String _getValueInBase(String base) {
    try {
      switch (base) {
        case 'BIN':
          return _decimalValue.toRadixString(2).toUpperCase();
        case 'OCT':
          return _decimalValue.toRadixString(8).toUpperCase();
        case 'DEC':
          return _decimalValue.toString();
        case 'HEX':
          return _decimalValue.toRadixString(16).toUpperCase();
        default:
          return '0';
      }
    } catch (e) {
      return '0';
    }
  }

  void _performBitwiseOperation(String operation) {
    try {
      int? secondValue = int.tryParse(_input, radix: _bases[_currentBase]!);
      if (secondValue == null) {
        throw FormatException('Invalid number format');
      }

      setState(() {
        switch (operation) {
          case 'AND':
            _decimalValue &= secondValue;
            break;
          case 'OR':
            _decimalValue |= secondValue;
            break;
          case 'XOR':
            _decimalValue ^= secondValue;
            break;
          case 'NOT':
            _decimalValue = ~_decimalValue;
            break;
          case 'LSH':
            _decimalValue <<= 1;
            break;
          case 'RSH':
            _decimalValue >>= 1;
            break;
        }

        _input = _getValueInBase(_currentBase);

        _firebaseService.addCalculationToHistory(
          'Operation: $operation',
          'Result: ${_getValueInBase(_currentBase)} ($_currentBase)',
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _clear() {
    setState(() {
      _input = '0';
      _decimalValue = 0;
    });
  }

  Widget _buildNumberButton(String number) {
    bool isEnabled = true;
    if (_currentBase == 'BIN' && !['0', '1'].contains(number)) {
      isEnabled = false;
    } else if (_currentBase == 'OCT' && !RegExp(r'^[0-7]+$').hasMatch(number)) {
      isEnabled = false;
    } else if (_currentBase == 'HEX' &&
        !RegExp(r'^[0-9A-F]$').hasMatch(number)) {
      isEnabled = false;
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: isEnabled ? () => _updateInput(number) : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          number,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget _buildOperationButton(String operation, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: () => _performBitwiseOperation(operation),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.all(20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          operation,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Programmer Calculator',
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: _bases.keys
                              .map((base) => ChoiceChip(
                                    label: Text(base),
                                    selected: _currentBase == base,
                                    onSelected: (selected) {
                                      if (selected) {
                                        setState(() {
                                          _currentBase = base;
                                          _input = _getValueInBase(base);
                                        });
                                      }
                                    },
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: theme.dividerColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _input,
                            style: const TextStyle(fontSize: 24),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildOperationButton('AND'),
                              _buildOperationButton('OR'),
                              _buildOperationButton('XOR'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildOperationButton('NOT'),
                              _buildOperationButton('LSH'),
                              _buildOperationButton('RSH'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: 4,
                              children: [
                                ...['7', '8', '9', 'A'].map(_buildNumberButton),
                                ...['4', '5', '6', 'B'].map(_buildNumberButton),
                                ...['1', '2', '3', 'C'].map(_buildNumberButton),
                                ...['0', 'D', 'E', 'F'].map(_buildNumberButton),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _clear,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(20.0),
                              minimumSize: const Size(double.infinity, 60),
                            ),
                            child: const Text('Clear',
                                style: TextStyle(fontSize: 20)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
