const char *ssid = "1678";
const char *password = "12345678";
const int port = 7000;

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

void WifiLoop() {
    WiFiClient client = server.available();
    

    if (client) {
        Serial.println("Client connected");

        while (client.connected()) {
              // Call PMSloop and get the data as a string
          
            String data_to_send = PMSloop();
              // Adjust the delay as needed
                client.println(data_to_send);    // Send the data to the client
        }

        Serial.println("Client disconnected");
    }
}
