import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'mass_converter.dart';
import 'temperature_converter.dart';
import 'length_converter.dart';
import 'data_converter.dart';
import 'area_converter.dart';
import 'volume_converter.dart';

class UnitConverterScreen extends StatelessWidget {
  const UnitConverterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> converters = [
      {
        "label": "Mass Converter",
        "icon": FontAwesomeIcons.weightScale,
        "screen": const MassConverterScreen()
      },
      {
        "label": "Temperature Converter",
        "icon": FontAwesomeIcons.temperatureHalf,
        "screen": const TemperatureConverterScreen()
      },
      {
        "label": "Length Converter",
        "icon": FontAwesomeIcons.rulerVertical,
        "screen": const LengthConverterScreen()
      },
      {
        "label": "Data Converter",
        "icon": FontAwesomeIcons.database,
        "screen": const DataConverterScreen()
      },
      {
        "label": "Area Converter",
        "icon": FontAwesomeIcons.chartArea,
        "screen": const AreaConverterScreen()
      },
      {
        "label": "Volume Converter",
        "icon": FontAwesomeIcons.cube,
        "screen": const VolumeConverterScreen()
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Unit Converter"),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: converters.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            return _buildUnitConverterOption(
              context,
              converters[index]["label"],
              converters[index]["icon"],
              converters[index]["screen"],
            );
          },
        ),
      ),
    );
  }

  // Function to build clickable unit converter options
  Widget _buildUnitConverterOption(
      BuildContext context, String label, IconData icon, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
