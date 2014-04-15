#include <Adafruit_NeoPixel.h>

#define PIN 6  // neopixel ring LED

#define LED_PIN 13 // status LED

Adafruit_NeoPixel strip = Adafruit_NeoPixel(60, PIN, NEO_GRB + NEO_KHZ800);

int msgByte= -1;         // incoming byte
const int msgSize = 50;  // max message size
char msgArray[msgSize];  // array for incoming data
int msgPos = 0;          // current position

void setup() {
  Serial.begin(115200);
  pinMode(LED_PIN, OUTPUT);

  strip.begin();
  strip.show(); // Initialize all pixels to 'off'
}

void loop() {
//  colorWipe(strip.Color(255, 0, 0), 50); // Red
  handleSerial();

}

void handleSerial() {  
  if (Serial.available() > 0) {
    digitalWrite(LED_PIN, HIGH);

    msgByte = Serial.read();

    if (msgByte != '\n') {
      // add incoming byte to array
      msgArray[msgPos] = msgByte;
      msgPos++;
    } 
    else {
      // reached end of line
      msgArray[msgPos] = 0;


      // here the message is processed
      setColor(msgArray);

      // send it back over serial
      Serial.println(msgArray);

      // reset byte array
      for (int c = 0; c < msgSize; c++) 
        msgArray[c] = ' ';

      msgPos = 0;
      digitalWrite(LED_PIN, LOW);
    }
  }
}

void setColor() {
  colorWipe(strip.Color(255,255,255), 20); // White
  colorWipe(strip.Color(0, 0, 0), 30); // Black

}


void setColor(char* c) {


  int r = atoi(c);

  colorWipe(strip.Color(r,30,100), 1);
  //strip.Color(val, 30, 100);

  //  if(c>0) colorWipe(strip.Color(val,30,100), 1);
  //  if(c==0) colorWipe(strip.Color(0, 0, 0), 1); // Black

  //  switch (val) {
  //  case 1:
  //    colorWipe(strip.Color(0,0,255), 10); // Blue
  //    colorWipe(strip.Color(0, 0, 0), 1); // Black
  //    break;
  //  case 2:
  //    colorWipe(strip.Color(0,255,0), 10); // Green
  //    colorWipe(strip.Color(0, 0, 0), 1); // Black
  //    break;
  //  case 3:
  //    colorWipe(strip.Color(255,0,0), 10); // Red
  //    colorWipe(strip.Color(0, 0, 0), 1); // Black
  //    break;
  //  case 4:
  //    colorWipe(strip.Color(223, 0, 255), 10); // Purple
  //    colorWipe(strip.Color(0, 0, 0), 1); // Black
  //    break;    
  //  default: 
  //    setColor();
  //  }



}


// Fill the dots one after the other with a color
void colorWipe(uint32_t c, uint8_t wait) {
  for(uint16_t i=0; i<strip.numPixels(); i++) {
    strip.setPixelColor(i, c);
    strip.show();
    delay(wait);
  }
}















