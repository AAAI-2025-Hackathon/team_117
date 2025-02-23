import 'package:breathe_ai/screens/bmi_calculator_page.dart';
import 'package:flutter/material.dart';

class COPDSelectionPage extends StatelessWidget {
  const COPDSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String condition = "COPD";
    return Scaffold(
      backgroundColor: Color(0xFF0A0F30),
      appBar: AppBar(
        title: const Text(
          'COPD Stage Selection',
          style: TextStyle(color: Color(0xFF39FF14)),
        ),
        backgroundColor: Color(0xFF0A0F30),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color(0xFF39FF14), // Neon green color for the leading icon
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select COPD Stage (FEV1)',
              style: TextStyle(
                color: Color(0xFF39FF14),
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildStageButton(context, 'Stage 1 - Mild (≥80%)', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BMICalculatorPage(condition: condition, severity: "mild")),
              );
            }),
            const SizedBox(height: 15),
            _buildStageButton(context, 'Stage 2 - Moderate (50-79%)', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BMICalculatorPage(condition: condition, severity: "moderate")),
              );
            }),
            const SizedBox(height: 15),
            _buildStageButton(context, 'Stage 3 - Severe (30-49%)', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BMICalculatorPage(condition: condition, severity: "severe")),
              );
            }),
            const SizedBox(height: 15),
            _buildStageButton(context, 'Stage 4 - Very Severe (<30%)', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BMICalculatorPage(condition: condition, severity: "very severe")),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStageButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.transparent, // Transparent background
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
              color: Color(0xFF39FF14), width: 2), // Neon green border
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
