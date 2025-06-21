import 'package:flutter/material.dart';

class TimeUnitCalculator extends StatefulWidget {
  @override
  _TimeUnitCalculatorState createState() => _TimeUnitCalculatorState();
}

class _TimeUnitCalculatorState extends State<TimeUnitCalculator> {
  double inputValue = 0;
  double convertedValue = 0;
  String fromUnit = 'Seconds';
  String toUnit = 'Minutes';

  final Map<String, double> timeUnits = {
    'Seconds': 1,
    'Minutes': 60,
    'Hours': 3600,
    'Days': 86400,
  };

  void convert() {
    setState(() {
      convertedValue = (inputValue * timeUnits[fromUnit]!) / timeUnits[toUnit]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Unit Converter', style: theme.textTheme.titleLarge),  // ✅ FIXED
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter value',
                labelStyle: theme.textTheme.bodyLarge,  // ✅ FIXED
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  inputValue = double.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: fromUnit,
                    decoration: InputDecoration(labelText: 'From'),
                    items: timeUnits.keys.map((String unit) {
                      return DropdownMenuItem<String>(
                        value: unit,
                        child: Text(unit),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        fromUnit = newValue!;
                        convert();
                      });
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: toUnit,
                    decoration: InputDecoration(labelText: 'To'),
                    items: timeUnits.keys.map((String unit) {
                      return DropdownMenuItem<String>(
                        value: unit,
                        child: Text(unit),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        toUnit = newValue!;
                        convert();
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: convert,
              child: Text('Convert'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, // ✅ FIXED
                backgroundColor: theme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Converted Value: $convertedValue $toUnit',
              style: theme.textTheme.titleLarge,  // ✅ FIXED
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
