import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'time_unit_calculator.dart';
import 'currency_converter.dart';
import 'unit_converter.dart';
import 'date_calculation.dart';
import 'formulas.dart';
import 'finance_calculator.dart';
import 'health_calculator.dart';
import 'programmer_calculator.dart';

class AllCalculatorsScreen extends StatelessWidget {
  const AllCalculatorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("All Calculators"),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: GridView.count(
        padding: EdgeInsets.all(12),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          _buildCalculatorButton(
              context, "Formulas", FontAwesomeIcons.calculator, Colors.orange),
          _buildCalculatorButton(context, "Time Converter & Calculations",
              FontAwesomeIcons.clock, Colors.green),
          _buildCalculatorButton(context, "Currency Converter",
              FontAwesomeIcons.moneyBill, Colors.blue),
          _buildCalculatorButton(
              context, "Unit Converter", FontAwesomeIcons.ruler, Colors.purple),
          _buildCalculatorButton(context, "Finance Calculator",
              FontAwesomeIcons.calculator, Colors.red),
          _buildCalculatorButton(context, "Date Calculations",
              FontAwesomeIcons.calendar, Colors.teal),
          _buildCalculatorButton(context, "Health Calculator",
              FontAwesomeIcons.heartPulse, Colors.red),
          _buildCalculatorButton(context, "Programmer Calculator",
              FontAwesomeIcons.code, Colors.indigo),
        ],
      ),
    );
  }

  Widget _buildCalculatorButton(
      BuildContext context, String label, IconData icon, Color color) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        print("$label button tapped!"); // 🔍 Debugging Print

        if (label == "Unit Converter") {
          // ✅ Open Unit Converter Screen
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => UnitConverterScreen()));
        } else if (label == "Finance Calculator") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FinanceCalculatorScreen()));
        } else if (label == "Time Converter & Calculations") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => TimeUnitCalculator()));
        } else if (label == "Currency Converter") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CurrencyConverterScreen()));
        } else if (label == "Date Calculations") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DateCalculationScreen()));
        } else if (label == "Formulas") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => FormulasScreen()));
        } else if (label == "Health Calculator") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HealthCalculatorScreen()));
        } else if (label == "Programmer Calculator") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProgrammerCalculatorScreen()));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, size: 40, color: theme.colorScheme.onPrimary),
            SizedBox(height: 10),
            Text(label,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w500,
                )),
          ],
        ),
      ),
    );
  }
}
