const char *ssid = "1678";
const char *password = "12345678";
const int port = 1234;

const int input_length = 3;

WiFiServer server(port);

void SetupWifi(){
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED ) {
    delay(1000);
    Serial.print("Connecting to WiFi... ");
    Serial.println(WiFi.status());
  }

  Serial.println("Connected to WiFi");
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());

  server.begin();
}

void WifiLoop(){
  WiFiClient client = server.available();

  if (client) {
    Serial.println("Client connected");

    while (client.connected()) {
//      if (client.available() > 0) {
//        client.readStringUntil('\r\n');
//      }
      String data_to_send = Get_sensor_data();
      // Send data to the connected client
      client.println(data_to_send);  
//      Serial.println(data_to_send);
//      Serial.println("Sent: " + data_to_send);

      delay(2000); // Adjust the delay as needed
    }

    Serial.println("Client disconnected");
  }
}
