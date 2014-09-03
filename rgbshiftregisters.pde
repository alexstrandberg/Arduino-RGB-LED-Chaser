#include <TimerOne.h>

int SER_Pin = 8;   //pin 14 on the 75HC595
int RCLK_Pin = 9;  //pin 12 on the 75HC595
int SRCLK_Pin = 10; //pin 11 on the 75HC595
int buttonPin = 0;
boolean autoupdate = false;
volatile int leddelay = 100;

volatile int whichEffect=0;

int effectColorSelect = 0;

int potpin = 0;

int whichLEDArray[100];
int whichLEDColorArray[100];
int arrayLocationSelect = 1;
int arrayCreatorSelect = 1;

boolean didReset = false;

boolean isChangingEffect = false;

//How many of the shift registers - change this
#define number_of_74hc595s 4 

//do not touch
#define numOfRegisterPins number_of_74hc595s * 8

boolean registers[numOfRegisterPins];

void setup(){
  pinMode(SER_Pin, OUTPUT);
  pinMode(RCLK_Pin, OUTPUT);
  pinMode(SRCLK_Pin, OUTPUT);

  //reset all register pins
  clearRegisters();
  writeRegisters();
  
  autoupdate = true; //Change if you want to update the LED's as soon as the variables are changed.
  
  attachInterrupt(buttonPin,changeEffect,RISING); // Hardware Interrupt for the button, whenever the button is pressed, the effect will change once the current effect finishes its loop.
  
  Timer1.initialize(500);
  Timer1.attachInterrupt(updateDelay,500); // Automatically checks the potentiometer to update the speed of the effect
}               

//set all register pins to LOW
void clearRegisters(){
  for(int i = numOfRegisterPins - 1; i >=  0; i--){
     registers[i] = LOW;
  }
} 

//Set and display registers
//Only call AFTER all values are set how you would like (slow otherwise)
void writeRegisters(){

  digitalWrite(RCLK_Pin, LOW);

  for(int i = numOfRegisterPins - 1; i >=  0; i--){
    digitalWrite(SRCLK_Pin, LOW);

    int val = registers[i];

    digitalWrite(SER_Pin, val);
    digitalWrite(SRCLK_Pin, HIGH);

  }
  digitalWrite(RCLK_Pin, HIGH);

}

//set an individual pin HIGH or LOW
void setRegisterPin(int index, int value){
  registers[index] = value;
}

// Change values of a particular RGB LED
void setRGBLED(int whichone, int rvalue, int gvalue, int bvalue) {
  whichone--;
  setRegisterPin((whichone*3),rvalue);
  setRegisterPin((whichone*3)+1,gvalue);
  setRegisterPin((whichone*3)+2,bvalue);
  if (autoupdate==true) writeRegisters();
}

// Individual control over each color of the LED
void setRLED(int whichone, int rvalue) {
  whichone--;
  setRegisterPin((whichone*3),rvalue);
  if (autoupdate==true) writeRegisters();
}

void setGLED(int whichone, int gvalue) {
  whichone--;
  setRegisterPin((whichone*3)+1,gvalue);
  if (autoupdate==true) writeRegisters();
}

void setBLED(int whichone, int bvalue) {
  whichone--;
  setRegisterPin((whichone*3)+2,bvalue);
  if (autoupdate==true) writeRegisters();
}

