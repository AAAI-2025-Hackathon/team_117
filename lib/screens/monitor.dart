// websocket_service.dart
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  Function(Map<String, dynamic>)? onDataReceived;

  bool get isConnected => _channel != null;

  void connect(String ipAddress) {
    try {
      _channel = IOWebSocketChannel.connect('ws://$ipAddress:81');
      _channel?.stream.listen(
        (message) {
          try {
            final data = jsonDecode(message);
            if (onDataReceived != null) {
              onDataReceived!(data);
            }
          } catch (e) {
            print('Error parsing message: $e');
          }
        },
        onError: (error) {
          print('WebSocket error: $error');
          disconnect();
        },
        onDone: () {
          print('WebSocket connection closed');
          disconnect();
        },
      );
    } catch (e) {
      print('Error connecting to WebSocket: $e');
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }

  void dispose() {
    disconnect();
  }
}

// sensor_data_page.dart
