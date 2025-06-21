import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/firebase_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  _CurrencyConverterScreenState createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController amountController = TextEditingController();

  String fromCurrency = "INR";
  String toCurrency = "USD";
  double convertedAmount = 0.0;
  bool isLoading = false;

  // 🔹 Available Currencies
  final List<String> currencies = [
    "INR",
    "USD",
    "EUR",
    "GBP",
    "JPY",
    "AUD",
    "CAD",
    "CHF",
    "CNY",
    "AED"
  ];

  final FirebaseService _firebaseService = FirebaseService();

  Future<void> convertCurrency() async {
    setState(() {
      isLoading = true;
    });

    String apiKey =
        "Orlr88ssoaAuRalJ1ZURjHbjNUfaX51q"; //  API Key
    String url =
        "https://api.apilayer.com/exchangerates_data/latest?base=$fromCurrency&symbols=$toCurrency";

    try {
      final response =
          await http.get(Uri.parse(url), headers: {"apikey": apiKey});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["rates"] != null && data["rates"].containsKey(toCurrency)) {
          double rate = data["rates"][toCurrency];
          double amount = double.tryParse(amountController.text) ?? 0.0;

          if (amount <= 0) {
            throw Exception("Please enter a valid amount greater than zero.");
          }

          setState(() {
            convertedAmount = amount * rate;
            isLoading = false;
          });

          // Add to Firebase history
          _firebaseService.addCalculationToHistory(
            '$amount $fromCurrency to $toCurrency', // Pass the history entry as the expression
            '${convertedAmount.toStringAsFixed(2)} $toCurrency', // Pass the result
          );

        } else {
          throw Exception("Invalid response structure from the API.");
        }
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Currency Converter"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔹 Amount Input Box
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  labelText: "Enter Amount",
                  labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                  border: Theme.of(context).inputDecorationTheme.border,
                  enabledBorder:
                      Theme.of(context).inputDecorationTheme.enabledBorder,
                  focusedBorder:
                      Theme.of(context).inputDecorationTheme.focusedBorder,
                  prefixIcon: Icon(Icons.attach_money),
                ),
              ),
            ),

            // 🔹 Currency Selection (From)
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).inputDecorationTheme.fillColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 1),
                    ),
                    child: DropdownButton<String>(
                      value: fromCurrency,
                      dropdownColor:
                          Theme.of(context).inputDecorationTheme.fillColor,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 16),
                      icon: Icon(Icons.arrow_drop_down,
                          color: Theme.of(context).iconTheme.color),
                      isExpanded: true,
                      underline: Container(),
                      onChanged: (value) {
                        setState(() {
                          fromCurrency = value!;
                        });
                      },
                      items: currencies.map((currency) {
                        return DropdownMenuItem(
                          value: currency,
                          child: Text(currency),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Theme.of(context).iconTheme.color,
                    size: 24,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).inputDecorationTheme.fillColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 1),
                    ),
                    child: DropdownButton<String>(
                      value: toCurrency,
                      dropdownColor:
                          Theme.of(context).inputDecorationTheme.fillColor,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 16),
                      icon: Icon(Icons.arrow_drop_down,
                          color: Theme.of(context).iconTheme.color),
                      isExpanded: true,
                      underline: Container(),
                      onChanged: (value) {
                        setState(() {
                          toCurrency = value!;
                        });
                      },
                      items: currencies.map((currency) {
                        return DropdownMenuItem(
                          value: currency,
                          child: Text(currency),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),

            // 🔹 Convert Button
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : convertCurrency,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.onPrimary),
                      )
                    : Text(
                        "Convert",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                      ),
              ),
            ),

            // 🔹 Result Display
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: Theme.of(context).primaryColor, width: 1),
              ),
              child: Column(
                children: [
                  Text(
                    "${amountController.text.isEmpty ? '0.00' : amountController.text} $fromCurrency = ",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${convertedAmount.toStringAsFixed(2)} $toCurrency",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
