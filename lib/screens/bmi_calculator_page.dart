import 'package:breathe_ai/screens/sensor_data_page.dart';
import 'package:flutter/material.dart';

class BMIData {
  final int age;
  final double weight;
  final double height;
  final String gender;
  final double bodyFat;
  final double bmi;
  final String bmiCategory;
  final String condition;
  final String severity;
  final bool smoking;

  BMIData(
      {required this.age,
      required this.weight,
      required this.height,
      required this.gender,
      required this.bodyFat,
      required this.bmi,
      required this.bmiCategory,
      required this.condition,
      required this.severity,
      required this.smoking});
}

class BMICalculatorPage extends StatefulWidget {
  final String condition; // Normal, Asthma, COPD
  final String severity; 

  const BMICalculatorPage({
    required this.condition,
    required this.severity,
    Key? key,
  }) : super(key: key);

  @override
  State<BMICalculatorPage> createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends State<BMICalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  int? age;
  double? weight;
  double? height;
  String? gender;
  double? bodyFat;
  double? bmi;
  String? bmiCategory;
  bool? smoking;
  int? feet;
  int? inches;
  double? weightLbs;

  void _calculateAndNavigate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Convert height to cm
      height = (feet! * 30.48) + (inches! * 2.54);

      // Convert weight to kg
      weight = weightLbs! * 0.453592;

      // Calculate BMI
      bmi = weight! / ((height! / 100) * (height! / 100));
      bmiCategory = _getBMICategory(bmi!);

      final bmiData = BMIData(
          age: age!,
          weight: weight!,
          height: height!,
          gender: gender!,
          bodyFat: bodyFat!,
          bmi: bmi!,
          bmiCategory: bmiCategory!,
          condition: widget.condition,
          severity: widget.severity,
          smoking: smoking!);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MultiSensorDataScreen(bmiData: bmiData),
        ),
      );
    }
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 25) {
      return 'Normal';
    } else if (bmi >= 25 && bmi < 30) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F30),
      appBar: AppBar(
        title: Text(
          '${widget.condition} - ${widget.severity}',
          style: const TextStyle(color: Color(0xFF39FF14)),
        ),
        backgroundColor: const Color(0xFF0A0F30),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Color(0xFF39FF14),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputField(
                label: 'Age',
                onSaved: (value) => age = int.parse(value!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              // Weight Input (Pounds)
              _buildInputField(
                label: 'Weight (lbs)',
                onSaved: (value) => weightLbs = double.parse(value!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight in pounds';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),

// Height Input (Feet)
              _buildInputField(
                label: 'Height (feet)',
                onSaved: (value) => feet = int.parse(value!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter height in feet';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),

// Height Input (Inches)
              _buildInputField(
                label: 'Height (inches)',
                onSaved: (value) => inches = int.parse(value!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter height in inches';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Gender',
                  labelStyle: const TextStyle(color: Color(0xFF39FF14)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF39FF14)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF39FF14)),
                  ),
                ),
                dropdownColor: const Color(0xFF0A0F30),
                style: const TextStyle(color: Color(0xFF39FF14)),
                items: ['Male', 'Female', 'Other']
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => gender = value),
                validator: (value) {
                  if (value == null) {
                    return 'Please select your gender';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Smoking',
                  labelStyle: const TextStyle(color: Color(0xFF39FF14)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF39FF14)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF39FF14)),
                  ),
                ),
                dropdownColor: const Color(0xFF0A0F30),
                style: const TextStyle(color: Color(0xFF39FF14)),
                items: ['yes', 'no']
                    .map((ans) => DropdownMenuItem(
                          value: ans,
                          child: Text(ans),
                        ))
                    .toList(),
                onChanged: (value) =>
                    setState(() => smoking = value == "yes" ? true : false),
                validator: (value) {
                  if (value == null) {
                    return 'Please select your smoking habit';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildInputField(
                label: 'Body Fat %',
                onSaved: (value) => bodyFat = double.parse(value!),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your body fat percentage';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _calculateAndNavigate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Color(0xFF39FF14), width: 2),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF39FF14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
    required TextInputType keyboardType,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF39FF14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF39FF14)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF39FF14)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      style: const TextStyle(color: Color(0xFF39FF14)),
      keyboardType: keyboardType,
      onSaved: onSaved,
      validator: validator,
    );
  }
}
