const int soundSensorPin = A0; // Analog pin connected to the Big Sound Sensor Module
const int buttonOn = 50;
const int NUM_LEDS = 11;
const int LED_START = 2;
const int SAMPLES = 50;
const int PEAK_TIME = 2;

int compute_pin (int min, int max, float val) {
  float scale = (val - (float)min)/((float)(max-min));
  if (scale >= 1.0) scale=.9999;
  if (scale < 0) scale = 0;

  return LED_START + scale*(max-min);
}

long cur_max = LED_START;
long last_second_mark = 0;
bool toggle = false;
bool debounce = false;

int get_max (int val) {
  long current_second = millis()/1000;
  if (current_second-last_second_mark > PEAK_TIME) {
    last_second_mark = current_second;
    cur_max = LED_START;
  }
  if (cur_max < val) {
    last_second_mark = current_second;
    cur_max = val;
    Serial.println(val);
  }
  return cur_max;
}

int fire_pins (int val) {
  Serial.println(val);
  for (int i = LED_START; i <= LED_START+NUM_LEDS; i++) {
    int led = LOW;
    if (i<=val) led = HIGH;
    if (digitalRead(buttonOn) == LOW) {
      if (!debounce) {
        debounce = true;
        toggle = !toggle;
      }
    } else {
      debounce = false;
    }
    if (i == get_max(val) && toggle) led = HIGH;
    digitalWrite(i, led);
  }
}

void setup() {
  pinMode(soundSensorPin, INPUT); // Set the Sound Sensor pin as INPUT
  pinMode(buttonOn, INPUT_PULLUP);
  for (int i = 2; i <= 2+NUM_LEDS; i++) {
    pinMode(i,OUTPUT);
  }
  Serial.begin(9600); // Initialize serial communication for debugging (optional)
  Serial.println("Starting");
}


void loop() {  
  int vals[SAMPLES];

  for (int x=0; x != SAMPLES; x++) {
    vals[x] = analogRead(soundSensorPin);
  }


  float avg = 0.0;
  int max = 0;
  int min = 1000;

  for (int x=0; x != SAMPLES; x++) {
    avg += (float)vals[x];
    if (vals[x] < min) min = vals[x];
    if (vals[x] > max) max = vals[x];
  }
  avg /= SAMPLES;

  
// Serial.println(max);
  // Adjust the threshold value according to your environment
  fire_pins(compute_pin(260,265,max));
  delay(30);
}