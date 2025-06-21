import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math';
import '../services/firebase_service.dart';

class LoanEmiCalculator extends StatefulWidget {
  const LoanEmiCalculator({super.key});

  @override
  _LoanEmiCalculatorState createState() => _LoanEmiCalculatorState();
}

class _LoanEmiCalculatorState extends State<LoanEmiCalculator> {
  final TextEditingController loanAmountController = TextEditingController();
  final TextEditingController interestRateController = TextEditingController();
  final TextEditingController tenureController = TextEditingController();

  double emiResult = 0.0;

  final FirebaseService _firebaseService = FirebaseService();

  void calculateEMI() {
    double P = double.tryParse(loanAmountController.text) ?? 0.0;
    double annualRate = double.tryParse(interestRateController.text) ?? 0.0;
    double tenureMonths = double.tryParse(tenureController.text) ?? 0.0;

    if (P == 0 || annualRate == 0 || tenureMonths == 0) {
      setState(() {
        emiResult = 0.0;
      });
      return;
    }

    double r = (annualRate / 12) / 100; // Monthly interest rate
    double n = tenureMonths; // Loan tenure in months

    double emi = (P * r * pow((1 + r), n)) / (pow((1 + r), n) - 1);

    setState(() {
      emiResult = emi;
    });

    // Add to Firebase history
    _firebaseService.addCalculationToHistory(
      'Principal: ₹$P, Rate: $annualRate%, Tenure: $tenureMonths months', // Pass the history entry as the expression
      'EMI: ₹${emi.toStringAsFixed(2)}', // Pass the result
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Loan EMI Calculator',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // EMI Banner Image
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: Image.asset(
                    "assets/images/EMI-Calculator.png",
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),

                // Input fields section
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.5),
                        width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(loanAmountController, "Loan Amount (₹)",
                          FontAwesomeIcons.rupeeSign),
                      const SizedBox(height: 16),
                      _buildTextField(interestRateController,
                          "Annual Interest Rate (%)", FontAwesomeIcons.percent),
                      const SizedBox(height: 16),
                      _buildTextField(tenureController, "Loan Tenure (Months)",
                          FontAwesomeIcons.calendar),
                    ],
                  ),
                ),

                // Calculate Button
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 24),
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: calculateEMI,
                    style: Theme.of(context).elevatedButtonTheme.style,
                    icon: Icon(FontAwesomeIcons.calculator,
                        color: Theme.of(context).colorScheme.onPrimary),
                    label: Text(
                      "Calculate EMI",
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                // EMI Result Display
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.primary.withOpacity(0.8)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.moneyBillWave,
                              color: Colors.white, size: 24),
                          SizedBox(width: 12),
                          Text(
                            "Monthly EMI",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                letterSpacing: 1),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "₹${emiResult.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black.withOpacity(0.6),
            labelText: label,
            labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            prefixIcon: Icon(icon, color: Colors.deepPurple, size: 20),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.deepPurple.withOpacity(0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
            )),
      ),
    );
  }
}
