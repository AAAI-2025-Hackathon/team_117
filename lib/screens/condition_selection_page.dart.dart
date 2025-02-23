import 'package:breathe_ai/screens/asthma_selection_page.dart';
import 'package:breathe_ai/screens/bmi_calculator_page.dart';
import 'package:breathe_ai/screens/copd_selection_page.dart';
import 'package:flutter/material.dart';

class ConditionSelectionPage extends StatelessWidget {
  const ConditionSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0F30),
      appBar: AppBar(
        title: const Text('Breathe AI', style: TextStyle(color: Color(0xFF39FF14)),),backgroundColor: Color(0xFF0A0F30),
        centerTitle: true,
          iconTheme: IconThemeData(
    color: Color(0xFF39FF14), // Neon green color for the leading icon
  ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Please select your condition',
              style: TextStyle(
                color:  Color(0xFF39FF14),
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildConditionButton(context, 'Normal', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BMICalculatorPage(condition: "None", severity: "None")),
              );
            }),
            const SizedBox(height: 20),
            _buildConditionButton(context, 'Asthma', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AsthmaSelectionPage()),
              );
            }),
            const SizedBox(height: 20),
            _buildConditionButton(context, 'COPD', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const COPDSelectionPage()),
              );
            }),
          ],
        ),
      ),
    );
  }

Widget _buildConditionButton(BuildContext context, String text, VoidCallback onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(elevation: 0,
      backgroundColor: Colors.transparent, // Transparent background
      padding: const EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Color(0xFF39FF14), width: 2), // Neon green border
      ),
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        color: Color(0xFF39FF14), // Neon green text
      ),
    ),
  );
}
}
