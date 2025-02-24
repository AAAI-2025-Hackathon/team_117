 
//#include <HardwareSerial.h>
#include <WiFi.h>

#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_ADXL345_U.h>

Adafruit_ADXL345_Unified adxl = Adafruit_ADXL345_Unified(12345);

// Constants for breathing detection
#define SAMPLE_RATE 20        // Hz (50ms delay)
#define WINDOW_SIZE 20        // Moving average window
#define MIN_PEAK_HEIGHT 0.1   // Minimum height difference for peaks
#define MIN_BREATH_TIME 1500  // Minimum time between breaths (ms)

//HardwareSerial SerialUSB(1);
//define sound speed in cm/uS
#define SOUND_SPEED 0.034
#define CM_TO_INCH 0.393701
//#define WINDOW_SIZE 20  // Size of moving average window
//#define MIN_PEAK_HEIGHT 0.1  // Minimum height between peak and valley
//#define MIN_BREATH_TIME 1000  // Minimum time between breaths (ms)
#define GRAVITY 9.81
#define GYRO_WEIGHT 0.3  // Weight for gyroscope data fusion



// Define the USBComposite object
//USBCompositeClass USBComposite;


void setup() {
  Serial.begin(115200); // Starts the serial communication
     SetupWifi();
 accel_setup();
//  
//  pinMode(LtrigPin, OUTPUT); // Sets the trigPin as an Output
//  pinMode(LechoPin, INPUT); // Sets the echoPin as an Input
//  
//  pinMode(RtrigPin, OUTPUT); // Sets the trigPin as an Output
//  pinMode(RechoPin, INPUT); // Sets the echoPin as an Input
//  
//  pinMode(BtrigPin, OUTPUT); // Sets the trigPin as an Output
//  pinMode(BechoPin, INPUT); // Sets the echoPin as an Input

//  USBComposite.begin(); // Initialize USB Composite library
//  SerialUSB.begin(115200); 
}

void loop() {
//  String data_to_send = Get_sensor_data();
//       Send data to the connected client
//      client.println(data_to_send);  
//      Serial.println(data_to_send);
//      SerialUSB.println(data_to_send);
//    
    WifiLoop();
    
}


 String Get_sensor_data(){
      String value = accel_loop();
    
//    String distanceLeft = String(write_pin(LtrigPin, LechoPin), 2);
//    String distanceRight = String(write_pin(RtrigPin, RechoPin), 2);
//    String distanceBack = String(write_pin(BtrigPin, BechoPin), 2);
//    String value  = distanceLeft+"-"+distanceRight+"-"+distanceBack;
    return value;
 }
