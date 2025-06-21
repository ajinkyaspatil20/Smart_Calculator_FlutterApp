import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:mpl_lab/screens/all_calculations_screen.dart';
import 'dart:math';
import 'settings_screen.dart';
import '../services/firebase_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<HomeScreen> {
  String _expression = '';
  String _result = '';
  bool _isScientific = false;
  bool _isDegreeMode = true;
  final double _buttonSize = 80.0;
  final FirebaseService _firebaseService = FirebaseService();

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _expression = '';
        _result = '';
      } else if (buttonText == '⌫') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (buttonText == '=') {
        try {
          _result = _evaluateExpression(_expression);
          if (_result != 'Error') {
            _firebaseService.addCalculationToHistory(_expression, _result);
          }
        } catch (e) {
          _result = 'Error';
        }
      } else if (buttonText == 'DEG/RAD') {
        _isDegreeMode = !_isDegreeMode;
      } else {
        _expression += buttonText;
      }
    });
  }

  String _evaluateExpression(String expr) {
    try {
      expr = expr.replaceAll('×', '*').replaceAll('÷', '/');

      // Handle degree conversion if in degree mode
      if (_isDegreeMode) {
        expr =
            expr.replaceAllMapped(RegExp(r'(sin|cos|tan)\(([^)]+)\)'), (match) {
          String trigFunc = match.group(1)!;
          double value = double.parse(match.group(2)!);
          return '$trigFunc(${value * pi / 180})';
        });
      }

      // Handle scientific functions
      expr = expr.replaceAllMapped(
          RegExp(
              r'(sinh|cosh|tanh|log10|ln|√|exp|abs|asin|acos|atan|fact)\(([^)]+)\)'),
          (match) {
        String func = match.group(1)!;
        double value = double.parse(match.group(2)!);

        switch (func) {
          case 'sinh':
            return '((exp($value)-exp(-$value))/2)';
          case 'cosh':
            return '((exp($value)+exp(-$value))/2)';
          case 'tanh':
            return '((exp(2*$value)-1)/(exp(2*$value)+1))';
          case 'log10':
            return '(log($value)/ln10)';
          case 'ln':
            return '(log($value))';
          case '√':
            return '(sqrt($value))';
          case 'exp':
            return '(exp($value))';
          case 'abs':
            return '(abs($value))';
          case 'asin':
            return _isDegreeMode ? '(asin($value)*180/pi)' : '(asin($value))';
          case 'acos':
            return _isDegreeMode ? '(acos($value)*180/pi)' : '(acos($value))';
          case 'atan':
            return _isDegreeMode ? '(atan($value)*180/pi)' : '(atan($value))';
          case 'fact':
            return '(${_factorial(value.toInt())}.0)';
          default:
            return match.group(0)!;
        }
      });

      // Handle factorial operator
      expr = expr.replaceAllMapped(RegExp(r'(\d+)!'), (match) {
        return 'fact(${match.group(1)!})';
      });

      Parser p = Parser();
      Expression exp = p.parse(expr);
      ContextModel cm = ContextModel();

      double evalResult = exp.evaluate(EvaluationType.REAL, cm);

      // Format result
      if (evalResult % 1 == 0) {
        return evalResult.toInt().toString();
      } else {
        return evalResult
            .toStringAsFixed(6)
            .replaceAll(RegExp(r'0+$'), '')
            .replaceAll(r'.$', '');
      }
    } catch (e) {
      return 'Error';
    }
  }

  int _factorial(int n) => n <= 1 ? 1 : n * _factorial(n - 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scientific Calculator'),
        actions: [
          IconButton(
            icon: Icon(_isScientific ? Icons.calculate : Icons.science),
            onPressed: () {
              setState(() {
                _isScientific = !_isScientific;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildNavBar(), // NAVIGATION BAR MOVED TO THE TOP
          // Display
          Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _expression,
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  _result,
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                Text(
                  _isDegreeMode ? 'DEG' : 'RAD',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          // Buttons
          Expanded(
            child: _isScientific
                ? _buildScientificButtons()
                : _buildBasicButtons(),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBar() {
    return Container(
      color: Color(0xFF252525),
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _navBarButton("Home", FontAwesomeIcons.home, () {
            // Navigate to Home
            Navigator.popUntil(context, (route) => route.isFirst);
          }),
          SizedBox(width: 15),
          _navBarButton("All", FontAwesomeIcons.list, () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AllCalculatorsScreen()));
          }),
          SizedBox(width: 15),
          _navBarButton("Settings", FontAwesomeIcons.cog, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
          }),
        ],
      ),
    );
  }

  Widget _navBarButton(String label, IconData icon, VoidCallback onPressed) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: FaIcon(icon, color: Colors.white, size: 16),
      label: Text(label, style: TextStyle(color: Colors.white, fontSize: 14)),
    );
  }

  Widget _buildBasicButtons() {
    List<List<String>> buttonMatrix = [
      ['C', '÷', '×', '⌫'],
      ['7', '8', '9', '-'],
      ['4', '5', '6', '+'],
      ['1', '2', '3', '='],
      ['(', '0', ')', '.'],
    ];

    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: 20,
      itemBuilder: (context, index) {
        int row = index ~/ 4;
        int col = index % 4;
        String buttonText = buttonMatrix[row][col];

        return _buildButton(buttonText);
      },
    );
  }

  Widget _buildScientificButtons() {
    List<List<String>> buttonMatrix = [
      ['C', '÷', '×', '⌫', 'DEG/RAD'],
      ['7', '8', '9', '-', 'sin'],
      ['4', '5', '6', '+', 'cos'],
      ['1', '2', '3', '=', 'tan'],
      ['(', '0', ')', '.', '√'],
      ['sinh', 'cosh', 'tanh', '^', 'log10'],
      ['exp', 'ln', 'abs', '!', 'π'],
      ['asin', 'acos', 'atan', '(', ')'],
    ];

    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: 40,
      itemBuilder: (context, index) {
        int row = index ~/ 5;
        int col = index % 5;

        if (row < buttonMatrix.length && col < buttonMatrix[row].length) {
          return _buildButton(buttonMatrix[row][col]);
        } else {
          return Container(); // Empty container for unused grid cells
        }
      },
    );
  }

  Widget _buildButton(String buttonText) {
    Color buttonColor;
    Color textColor = Colors.black;

    if (buttonText == 'C') {
      buttonColor = Colors.red[400]!;
      textColor = Colors.white;
    } else if (buttonText == '=') {
      buttonColor = Colors.blue[400]!;
      textColor = Colors.white;
    } else if (buttonText == '⌫') {
      buttonColor = Colors.orange[400]!;
      textColor = Colors.white;
    } else if (['÷', '×', '-', '+', '^', 'DEG/RAD'].contains(buttonText)) {
      buttonColor = Colors.blueGrey[200]!;
    } else if (RegExp(r'[0-9.]').hasMatch(buttonText)) {
      buttonColor = Colors.grey[200]!;
    } else {
      buttonColor = Colors.grey[300]!;
    }

    return SizedBox(
      width: _buttonSize,
      height: _buttonSize,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: () => _onButtonPressed(buttonText),
        child: Text(
          buttonText,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
