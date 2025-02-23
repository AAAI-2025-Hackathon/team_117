import 'dart:async';
import 'package:breathe_ai/screens/bmi_calculator_page.dart';
import 'package:flutter/material.dart';



class CombinedDataScreen extends StatefulWidget {
  final BMIData bmiData;
  final Stream<List<String>> sensor1Stream;
  final Stream<List<String>> sensor2Stream;

  const CombinedDataScreen({
    Key? key,
    required this.bmiData,
    required this.sensor1Stream,
    required this.sensor2Stream,
  }) : super(key: key);

  @override
  _CombinedDataScreenState createState() => _CombinedDataScreenState();
}

class _CombinedDataScreenState extends State<CombinedDataScreen> {
  List<String> _sensor1Data = ["Waiting for data..."];
  List<String> _sensor2Data = ["Waiting for data..."];
  late StreamSubscription<List<String>> _sensor1Subscription;
  late StreamSubscription<List<String>> _sensor2Subscription;

  @override
  void initState() {
    super.initState();

    // Listen to sensor 1 stream
    _sensor1Subscription = widget.sensor1Stream.listen((data) {
      setState(() {
        _sensor1Data = data;
      });
    });

    // Listen to sensor 2 stream
    _sensor2Subscription = widget.sensor2Stream.listen((data) {
      setState(() {
        _sensor2Data = data;
      });
    });
  }

  @override
  void dispose() {
    _sensor1Subscription.cancel();
    _sensor2Subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Combined Sensor Data"),
        backgroundColor: Color.fromARGB(255, 107, 255, 114),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 109, 109),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(child: Text("Dangerous Breathing conditions!!!", style: TextStyle(color: Colors.red, fontSize: 40),),),
            // const Text(
            //   "BMI Data:",
            //   style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            const SizedBox(height: 10),
            // Text(
            //   "BMI: ${widget.bmiData.bmi}, Category: ${widget.bmiData.category}",
            //   style: const TextStyle(color: Colors.white, fontSize: 16),
            // ),
            // const Divider(color: Colors.grey),
            // const SizedBox(height: 10),
            // const Text(
            //   "Sensor 1 Data:",
            //   style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            // Text(
            //   _sensor1Data.join(", "), // Convert List<String> to a single String for display
            //   style: const TextStyle(color: Colors.green, fontSize: 16),
            // ),
            // const SizedBox(height: 20),
            // const Text(
            //   "Sensor 2 Data:",
            //   style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            // Text(
            //   _sensor2Data.join(", "), // Convert List<String> to a single String for display
            //   style: const TextStyle(color: Colors.green, fontSize: 16),
            // ),
          ],
        ),
      ),
    );
  }
}
