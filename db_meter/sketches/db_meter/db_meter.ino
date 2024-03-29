const int soundSensorPin = A4; // Analog pin connected to the Big Sound Sensor Module
const int buttonOn = 13;
const int NUM_LEDS = 11;
const int LED_START = 2;
const int SAMPLES = 100;
const int PEAK_TIME = 2;

// Interpolate to NUM_LEDS + 1 buckets.  The first bucket is always guaranteed to be on,
// Also, looks like linear response may not be ideal...
int compute_pin (int min, int max, float val) {
  float bucket_width = (max - min)/(NUM_LEDS+1);  // The width for each led.  The lowest led is always on, so we get one more than we have pins.
  float shifted_val = val - (float)min;
  float bucket_number = shifted_val/bucket_width;  // The lowest bucket is always on..
  return (int) bucket_number;
}

long cur_max = LED_START;
long last_second_mark = 0;
bool toggle = false;
bool debounce = false;
long time_start;
long last_guess = -9;


int get_max (int val) {
  long current_second = millis()/1000;
  if (current_second-last_second_mark > PEAK_TIME) {
    last_second_mark = current_second;
    cur_max = LED_START;
  }
  if (cur_max < val) {
    last_second_mark = current_second;
    cur_max = val;
//    Serial.println(val);
  }
  return cur_max;
}

int fire_pins (int val) {
// Serial.println(val);
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
//  pinMode(soundSensorPin, INPUT); // Set the Sound Sensor pin as INPUT
//  pinMode(buttonOn, INPUT_PULLUP);
  pinMode(soundSensorPin, INPUT); // Set the Sound Sensor pin as INPUT
  pinMode(buttonOn, INPUT);
  for (int i = 2; i < 2+NUM_LEDS; i++) {
    pinMode(i,OUTPUT);
  }
  Serial.begin(9600); // Initialize serial communication for debugging (optional)
  Serial.println("Starting");
  delay(2000);
}

int maxmax = 0;
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

  if (maxmax > 1000) {
    delay(2000);
    return;
  }
  
  Serial.print(max);
  Serial.print(" ");
  Serial.println(compute_pin(800,850,max));
  maxmax = maxmax > max? maxmax:max;
  Serial.println(maxmax);
// Serial.println(max);
  // Adjust the threshold value according to your environment
  // fire_pins(compute_pin(633,670,max));
  delay(30);
}