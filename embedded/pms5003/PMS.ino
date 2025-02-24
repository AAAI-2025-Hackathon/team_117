
void PMSSetup() {
    Serial.begin(115200);  
    pmsSerial.begin(9600, SERIAL_8N1, RX_PIN, TX_PIN);
    Serial.println("PMS5003 Reader Initialized...");
}

unsigned long previousMillis = 0;  // Stores the last time the sensor data was read
const long interval = 2000;         // Interval to read data every 2 seconds (2000 ms)

String PMSloop() {
    String sensorData = "PM1.0: 0 µg/m³, PM2.5: 0 µg/m³, PM10: 0 µg/m³";;  // String to hold sensor data

    // Get the current time
    unsigned long currentMillis = millis();

    // Check if 2 seconds have passed
    if (currentMillis - previousMillis >= interval) {
        previousMillis = currentMillis;  // Save the last time we read data

        // Check if enough data is available to read
        if (pmsSerial.available() >= 32) {
            if (pmsSerial.read() == 0x42 && pmsSerial.read() == 0x4D) {  // PMS5003 packet starts with 'BM'
                buffer[0] = 0x42;
                buffer[1] = 0x4D;
                
                for (int i = 2; i < 32; i++) {
                    buffer[i] = pmsSerial.read();
                }
                
                uint16_t pm1_0  = (buffer[10] << 8) | buffer[11];  // PM1.0 (CF=1)
                uint16_t pm2_5  = (buffer[12] << 8) | buffer[13];  // PM2.5 (CF=1)
                uint16_t pm10   = (buffer[14] << 8) | buffer[15];  // PM10 (CF=1)

                // Format the data into a string
                sensorData = "PM1.0: " + String(pm1_0) + " µg/m³, PM2.5: " + String(pm2_5) + " µg/m³, PM10: " + String(pm10) + " µg/m³";

                
            Serial.print("PM1.0: "); Serial.print(pm1_0);
            Serial.print(" µg/m³, PM2.5: "); Serial.print(pm2_5);
            Serial.print(" µg/m³, PM10: "); Serial.print(pm10);
            Serial.println(" µg/m³");
            }
        }
    }

    return sensorData;  // Return the formatted data
}
