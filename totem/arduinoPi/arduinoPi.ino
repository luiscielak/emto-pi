#include <Adafruit_NeoPixel.h>

#define LED_PIN 13

int msgByte= -1;         // incoming byte
const int msgSize = 50;  // max message size
char msgArray[msgSize];  // array for incoming data
int msgPos = 0;          // current position

Adafruit_NeoPixel strip = Adafruit_NeoPixel(60, LED_PIN, NEO_GRB + NEO_KHZ800);

void setup() {
//  Serial.begin(115200);
//  pinMode(LED_PIN, OUTPUT);

  strip.begin();
  strip.show(); // Initialize all pixels to 'off'

}

void loop() {
  handleSerial();
}

void handleSerial() {  
  if (Serial.available() > 0) {
    //    digitalWrite(LED_PIN, HIGH);

    colorWipe(strip.Color(255, 0, 0), 50); // Red

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
      // for now just send it back over serial
      Serial.println(msgArray);

      // reset byte array
      for (int c = 0; c < msgSize; c++) 
        msgArray[c] = ' ';

      msgPos = 0;
      digitalWrite(LED_PIN, LOW);
      
          colorWipe(strip.Color(0, 255, 0), 50); // Blue
    }
  }
}

// Fill the dots one after the other with a color
void colorWipe(uint32_t c, uint8_t wait) {
  for(uint16_t i=0; i<strip.numPixels(); i++) {
    strip.setPixelColor(i, c);
    strip.show();
    delay(wait);
  }
}



