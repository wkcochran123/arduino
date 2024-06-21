

#include <Servo.h>

Servo myServo;  // Create a Servo object

const int laserPin = 8;

void setup() {
  myServo.attach(9);  // Attach the servo to pin 9
  pinMode(laserPin,OUTPUT);
}

void loop() {
  digitalWrite(laserPin, HIGH);
  for (int angle = 0; angle <= 180; angle += 1) { // Sweep from 0 to 180 degrees
    myServo.write(angle);  // Set the servo position
    delay(10);  // Wait 15ms for the servo to reach the position
  }
  digitalWrite(laserPin, LOW);
  for (int angle = 180; angle >= 0; angle -= 1) { // Sweep back from 180 to 0 degrees
    myServo.write(angle);  // Set the servo position
    delay(10);  // Wait 15ms for the servo to reach the position
  }
}

