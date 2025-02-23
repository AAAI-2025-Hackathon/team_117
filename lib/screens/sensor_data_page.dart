import 'package:breathe_ai/screens/bmi_calculator_page.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';

class SensorDataScreen extends StatefulWidget {
  final BMIData bmiData;
  
  const SensorDataScreen({
    required this.bmiData,
    super.key,
  });

  @override
  State<SensorDataScreen> createState() => _SensorDataScreenState();
}

class _SensorDataScreenState extends State<SensorDataScreen> {
  Socket? socket;
  bool _isConnected = false;
  final TextEditingController _ipController = TextEditingController();
  final List<String> _sensorDataHistory = [];
  final ScrollController _scrollController = ScrollController();
  final StreamController<List<String>> _sensorDataStreamController = 
      StreamController<List<String>>.broadcast();

  @override
  void initState() {
    super.initState();
    _ipController.text = "192.168.137.202";
  }

  Future<void> connectToESP32() async {
    try {
      socket = await Socket.connect(_ipController.text, 1234);
      setState(() => _isConnected = true);

      socket!.listen(
        (List<int> data) {
          final receivedData = String.fromCharCodes(data).trim();
          final timestamp = DateTime.now().toIso8601String();
          setState(() {
            _sensorDataHistory.add('[$timestamp] $receivedData');
            _sensorDataStreamController.add(_sensorDataHistory);
          });
          
          // Auto-scroll to bottom when new data arrives
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        },
        onError: (error) {
          print('Error: $error');
          disconnectFromESP32();
        },
        onDone: () {
          print('Server disconnected');
          disconnectFromESP32();
        },
      );
    } catch (e) {
      print('Failed to connect: $e');
      setState(() {
        _isConnected = false;
      });
    }
  }

  void disconnectFromESP32() {
    socket?.destroy();
    setState(() {
      _isConnected = false;
      socket = null;
    });
  }

  void clearData() {
    setState(() {
      _sensorDataHistory.clear();
      _sensorDataStreamController.add(_sensorDataHistory);
    });
  }

  @override
  void dispose() {
    socket?.destroy();
    _sensorDataStreamController.close();
    _ipController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F30),
      appBar: AppBar(
        title: const Text(
          'ESP32 Sensor Data',
          style: TextStyle(color: Color(0xFF39FF14)),
        ),
        backgroundColor: const Color(0xFF0A0F30),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Color(0xFF39FF14),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: clearData,
            color: const Color(0xFF39FF14),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _ipController,
              style: const TextStyle(color: Color(0xFF39FF14)),
              decoration: const InputDecoration(
                labelText: 'ESP32 IP Address',
                hintText: 'Enter ESP32 IP address',
                hintStyle: TextStyle(color: Color(0xFF39FF14)),
                labelStyle: TextStyle(color: Color(0xFF39FF14)),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF39FF14), width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF39FF14), width: 3.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF39FF14), width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isConnected ? disconnectFromESP32 : connectToESP32,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 15),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                    color: Color(0xFF39FF14),
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                _isConnected ? 'Disconnect' : 'Connect',
                style: const TextStyle(color: Color(0xFF39FF14)),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sensor Data History:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF39FF14),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF39FF14)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Count: ${_sensorDataHistory.length}',
                    style: const TextStyle(
                      color: Color(0xFF39FF14),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<String>>(
                stream: _sensorDataStreamController.stream,
                initialData: _sensorDataHistory,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Color(0xFF39FF14)),
                      ),
                    );
                  }

                  final data = snapshot.data ?? [];
                  
                  if (data.isEmpty) {
                    return const Center(
                      child: Text(
                        'No sensor data available',
                        style: TextStyle(color: Color(0xFF39FF14)),
                      ),
                    );
                  }

                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF39FF14)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: index < data.length - 1
                                ? Border(
                                    bottom: BorderSide(
                                      color: Color(0xFF39FF14).withOpacity(0.3),
                                    ),
                                  )
                                : null,
                          ),
                          child: ListTile(
                            dense: true,
                            title: Text(
                              data[index],
                              style: const TextStyle(
                                color: Color(0xFF39FF14),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isConnected ? const Color(0xFF39FF14) : Colors.red,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _isConnected ? 'Connected' : 'Disconnected',
                  style: TextStyle(
                    color: _isConnected ? const Color(0xFF39FF14) : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}