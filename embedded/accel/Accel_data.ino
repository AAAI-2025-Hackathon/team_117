

// Circular buffer for moving average
float accelBuffer[WINDOW_SIZE];
int bufferIndex = 0;
float movingAverage = 0;

// Peak-Valley detection variables
float peak = -10000;
float valley = 10000;
bool lookingForPeak = true;
unsigned long lastBreathTime = 0;
int breathCount = 0;
unsigned long lastBpmUpdate = 0;

void accel_setup() {
  Serial.begin(115200);

  // Initialize ADXL345
  if (!adxl.begin()) {
    Serial.println("ADXL345 connection failed. Check wiring!");
    while (1);
  }

  Serial.println("ADXL345 Connected!");

  // Set range to ±16G
  adxl.setRange(ADXL345_RANGE_16_G);

  // Initialize buffer
  for (int i = 0; i < WINDOW_SIZE; i++) {
    accelBuffer[i] = 0;
  }
}

// Moving average filter
float calculateMovingAverage(float newValue) {
  movingAverage -= accelBuffer[bufferIndex] / WINDOW_SIZE;
  accelBuffer[bufferIndex] = newValue;
  movingAverage += newValue / WINDOW_SIZE;

  bufferIndex = (bufferIndex + 1) % WINDOW_SIZE;
  return movingAverage;
}

// Peak-Valley detection for breathing
void detectBreathing(float value) {
  unsigned long currentTime = millis();

  if (lookingForPeak) {
    if (value > peak) {
      peak = value;
    } 
    else if (value < peak - MIN_PEAK_HEIGHT) {
      if (currentTime - lastBreathTime > MIN_BREATH_TIME) {
        breathCount++;
        lastBreathTime = currentTime;
        Serial.print("Breath detected! Count: ");
        Serial.println(breathCount);
      }
      lookingForPeak = false;
      valley = value;
    }
  } 
  else {
    if (value < valley) {
      valley = value;
    }
    else if (value > valley + MIN_PEAK_HEIGHT) {
      lookingForPeak = true;
      peak = value;
    }
  }

  // Update BPM every 30 seconds
  if (currentTime - lastBpmUpdate >= 30000) {
    float bpm = breathCount * 2;
    Serial.print("Current BPM: ");
    Serial.println(bpm);
    breathCount = 0;
    lastBpmUpdate = currentTime;
  }
}
String accel_loop() {
  sensors_event_t event;
  adxl.getEvent(&event);

  // Compute acceleration magnitude (removing gravity)
  float accelMagnitude = sqrt(sq(event.acceleration.x) + 
                              sq(event.acceleration.y) + 
                              sq(event.acceleration.z)) - 9.81;

  // Apply moving average
  float filteredValue = calculateMovingAverage(accelMagnitude);

  // Detect breathing using peak-valley method
  detectBreathing(filteredValue);

  // Print filtered acceleration value
  Serial.print("Filtered Acceleration: ");
  Serial.println(filteredValue, 4);  // Print value properly

  // Convert filteredValue to a string with 4 decimal places and return
  return String(filteredValue, 4);
}