void loop() {
  if (isChangingEffect==true) { // Loop to prevent the effect from being changed too many times if the button is pressed for too long.  
    delay(100);
    isChangingEffect=false;
  }
  if (whichEffect==0) { // The same LED color blinks for 10 LEDS, then changes color. goes through all the available colors
    clearRegisters();
    delay(leddelay);
    for (int i = 1; i < 11; i++) { // Red
      if (effectColorSelect==0) {
        if (i!=1) {
          setRGBLED(i-1,LOW,LOW,LOW);
        }
        setRGBLED(i,HIGH,LOW,LOW);
        delay(leddelay);
      }
      else if (effectColorSelect==1) { // Green
        if (i!=1) {
          setRGBLED(i-1,LOW,LOW,LOW);
        }
        setRGBLED(i,LOW,HIGH,LOW);
        delay(leddelay);
      }
      else if (effectColorSelect==2) { // Blue
        if (i!=1) {
          setRGBLED(i-1,LOW,LOW,LOW);
        }
        setRGBLED(i,LOW,LOW,HIGH);
        delay(leddelay);
      }
      else if (effectColorSelect==3) { // Yellow
        if (i!=1) {
          setRGBLED(i-1,LOW,LOW,LOW);
        }
        setRGBLED(i,HIGH,HIGH,LOW);
        delay(leddelay);
      }
      else if (effectColorSelect==4) { // Purple
        if (i!=1) {
          setRGBLED(i-1,LOW,LOW,LOW);
        }
        setRGBLED(i,HIGH,LOW,HIGH);
        delay(leddelay);
      }
      else if (effectColorSelect==5) { // Cyan
        if (i!=1) {
          setRGBLED(i-1,LOW,LOW,LOW);
        }
        setRGBLED(i,LOW,HIGH,HIGH);
        delay(leddelay);
      }
      else if (effectColorSelect==6) { // White
        if (i!=1) {
          setRGBLED(i-1,LOW,LOW,LOW);
        }
        setRGBLED(i,HIGH,HIGH,HIGH);
        delay(leddelay);
      }
    }
    
    delay(leddelay);
    
    effectColorSelect++;
    if (effectColorSelect==7) effectColorSelect = 0;
  }
  
  else if (whichEffect==1) { // One color goes through each LED, until it stops at the end, and each subsequent time the color is stopped one before where the previous one stopped. The color changes after each loop.
    clearRegisters();
    for (int j = 10; j > 0; j--) { 
      for (int i = 1; i < j+1; i++) {
        if (effectColorSelect==0) { // Red
          if (i!=1) {
            setRGBLED(i-1,LOW,LOW,LOW);
          }
           setRGBLED(i,HIGH,LOW,LOW);
          delay(leddelay);
        }
        else if (effectColorSelect==1) { // Green
          if (i!=1) {
            setRGBLED(i-1,LOW,LOW,LOW);
          }
          setRGBLED(i,LOW,HIGH,LOW);
          delay(leddelay);
        }
        else if (effectColorSelect==2) { // Blue
          if (i!=1) {
            setRGBLED(i-1,LOW,LOW,LOW);
          }
          setRGBLED(i,LOW,LOW,HIGH);
          delay(leddelay);
        }
        else if (effectColorSelect==3) { // Yellow
          if (i!=1) {
            setRGBLED(i-1,LOW,LOW,LOW);
          }
          setRGBLED(i,HIGH,HIGH,LOW);
          delay(leddelay);
        }
        else if (effectColorSelect==4) { // Purple
          if (i!=1) {
            setRGBLED(i-1,LOW,LOW,LOW);
          }
          setRGBLED(i,HIGH,LOW,HIGH);
          delay(leddelay);
        }
        else if (effectColorSelect==5) { // Cyan
          if (i!=1) {
            setRGBLED(i-1,LOW,LOW,LOW);
          }
          setRGBLED(i,LOW,HIGH,HIGH);
          delay(leddelay);
        }
        else if (effectColorSelect==6) { // White
          if (i!=1) {
            setRGBLED(i-1,LOW,LOW,LOW);
          }
          setRGBLED(i,HIGH,HIGH,HIGH);
          delay(leddelay);
        }
      }
    }
    effectColorSelect++;
    if (effectColorSelect==7) effectColorSelect = 0;
  }
  else if (whichEffect==2) { //Knight Rider; Three of the same colors go back and forth across the 10 LEDS, the color changes after each loop
    clearRegisters();
    delay(leddelay);
    for (int i = 1; i < 11; i++) { 
      if (effectColorSelect==0) { // Red
        if (i!=1) {
          setRGBLED(i-1,LOW,LOW,LOW);
          setRGBLED(i-2,LOW,LOW,LOW);
        }
        setRGBLED(i,HIGH,LOW,LOW);
        setRGBLED(i+1,HIGH,LOW,LOW);
        delay(leddelay);
      }
      else if (effectColorSelect==1) { // Green
        if (i!=1) {
          setRGBLED(i-1,LOW,LOW,LOW);
          setRGBLED(i-2,LOW,LOW,LOW);
        }
        setRGBLED(i,LOW,HIGH,LOW);
        setRGBLED(i+1,LOW,HIGH,LOW);
        delay(leddelay);
      }
      else if (effectColorSelect==2) { // Blue
        if (i!=1) {
          setRGBLED(i-1,LOW,LOW,LOW);
          setRGBLED(i-2,LOW,LOW,LOW);
        }
        setRGBLED(i,LOW,LOW,HIGH);
        setRGBLED(i+1,LOW,LOW,HIGH);
        delay(leddelay);
      }
      else if (effectColorSelect==3) { // Yellow
        if (i!=1) {
          setRGBLED(i-1,LOW,LOW,LOW);
          setRGBLED(i-2,LOW,LOW,LOW);
        }
        setRGBLED(i,HIGH,HIGH,LOW);
        setRGBLED(i+1,HIGH,HIGH,LOW);
        delay(leddelay);
      }
      else if (effectColorSelect==4) { // Purple
        if (i!=1) {
          setRGBLED(i-1,LOW,LOW,LOW);
          setRGBLED(i-2,LOW,LOW,LOW);
        }
        setRGBLED(i,HIGH,LOW,HIGH);
        setRGBLED(i+1,HIGH,LOW,HIGH);
        delay(leddelay);
      }
      else if (effectColorSelect==5) { // Cyan
        if (i!=1) {
          setRGBLED(i-1,LOW,LOW,LOW);
          setRGBLED(i-2,LOW,LOW,LOW);
        }
        setRGBLED(i,LOW,HIGH,HIGH);
        setRGBLED(i+1,LOW,HIGH,HIGH);
        delay(leddelay);
      }
      else if (effectColorSelect==6) { // White
        if (i!=1) {
          setRGBLED(i-1,LOW,LOW,LOW);
          setRGBLED(i-2,LOW,LOW,LOW);
        }
        setRGBLED(i,HIGH,HIGH,HIGH);
        setRGBLED(i+1,HIGH,HIGH,HIGH);
        delay(leddelay);
      }
    }
    
    delay(leddelay);
    
    // Alternate Direction
    
      for (int i = 10; i > 0; i--) { 
      if (effectColorSelect==0) { // Red
        if (i!=10) {
          setRGBLED(i+1,LOW,LOW,LOW);
          setRGBLED(i+2,LOW,LOW,LOW);
        }
        setRGBLED(i,HIGH,LOW,LOW);
        if (i!=1) setRGBLED(i-1,HIGH,LOW,LOW);
        delay(leddelay);
      }
      else if (effectColorSelect==1) { // Green
        if (i!=10) {
          setRGBLED(i+1,LOW,LOW,LOW);
          setRGBLED(i+2,LOW,LOW,LOW);
        }
        setRGBLED(i,LOW,HIGH,LOW);
        if (i!=1) setRGBLED(i-1,LOW,HIGH,LOW);
        delay(leddelay);
      }
      else if (effectColorSelect==2) { // Blue
        if (i!=10) {
          setRGBLED(i+1,LOW,LOW,LOW);
          setRGBLED(i+2,LOW,LOW,LOW);
        }
        setRGBLED(i,LOW,LOW,HIGH);
        if (i!=1) setRGBLED(i-1,LOW,LOW,HIGH);
        delay(leddelay);
      }
      else if (effectColorSelect==3) { // Yellow
        if (i!=10) {
          setRGBLED(i+1,LOW,LOW,LOW);
          setRGBLED(i+2,LOW,LOW,LOW);
        }
        setRGBLED(i,HIGH,HIGH,LOW);
        if (i!=1) setRGBLED(i-1,HIGH,HIGH,LOW);
        delay(leddelay);
      }
      else if (effectColorSelect==4) { // Purple
        if (i!=10) {
          setRGBLED(i+1,LOW,LOW,LOW);
          setRGBLED(i+2,LOW,LOW,LOW);
        }
        setRGBLED(i,HIGH,LOW,HIGH);
        if (i!=1) setRGBLED(i-1,HIGH,LOW,HIGH);
        delay(leddelay);
      }
      else if (effectColorSelect==5) { // Cyan
        if (i!=10) {
          setRGBLED(i+1,LOW,LOW,LOW);
          setRGBLED(i+2,LOW,LOW,LOW);
        }
        setRGBLED(i,LOW,HIGH,HIGH);
        if (i!=1) setRGBLED(i-1,LOW,HIGH,HIGH);
        delay(leddelay);
      }
      else if (effectColorSelect==6) { // White
        if (i!=10) {
          setRGBLED(i+1,LOW,LOW,LOW);
          setRGBLED(i+2,LOW,LOW,LOW);
        }
        setRGBLED(i,HIGH,HIGH,HIGH);
        if (i!=1) setRGBLED(i-1,HIGH,HIGH,HIGH);
        delay(leddelay);
      }
    }
    effectColorSelect++;
    if (effectColorSelect==7) effectColorSelect = 0;
  }
  else if (whichEffect==3) { // Loading Bar
    clearRegisters();
    delay(leddelay);
    for (int i = 1; i < 11; i++) { 
      if (effectColorSelect==0) { // Red
        setRGBLED(i,HIGH,LOW,LOW);
        delay(leddelay);
      }
      else if (effectColorSelect==1) { // Green
        setRGBLED(i,LOW,HIGH,LOW);
        delay(leddelay);
      }
      else if (effectColorSelect==2) { // Blue
        setRGBLED(i,LOW,LOW,HIGH);
        delay(leddelay);
      }
      else if (effectColorSelect==3) { // Yellow
        setRGBLED(i,HIGH,HIGH,LOW);
        delay(leddelay);
      }
      else if (effectColorSelect==4) { // Purple
        setRGBLED(i,HIGH,LOW,HIGH);
        delay(leddelay);
      }
      else if (effectColorSelect==5) { // Cyan
        setRGBLED(i,LOW,HIGH,HIGH);
        delay(leddelay);
      }
      else if (effectColorSelect==6) { // White
        setRGBLED(i,HIGH,HIGH,HIGH);
        delay(leddelay);
      }
    }
    
    delay(leddelay);
    
    // Alternate Direction
    
    for (int i = 10; i > 0; i--) { 
      setRGBLED(i,LOW,LOW,LOW);
      delay(leddelay);
    }
    
    effectColorSelect++;
    if (effectColorSelect==7) effectColorSelect = 0;
  }
  
  else if (whichEffect==4) { // Random LED goes on with random color
    clearRegisters();
    delay(leddelay);
    int i = whichLEDArray[arrayLocationSelect];
    effectColorSelect=whichLEDColorArray[arrayLocationSelect];
    if (whichLEDArray[arrayLocationSelect]!=0) {
      if (effectColorSelect==0) { // Red
        setRGBLED(i,HIGH,LOW,LOW);
        delay(leddelay);
      }
      else if (effectColorSelect==1) { // Green
        setRGBLED(i,LOW,HIGH,LOW);
        delay(leddelay);
      }
      else if (effectColorSelect==2) { // Blue
        setRGBLED(i,LOW,LOW,HIGH);
        delay(leddelay);
      }
      else if (effectColorSelect==3) { // Yellow
        setRGBLED(i,HIGH,HIGH,LOW);
        delay(leddelay);
      }
      else if (effectColorSelect==4) { // Purple
        setRGBLED(i,HIGH,LOW,HIGH);
        delay(leddelay);
      }
      else if (effectColorSelect==5) { // Cyan
        setRGBLED(i,LOW,HIGH,HIGH);
        delay(leddelay);
      }
      else if (effectColorSelect==6) { // White
        setRGBLED(i,HIGH,HIGH,HIGH);
        delay(leddelay);
      }
    }
    else arrayLocationSelect=-1;
    arrayLocationSelect++;
    if (arrayLocationSelect>90&&didReset==false) {
      arrayCreatorSelect=1;
      whichLEDArray[0]=0;
      didReset=true;
    }
    if (arrayLocationSelect==101) {
      arrayLocationSelect=1;  
      didReset==false;
    }
  }
}

