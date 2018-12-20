/* Ardumoto Example Sketch
 by: Jim Lindblom
 date: November 8, 2013
 license: Public domain. Please use, reuse, and modify this 
 sketch!
 
 Adapted to v20 hardware by: Marshall Taylor
 date: March 31, 2017
 
 Three useful functions are defined:
 setupArdumoto() -- Setup the Ardumoto Shield pins
 driveArdumoto([motor], [direction], [speed]) -- Drive [motor] 
 (0 for A, 1 for B) in [direction] (0 or 1) at a [speed]
 between 0 and 255. It will spin until told to stop.
 stopArdumoto([motor]) -- Stop driving [motor] (0 or 1).
 
 setupArdumoto() is called in the setup().
 The loop() demonstrates use of the motor driving functions.
 */

// Clockwise and counter-clockwise definitions.
// Depending on how you wired your motors, you may need to swap.
#define FORWARD  0
#define REVERSE 1

// Motor definitions to make life easier:
#define MOTOR_A 0
#define MOTOR_B 1

// Pin Assignments //
//Default pins:
#define DIRA 2 // Direction control for motor A
#define PWMA 3  // PWM control (speed) for motor A
#define DIRB 4 // Direction control for motor B
#define PWMB 11 // PWM control (speed) for motor B

////Alternate pins:
//#define DIRA 8 // Direction control for motor A
//#define PWMA 9 // PWM control (speed) for motor A
//#define DIRB 7 // Direction control for motor B
//#define PWMB 10 // PWM control (speed) for motor B
const int LIGHT_PIN = A0;
const int SEARCH_DRIVE_TIME = 200;  // Time to run one motor while searching
const int TURN_DRIVE_TIME = 200;    // Time to turn in a direction
const int MOVE_DRIVE_TIME = 300;   // Time to drive in a direction
const int STOP_DRIVE_TIME = 200;    // Time to stop after moving
const int NUM_LIGHT_LEVELS = 3;
const int SW_PIN = 2;
const int GREEN_LED = 5;
const int RED_LED = 6;

void setup()
{
  setupArdumoto(); // Set all pins as outputs
  pinMode(GREEN_LED, OUTPUT);
  pinMode(RED_LED, OUTPUT);
  digitalWrite(GREEN_LED, HIGH);
  digitalWrite(RED_LED, LOW);
  // Initialize Serial comms
  Serial.begin(9600);
  Serial.println("Feed me photons!"); 

}

void loop() {

  // Store light levels as array [left, center, right]
  int light_levels[NUM_LIGHT_LEVELS];

  // If switch is flipped, search for light
  if(digitalRead(SW_PIN) == HIGH){

    // Record light value to the left
    drive(0, 255);
    myDelay(SEARCH_DRIVE_TIME);
    drive(0, 0);
    myDelay(STOP_DRIVE_TIME);
    light_levels[0] = analogRead(LIGHT_PIN);
    drive(0, -255);
    myDelay(SEARCH_DRIVE_TIME);
    drive(0, 0);
    myDelay(STOP_DRIVE_TIME);

    // Record light value to the right
    drive(255, 0);
    myDelay(SEARCH_DRIVE_TIME);
    drive(0, 0);
    myDelay(STOP_DRIVE_TIME);
    light_levels[2] = analogRead(LIGHT_PIN);
    drive(-255, 0);
    myDelay(SEARCH_DRIVE_TIME);
    drive(0, 0);
    myDelay(STOP_DRIVE_TIME);

    // Record light value in the center
    light_levels[1] = analogRead(LIGHT_PIN);

    // Find direction of max light
    int max_light = 0;
    int max_light_index = 0;
    for ( int i = 0; i < NUM_LIGHT_LEVELS; i++ ) {
      if ( light_levels[i] > max_light ) {
        max_light = light_levels[i];
        max_light_index = i;
      }
      Serial.print(light_levels[i]);
      Serial.print(" ");
    }
    Serial.println();
    Serial.print("Max light: ");
    Serial.println(max_light_index);

    // Move in the direction of max light
    if ( max_light_index == 0 ) {
      Serial.println("Chasing light to the left");
      drive(-100, 255);
      myDelay(TURN_DRIVE_TIME);
      drive(255, 255);
      myDelay(MOVE_DRIVE_TIME);
      drive(0, 0);
      myDelay(STOP_DRIVE_TIME);
    } 
    else if ( max_light_index == 1 ) {
      Serial.println("Chasing light straight ahead");
      drive(255, 255);
      myDelay(MOVE_DRIVE_TIME);
      drive(0, 0);
      myDelay(STOP_DRIVE_TIME);
    } 
    else {
      Serial.println("Chasing light to the right");
      drive(255, -100);
      myDelay(TURN_DRIVE_TIME);
      drive(255, 255);
      myDelay(MOVE_DRIVE_TIME);
      drive(0, 0);
      myDelay(STOP_DRIVE_TIME);
    }

    // If switch is not flipped, do nothing
  } 
  else {
    digitalWrite(GREEN_LED, LOW);
    digitalWrite(RED_LED, HIGH);

    while(true) {
      drive(0, 0);
    }
  }
}


// driveArdumoto drives 'motor' in 'dir' direction at 'spd' speed
void driveArdumoto(byte motor, byte dir, byte spd)
{
  if (motor == MOTOR_A)
  {
    digitalWrite(DIRA, dir);
    analogWrite(PWMA, spd);
  }
  else if (motor == MOTOR_B)
  {
    digitalWrite(DIRB, dir);
    analogWrite(PWMB, spd);
  }  
}
void drive(int leftSpeed, int rightSpeed) {
  byte lspeed = leftSpeed < 0 , rspeed = rightSpeed < 0;
  // forward 0, reverse 1 

  driveArdumoto(MOTOR_A, lspeed, abs(leftSpeed));
  driveArdumoto(MOTOR_B, rspeed, abs(rightSpeed));
}
// stopArdumoto makes a motor stop
void stopArdumoto(byte motor)
{
  driveArdumoto(motor, 0, 0);
}

// setupArdumoto initialize all pins
void setupArdumoto()
{
  // All pins should be setup as outputs:
  pinMode(PWMA, OUTPUT);
  pinMode(PWMB, OUTPUT);
  pinMode(DIRA, OUTPUT);
  pinMode(DIRB, OUTPUT);

  // Initialize all pins as low:
  digitalWrite(PWMA, LOW);
  digitalWrite(PWMB, LOW);
  digitalWrite(DIRA, LOW);
  digitalWrite(DIRB, LOW);
}
void myDelay(unsigned long ms) {
  unsigned long starttime = millis();
  while(millis() - starttime <= ms) {
    if(digitalRead(SW_PIN) == LOW) {
      digitalWrite(GREEN_LED, LOW);
      digitalWrite(RED_LED, HIGH);
      while(true) {
        drive(0, 0);
      }
    }
  }
}


