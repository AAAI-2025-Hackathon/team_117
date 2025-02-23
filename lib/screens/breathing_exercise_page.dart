import 'package:breathe_ai/screens/sensor_data_page.dart';
import 'package:flutter/material.dart';
// import 'dart:math' as math;

class BreathingExercisePage extends StatefulWidget {
  const BreathingExercisePage({Key? key}) : super(key: key);

  @override
  State<BreathingExercisePage> createState() => _BreathingExercisePageState();
}

class _BreathingExercisePageState extends State<BreathingExercisePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breathing Exercise', style: TextStyle(color: Color(0xFF39FF14)),),backgroundColor: Color(0xFF0A0F30),
        centerTitle: true,
          iconTheme: IconThemeData(
    color: Color(0xFF39FF14), // Neon green color for the leading icon
  ),
      ),
      backgroundColor: Color(0xFF0A0F30),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // AnimatedBuilder(
            //   animation: _animation,
            //   builder: (context, child) {
            //     return Container(
            //       width: 200 * _animation.value,
            //       height: 200 * _animation.value,
            //       decoration: BoxDecoration(
            //         shape: BoxShape.circle,
            //         color: Color(0xFF39FF14).withOpacity(0.3),
            //         // border: Border.all(
            //         //   color: Colors.blue,
            //         //   width: 2,
            //         // ),
            //       ),
            //       // child: Center(
            //       //   child: Text(
            //       //     _animation.value < 0.75 ? 'Breathe In' : 'Breathe Out',
            //       //     style: const TextStyle(
            //       //       fontSize: 20,
            //       //       color: Color(0xFF39FF14),
            //       //       fontWeight: FontWeight.bold,
            //       //     ),
            //       //   ),
            //       // ),
            //     );
            //   },
            // ),
          
          // SensorDataScreen()
          ],
        ),
      ),
    );
  }
}