void changeEffect() {
  if (isChangingEffect==false) {
    isChangingEffect=true;
    whichEffect++;
    if (whichEffect==5) whichEffect=0;
  }
}

void updateDelay() { // Checks the value of the potentiometer, also generates the unique array of data for the random LED effect
  int val = analogRead(potpin);
  leddelay = map(val,0,1023,1000,25);
  
  if (whichLEDArray[0]==0) {
    boolean notValid=true;
    while (notValid==true) {
      whichLEDArray[arrayCreatorSelect]=random(1,11);
      if (whichLEDArray[arrayCreatorSelect]!=whichLEDArray[arrayCreatorSelect-1]&&whichLEDArray[arrayCreatorSelect]!=whichLEDArray[arrayCreatorSelect-2]&&whichLEDArray[arrayCreatorSelect]!=whichLEDArray[arrayCreatorSelect-3]&&whichLEDArray[arrayCreatorSelect]!=whichLEDArray[arrayCreatorSelect-4]&&whichLEDArray[arrayCreatorSelect]!=whichLEDArray[arrayCreatorSelect-5]&&whichLEDArray[arrayCreatorSelect]!=whichLEDArray[arrayCreatorSelect-6]&&whichLEDArray[arrayCreatorSelect]!=whichLEDArray[arrayCreatorSelect-7]&&whichLEDArray[arrayCreatorSelect]!=whichLEDArray[arrayCreatorSelect-8]&&whichLEDArray[arrayCreatorSelect]!=whichLEDArray[arrayCreatorSelect-9]) {
        notValid=false;
      }
    }
    
    notValid=true;
    
    while (notValid==true) {
      whichLEDColorArray[arrayCreatorSelect]=random(0,7);
      if (whichLEDColorArray[arrayCreatorSelect]!=whichLEDColorArray[arrayCreatorSelect-1]&&whichLEDColorArray[arrayCreatorSelect]!=whichLEDColorArray[arrayCreatorSelect-2]&&whichLEDColorArray[arrayCreatorSelect]!=whichLEDColorArray[arrayCreatorSelect-3]&&whichLEDColorArray[arrayCreatorSelect]!=whichLEDColorArray[arrayCreatorSelect-4]&&whichLEDColorArray[arrayCreatorSelect]!=whichLEDColorArray[arrayCreatorSelect-5]&&whichLEDColorArray[arrayCreatorSelect]!=whichLEDColorArray[arrayCreatorSelect-6]) {
        notValid=false;
        arrayCreatorSelect++;
      }
    }
    if (arrayCreatorSelect>100) {
      whichLEDArray[0]=1;
      arrayCreatorSelect = 1;
    }
  }
}
