#include <HardwareSerial.h>
#include <WiFi.h>

HardwareSerial pmsSerial(1);  // Using UART1 on ESP32

#define RX_PIN 16  // Change this to the pin connected to PMS5003 TX
#define TX_PIN 17  // Change this to the pin connected to PMS5003 RX

uint8_t buffer[32];  // PMS5003 sends 32-byte frames

void setup() {
    PMSSetup();
    SetupWifi();
}

void loop() {
    WifiLoop();
}
