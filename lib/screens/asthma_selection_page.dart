import 'package:breathe_ai/screens/bmi_calculator_page.dart';
import 'package:flutter/material.dart';

class AsthmaSelectionPage extends StatelessWidget {
  const AsthmaSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      String condition = "Asthma";

    return Scaffold(
            backgroundColor: Color(0xFF0A0F30),

      appBar: AppBar(
        title: const Text('Asthma Step Selection', style: TextStyle(color: Color(0xFF39FF14)),),backgroundColor: Color(0xFF0A0F30),
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
              'Select Asthma Step',
             style: TextStyle(
                color:  Color(0xFF39FF14),
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildStepButton(
              context,
              'Step 1 - Intermittent\n(Symptoms ≤2 days/week)',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  BMICalculatorPage(condition: condition, severity: "mild", )),
                );
              },
            ),
            const SizedBox(height: 15),
            _buildStepButton(
              context,
              'Step 2 - Mild Persistent\n(Symptoms >2 days/week)',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  BMICalculatorPage(condition: condition, severity: "moderate")),
                );
              },
            ),
            const SizedBox(height: 15),
            _buildStepButton(
              context,
              'Step 3 - Moderate Persistent\n(Daily symptoms)',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  BMICalculatorPage(condition: condition, severity: "severe")),
                );
              },
            ),
            const SizedBox(height: 15),
            _buildStepButton(
              context,
              'Step 4-5 - Severe Persistent\n(Throughout the day)',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BMICalculatorPage(condition: condition, severity: "very severe")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepButton(BuildContext context, String text, VoidCallback onPressed) {
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