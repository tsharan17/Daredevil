#include <Arduino.h>
#define TRIG_FRONT 5
#define ECHO_FRONT 18

#define TRIG_LEFT 17
#define ECHO_LEFT 16

#define TRIG_RIGHT 4
#define ECHO_RIGHT 2

#define MOTOR_FRONT 25
#define MOTOR_LEFT 26
#define MOTOR_RIGHT 27

#define SAMPLE_COUNT 2   

unsigned long pulseFront = 0;
unsigned long pulseLeft = 0;
unsigned long pulseRight = 0;

bool stateFront = false;
bool stateLeft = false;
bool stateRight = false;

float lastFront = 400;
float lastLeft = 400;
float lastRight = 400;

int printCounter = 0;


float getDistance(int trigPin, int echoPin) {

  float sum = 0;

  for (int i = 0; i < SAMPLE_COUNT; i++) {

    digitalWrite(trigPin, LOW);
    delayMicroseconds(2);

    digitalWrite(trigPin, HIGH);
    delayMicroseconds(10);
    digitalWrite(trigPin, LOW);

    long duration = pulseIn(echoPin, HIGH, 30000);
    float d = duration * 0.034 / 2;

    if (d == 0 || d > 400) d = 400;

    sum += d;
    delay(5);
  }

  return sum / SAMPLE_COUNT;
}


void stopMotors() {
  digitalWrite(MOTOR_FRONT, LOW);
  digitalWrite(MOTOR_LEFT, LOW);
  digitalWrite(MOTOR_RIGHT, LOW);
}


void pulseFrontMotor(int interval) {
  unsigned long now = millis();
  if (now - pulseFront >= interval) {
    pulseFront = now;
    stateFront = !stateFront;
    digitalWrite(MOTOR_FRONT, stateFront);
  }
}

void pulseLeftMotor(int interval) {
  unsigned long now = millis();
  if (now - pulseLeft >= interval) {
    pulseLeft = now;
    stateLeft = !stateLeft;
    digitalWrite(MOTOR_LEFT, stateLeft);
  }
}

void pulseRightMotor(int interval) {
  unsigned long now = millis();
  if (now - pulseRight >= interval) {
    pulseRight = now;
    stateRight = !stateRight;
    digitalWrite(MOTOR_RIGHT, stateRight);
  }
}


void setup() {

  pinMode(MOTOR_FRONT, OUTPUT);
  pinMode(MOTOR_LEFT, OUTPUT);
  pinMode(MOTOR_RIGHT, OUTPUT);

  stopMotors();

  Serial.begin(115200);

  pinMode(TRIG_FRONT, OUTPUT);
  pinMode(ECHO_FRONT, INPUT);

  pinMode(TRIG_LEFT, OUTPUT);
  pinMode(ECHO_LEFT, INPUT);

  pinMode(TRIG_RIGHT, OUTPUT);
  pinMode(ECHO_RIGHT, INPUT);
}


void loop() {

  float front = getDistance(TRIG_FRONT, ECHO_FRONT);
  delay(50);
  float left = getDistance(TRIG_LEFT, ECHO_LEFT);
  delay(50);
  float right = getDistance(TRIG_RIGHT, ECHO_RIGHT);

  if (abs(front - lastFront) < 5) front = lastFront;
  if (abs(left - lastLeft) < 5) left = lastLeft;
  if (abs(right - lastRight) < 5) right = lastRight;

  lastFront = front;
  lastLeft = left;
  lastRight = right;

  printCounter++;
  if (printCounter >= 5) {
    Serial.print("F:");
    Serial.print(front);
    Serial.print(" L:");
    Serial.print(left);
    Serial.print(" R:");
    Serial.println(right);
    printCounter = 0;
  }

  stopMotors();

if (front < 120) {
  int interval = (front > 80) ? 800 :
                 (front > 50) ? 400 :
                 (front > 25) ? 150 : 0;

  if (interval == 0)
    digitalWrite(MOTOR_FRONT, HIGH);
  else
    pulseFrontMotor(interval);
}

if (left < 120) {
  int interval = (left > 80) ? 800 :
                 (left > 50) ? 400 :
                 (left > 25) ? 150 : 0;

  if (interval == 0)
    digitalWrite(MOTOR_LEFT, HIGH);
  else
    pulseLeftMotor(interval);
}

if (right < 120) {
  int interval = (right > 80) ? 800 :
                 (right > 50) ? 400 :
                 (right > 25) ? 150 : 0;

  if (interval == 0)
    digitalWrite(MOTOR_RIGHT, HIGH);
  else
    pulseRightMotor(interval);
}


  delay(80);
}