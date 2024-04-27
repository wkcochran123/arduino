const int soundSensorPin = A1; // Analog pin connected to the Big Sound Sensor Module
const int NUM_LEDS = 11;
const int LED_START = 2;
const int SAMPLES = 50;

int max_pin;
int max_pin_set;

double max_est;
double min_est;

// Interpolate to NUM_LEDS + 1 buckets.  The first bucket is always guaranteed to be on,
// Also, looks like linear response may not be ideal...
int compute_pin (int min, int max, float val) {
  float scale = (val - (float)min)/((float)(max-min));
  if (scale >= 1.0) scale=1.1;
  if (scale < 0) scale = 0;

  int answer = scale*(NUM_LEDS+1) - 1;
  if (answer < 0) answer = 0;

  return answer;
}

int get_min_est() {
  return (int) min_est;
}

int get_max_est() {
  return (int) max_est;
}

void update_totals(int max, int min) {
  if (min < get_min_est()) min_est = (double) min;
  if (max > get_max_est()) max_est = (double) max;
  min_est = 0.01 * min + 0.99 * min_est;
  max_est = 0.01 * max + 0.99 * max_est;
  max_est = max_est < 10.0 + min_est ? min_est + 10.0 : max_est;
}



int fire_pins (int val) {
  for (int i = 0; i != NUM_LEDS; i++) {
    int led = LOW;
    int pin = NUM_LEDS + LED_START - i - 1;

/*
    int current_time = millis();
    if ((current_time < max_pin_set) || (current_time > max_pin_set + 500) || (val > max_pin)) {
      max_pin_set = current_time;
      max_pin = val;
    }
*/
    if ((val > i) || (val == max_pin)) {
      led = HIGH;
    }

    digitalWrite(pin, led);
  }
}

void setup() {
  pinMode(soundSensorPin, INPUT); // Set the Sound Sensor pin as INPUT
  for (int i = 2; i < 2+NUM_LEDS; i++) {
    pinMode(i,OUTPUT);
  }
  Serial.begin(9600); // Initialize serial communication for debugging (optional)
  Serial.println("Starting");

int maxmax = 0;
void loop() {
=======
  digitalWrite(12,HIGH);
  max_pin = 0;
  max_pin_set = millis();
  min_est = 1100.0;
  max_est = 0.0;
  delay(1000);
}


void loop() {  
>>>>>>> 6513751 (Working self calibrating db meter)
  int vals[SAMPLES];

  int max = 0;
  int min = 1000;

  for (int x=0; x != SAMPLES; x++) {
    int vals = analogRead(soundSensorPin);
    if (vals > max) max = vals;
    if (vals < min) min = vals;
  }

<<<<<<< HEAD
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
  update_totals(max,min);
  int pin = compute_pin(get_min_est(),get_max_est(),max);
  Serial.print(max);
  Serial.print(" ");
  Serial.print(get_min_est());
  Serial.print(" ");
  Serial.println(get_max_est());

  fire_pins(pin);
  delay(30);
}
