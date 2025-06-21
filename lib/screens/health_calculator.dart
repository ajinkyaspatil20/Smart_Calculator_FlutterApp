import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';
import 'bmi_calculator.dart';
import 'water_intake_calculator.dart';
import 'pregnancy_calculator.dart';
import 'child_growth_calculator.dart';

class HealthCalculatorScreen extends StatelessWidget {
  const HealthCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Health Calculator',
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
              theme.scaffoldBackgroundColor,
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildCalculatorCard(
                context,
                'BMI Calculator',
                Icons.monitor_weight,
                Colors.blue,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BMICalculatorScreen(),
                    ),
                  );
                },
              ),
              _buildCalculatorCard(
                context,
                'Water Intake',
                Icons.water_drop,
                Colors.cyan,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WaterIntakeCalculatorScreen(),
                    ),
                  );
                },
              ),
              _buildCalculatorCard(
                context,
                'Pregnancy Calculator',
                Icons.pregnant_woman,
                Colors.pink,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PregnancyCalculatorScreen(),
                    ),
                  );
                },
              ),
              _buildCalculatorCard(
                context,
                'Child Growth',
                Icons.child_care,
                Colors.green,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChildGrowthCalculatorScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalculatorCard(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
