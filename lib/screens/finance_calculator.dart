import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'loan_emi_calculator.dart';
import 'investment_calculator.dart';
import 'mortgage_calculator.dart';

class FinanceCalculatorScreen extends StatelessWidget {
  const FinanceCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> calculators = [
      {
        "label": "Loan EMI Calculator",
        "icon": FontAwesomeIcons.creditCard,
        "screen": const LoanEmiCalculator()
      },
      {
        "label": "Investment Calculator",
        "icon": FontAwesomeIcons.chartLine,
        "screen": const InvestmentCalculator()
      },
      {
        "label": "Mortgage Calculator",
        "icon": FontAwesomeIcons.home,
        "screen": const MortgageCalculator()
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Finance Calculator"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: calculators.length,
        itemBuilder: (context, index) {
          final calculator = calculators[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => calculator["screen"]),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    calculator["icon"],
                    size: 40,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    calculator["label"],
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
