import 'package:breathe_ai/screens/combined_data.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:breathe_ai/screens/bmi_calculator_page.dart';

class MultiSensorDataScreen extends StatefulWidget {
  final BMIData bmiData;

  const MultiSensorDataScreen({
    required this.bmiData,
    super.key,
  });

  @override
  State<MultiSensorDataScreen> createState() => _MultiSensorDataScreenState();
}

class _MultiSensorDataScreenState extends State<MultiSensorDataScreen> {
  Socket? socket1;
  Socket? socket2;
  bool _isConnected1 = false;
  bool _isConnected2 = false;
  
  final TextEditingController _ip1Controller = TextEditingController();
  final TextEditingController _port1Controller = TextEditingController();
  final TextEditingController _ip2Controller = TextEditingController();
  final TextEditingController _port2Controller = TextEditingController();
  
  final List<String> _sensor1DataHistory = [];
  final List<String> _sensor2DataHistory = [];
  
  final ScrollController _scroll1Controller = ScrollController();
  final ScrollController _scroll2Controller = ScrollController();
  
  final StreamController<List<String>> _sensor1DataStreamController =
      StreamController<List<String>>.broadcast();
  final StreamController<List<String>> _sensor2DataStreamController =
      StreamController<List<String>>.broadcast();

  @override
  void initState() {
    super.initState();
    _ip1Controller.text = "192.168.137.202";
    _port1Controller.text = "7000";
    _ip2Controller.text = "192.168.137.203";
    _port2Controller.text = "7001";
  }

  Future<Socket?> connectToESP32(Socket? socket, String ip, int port, 
      void Function(bool) setConnected, List<String> dataHistory,
      StreamController<List<String>> streamController,
      ScrollController scrollController) async {
    try {
      socket = await Socket.connect(ip, port);
      setConnected(true);

      socket.listen(
        (List<int> data) {
          final receivedData = String.fromCharCodes(data).trim();
          final timestamp = DateTime.now().toIso8601String();
          setState(() {
            dataHistory.add('[$timestamp] $receivedData');
            streamController.add(dataHistory);
          });

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients) {
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        },
        onError: (error) {
          print('Error: $error');
          disconnectFromESP32(socket, setConnected);
        },
        onDone: () {
          print('Server disconnected');
          disconnectFromESP32(socket, setConnected);
        },
      );
    } catch (e) {
      print('Failed to connect: $e');
      setConnected(false);
    }
    return socket;
  }

  void disconnectFromESP32(Socket? socket, void Function(bool) setConnected) {
    socket?.destroy();
    setConnected(false);
    socket = null;
  }

  void clearData() {
    setState(() {
      _sensor1DataHistory.clear();
      _sensor2DataHistory.clear();
      _sensor1DataStreamController.add(_sensor1DataHistory);
      _sensor2DataStreamController.add(_sensor2DataHistory);
    });
  }

  @override
  void dispose() {
    socket1?.destroy();
    socket2?.destroy();
    _sensor1DataStreamController.close();
    _sensor2DataStreamController.close();
    _ip1Controller.dispose();
    _ip2Controller.dispose();
    _port1Controller.dispose();
    _port2Controller.dispose();
    _scroll1Controller.dispose();
    _scroll2Controller.dispose();
    super.dispose();
  }

  Widget buildSensorDataSection(
    String title,
    TextEditingController ipController,
    TextEditingController portController,
    bool isConnected,
    List<String> dataHistory,
    StreamController<List<String>> streamController,
    ScrollController scrollController,
    Function() onConnectPress,
  ) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF39FF14),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: ipController,
          style: const TextStyle(color: Color(0xFF39FF14)),
          decoration: InputDecoration(
            labelText: 'ESP32 IP Address',
            hintText: 'Enter ESP32 IP address',
            hintStyle: const TextStyle(color: Color(0xFF39FF14)),
            labelStyle: const TextStyle(color: Color(0xFF39FF14)),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF39FF14), width: 2.0),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF39FF14), width: 3.0),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF39FF14), width: 2.0),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: portController,
          style: const TextStyle(color: Color(0xFF39FF14)),
          decoration: InputDecoration(
            labelText: 'ESP32 Port',
            hintText: 'Enter ESP32 Port',
            hintStyle: const TextStyle(color: Color(0xFF39FF14)),
            labelStyle: const TextStyle(color: Color(0xFF39FF14)),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF39FF14), width: 2.0),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF39FF14), width: 3.0),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF39FF14), width: 2.0),
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: onConnectPress,
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
            isConnected ? 'Disconnect' : 'Connect',
            style: const TextStyle(color: Color(0xFF39FF14)),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: StreamBuilder<List<String>>(
            stream: streamController.stream,
            initialData: dataHistory,
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

              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF39FF14)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: index < data.length - 1
                            ? Border(
                                bottom: BorderSide(
                                  color: const Color(0xFF39FF14).withOpacity(0.3),
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F30),
      appBar: AppBar(
        title: const Text(
          'Dual ESP32 Sensor Data',
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
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: buildSensorDataSection(
                      'Sensor 1',
                      _ip1Controller,
                      _port1Controller,
                      _isConnected1,
                      _sensor1DataHistory,
                      _sensor1DataStreamController,
                      _scroll1Controller,
                      () {
                        if (_isConnected1) {
                          disconnectFromESP32(socket1, (connected) {
                            setState(() => _isConnected1 = connected);
                          });
                        } else {
                          connectToESP32(
                            socket1,
                            _ip1Controller.text,
                            int.parse(_port1Controller.text),
                            (connected) {
                              setState(() => _isConnected1 = connected);
                            },
                            _sensor1DataHistory,
                            _sensor1DataStreamController,
                            _scroll1Controller,
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildSensorDataSection(
                      'Sensor 2',
                      _ip2Controller,
                      _port2Controller,
                      _isConnected2,
                      _sensor2DataHistory,
                      _sensor2DataStreamController,
                      _scroll2Controller,
                      () {
                        if (_isConnected2) {
                          disconnectFromESP32(socket2, (connected) {
                            setState(() => _isConnected2 = connected);
                          });
                        } else {
                          connectToESP32(
                            socket2,
                            _ip2Controller.text,
                            int.parse(_port2Controller.text),
                            (connected) {
                              setState(() => _isConnected2 = connected);
                            },
                            _sensor2DataHistory,
                            _sensor2DataStreamController,
                            _scroll2Controller,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (_isConnected1 && _isConnected2)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the combined data view
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CombinedDataScreen(
                          bmiData: widget.bmiData,
                          sensor1Stream: _sensor1DataStreamController.stream,
                          sensor2Stream: _sensor2DataStreamController.stream,
                        ),
                      ),
                    );
                  },
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
                  child: const Text(
                    'View Combined Data',
                    style: TextStyle(color: Color(0xFF39FF14)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}