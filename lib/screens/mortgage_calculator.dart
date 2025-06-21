import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math';
import '../services/firebase_service.dart';

class MortgageCalculator extends StatefulWidget {
  const MortgageCalculator({super.key});

  @override
  _MortgageCalculatorState createState() => _MortgageCalculatorState();
}

class _MortgageCalculatorState extends State<MortgageCalculator> {
  final TextEditingController homeValueController = TextEditingController();
  final TextEditingController downPaymentController = TextEditingController();
  final TextEditingController interestRateController = TextEditingController();
  final TextEditingController loanTermController = TextEditingController();

  double monthlyPayment = 0.0;
  double totalPayment = 0.0;
  double totalInterest = 0.0;
  double loanAmount = 0.0;

  final FirebaseService _firebaseService = FirebaseService();

  void calculateMortgage() {
    double H = double.tryParse(homeValueController.text) ?? 0.0;
    double D = double.tryParse(downPaymentController.text) ?? 0.0;
    double r = (double.tryParse(interestRateController.text) ?? 0.0) /
        100 /
        12; // Monthly rate
    double t = (double.tryParse(loanTermController.text) ?? 0.0) * 12; // Months

    if (H == 0 || r == 0 || t == 0) {
      setState(() {
        monthlyPayment = 0.0;
        totalPayment = 0.0;
        totalInterest = 0.0;
        loanAmount = 0.0;
      });
      return;
    }

    // Calculate loan amount after down payment
    double P = H - D;

    // Calculate monthly payment using mortgage formula
    double M = P * (r * pow(1 + r, t)) / (pow(1 + r, t) - 1);

    // Calculate total payment and interest
    double total = M * t;
    double interest = total - P;

    setState(() {
      monthlyPayment = M;
      totalPayment = total;
      totalInterest = interest;
      loanAmount = P;
    });

    // Add to Firebase history
    _firebaseService.addCalculationToHistory(
      'Mortgage: Home: ₹$H, Down: ₹$D, Rate: ${r * 1200}%, Term: ${t / 12} years',
      'Monthly Payment: ₹${M.toStringAsFixed(2)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mortgage Calculator',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
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
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(homeValueController, "Home Value (₹)",
                          FontAwesomeIcons.home),
                      const SizedBox(height: 16),
                      _buildTextField(downPaymentController, "Down Payment (₹)",
                          FontAwesomeIcons.moneyBillWave),
                      const SizedBox(height: 16),
                      _buildTextField(interestRateController,
                          "Annual Interest Rate (%)", FontAwesomeIcons.percent),
                      const SizedBox(height: 16),
                      _buildTextField(loanTermController, "Loan Term (Years)",
                          FontAwesomeIcons.calendar),
                    ],
                  ),
                ),

                // Calculate Button
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 24),
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: calculateMortgage,
                    style: Theme.of(context).elevatedButtonTheme.style,
                    icon: Icon(FontAwesomeIcons.calculator,
                        color: Theme.of(context).colorScheme.onPrimary),
                    label: Text(
                      "Calculate Mortgage",
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                // Results Display
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
                      _buildResultRow("Monthly Payment", monthlyPayment),
                      const Divider(color: Colors.white30, height: 32),
                      _buildResultRow("Loan Amount", loanAmount),
                      const SizedBox(height: 16),
                      _buildResultRow("Total Payment", totalPayment),
                      const SizedBox(height: 16),
                      _buildResultRow("Total Interest", totalInterest),
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
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            letterSpacing: 1,
          ),
        ),
        Text(
          "₹${value.toStringAsFixed(2)}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
