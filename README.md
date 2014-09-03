# Arduino-RGB-LED-Chaser

The code and schematic file for a RGB LED chaser I built using an Arduino Uno.

- There are ten multicolored lights that turn on and off with five different effects.
- Pressing a button changes the effect.
- A potentiometer can be adjusted to change the speed of the LEDs.
- Four shift registers control the LEDs.
- A Schmitt trigger regulates the button's input to the Arduino.

Check out the video for this project:
http://youtu.be/QUhtjEsBbKg

The code was written by Alex Strandberg and is licensed under the MIT License, check LICENSE for more information

Much of the code was taken from: http://bildr.org/2011/02/74hc595/

[Fritzing](http://fritzing.org/home/) is needed to view the schematic file

## Arduino Libraries:
- [Timer1](http://playground.arduino.cc/code/timer1)