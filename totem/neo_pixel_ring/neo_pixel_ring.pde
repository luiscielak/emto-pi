import controlP5.*;

ControlP5 cp5;

PShape arc1;
Arc[] arcs;
PFont myFontType;
hsbColorPicker colorPicker;
int colorPickerTop = 10, colorPickerLeft = 10;
float MAX_BRIGHTNESS = 1;
float MAX_SATURATION = 1;
float MAX_HUE = TWO_PI;
float MAX_ALPHA = 1;
PGraphics mainWin;
int selected = -1;
int currentFrame = 0;
int SEQUENCE_LENGTH = 16;
int NUMBER_OF_LED = 16;

void setup() {
  size(920, 720);
  //setup color picker
  colorMode(HSB, MAX_HUE, MAX_SATURATION, MAX_BRIGHTNESS, MAX_ALPHA);
  colorPicker = new hsbColorPicker(100, colorPickerLeft, colorPickerTop);
  mainWin = createGraphics(300, 280);
  myFontType = createFont("arial", 16);
  textFont(myFontType);
  //setup neo-pixel ring gui
  arc1 = loadShape("arc1.svg");
  arc1.disableStyle();
  shapeMode(CENTER);
  arcs = new Arc[NUMBER_OF_LED];
  for (int i = 0; i<NUMBER_OF_LED; i++) {
    float rot = 360.0/NUMBER_OF_LED*i*PI/180.0;
    arcs[i] = new Arc(rot, new PVector(600, 165));
  }
  //setup controlP5 GUI
  cp5 = new ControlP5(this);
  new ColorMatrix(cp5, "LED_sequence")
    .setPosition(50, 400)
      .setSize(800, 290)
        .setGrid(SEQUENCE_LENGTH, NUMBER_OF_LED)
          .setGap(2, 2)
            .setInterval(200)
              .setMode(ControlP5.MULTIPLES)
                .setColorBackground(color(1, 0, .1))
                  .setBackground(color(1, 0, .3))
                    ;

  cp5.getController("LED_sequence").getCaptionLabel().alignX(CENTER);

  cp5.addToggle("play_pause")
    .setPosition(50, 340)
      .setSize(50, 20)
        .setValue(false)
          .setMode(ControlP5.SWITCH)
            ;

  cp5.addSlider("timeline")
    .setPosition(45, 380)
      .setWidth(815)
        .setHeight(15)
          .setRange(0, SEQUENCE_LENGTH)
            .setValue(0)
              .setNumberOfTickMarks(SEQUENCE_LENGTH+1)
                .setSliderMode(Slider.FLEXIBLE)
                  .setDecimalPrecision(0)
                    ;

  cp5.addSlider("speed")
    .setPosition(145, 345)
      .setWidth(550)
        .setHeight(15)
          .setRange(625, 75)
            .setValue(200)
              .setNumberOfTickMarks(23)
                .setSliderMode(Slider.FIX)
                  .setDecimalPrecision(1)
                    ;

  cp5.addBang("bang")
    .setPosition(790, 340)
      .setSize(20, 20)
        .setTriggerEvent(Bang.RELEASE)
          .setLabel("Clear Sequence")
            ;

  cp5.addBang("clean")
    .setPosition(240, 240)
      .setSize(20, 20)
        .setTriggerEvent(Bang.RELEASE)
          .setLabel("Clear Cell")
            ;

  cp5.addBang("saveSeq")
    .setPosition(790, 300)
      .setSize(20, 20)
        .setTriggerEvent(Bang.RELEASE)
          .setLabel("save sequence")
            ;
}

void draw() {
  background(.5, 0, .2);
  //deal with color picker
  if (mousePressed) {
    colorPicker.checkMousePressed(mouseX, mouseY);
  }
  mainWin.beginDraw();
  mainWin.stroke(1, 1, 1);
  mainWin.fill(100);
  mainWin.rect(0, 0, 300, 280);
  mainWin.fill(255);
  mainWin.textFont(myFontType);
  mainWin.text("R: "+ colorPicker.getRed(), 230, 50);
  mainWin.text("G: "+ colorPicker.getGreen(), 230, 70);
  mainWin.text("B: "+ colorPicker.getBlue(), 230, 90);
  mainWin.fill(colorPicker.pickedColor);
  mainWin.rect(230, 100, 40, 40);
  mainWin.endDraw();
  colorPicker.show(mainWin);
  image(mainWin, 0, 0);
  //check to see if someone has clicked on an arc, and also display them all
  for (int i = 0; i<NUMBER_OF_LED; i++) {
    if (arcs[i].update()) {
      selected = i;
    }
    arcs[i].display();
    if (i == selected) {
      arcs[i].select = true;
    }
    else {
      arcs[i].select = false;
    }
  }
  //set color of arc and cell in sequencer
  if (selected != -1) {
    arcs[selected].arcColor = colorPicker.pickedColor;
    cp5.get(ColorMatrix.class, "LED_sequence").setCellColor(currentFrame, selected, colorPicker.pickedColor);
    cp5.get(ColorMatrix.class, "LED_sequence").set(currentFrame, selected, true);
  }
}

//ControlP5 listeners

void LED_sequence(int theX, int theY) {
  arcs[theY].arcColor = cp5.get(ColorMatrix.class, "LED_sequence").getCellColor(theX, theY);
}

void play_pause(boolean play_pause) {
  if (play_pause) {
    cp5.get(ColorMatrix.class, "LED_sequence").play();
  }
  else {
    cp5.get(ColorMatrix.class, "LED_sequence").pause();
  }
}

void timeline(int frame) {
  selected = -1;
  currentFrame = frame;
  cp5.get(ColorMatrix.class, "LED_sequence").trigger(frame);
  cp5.get(ColorMatrix.class, "LED_sequence").updatecnt(frame);
}

void speed(int frame) {
  cp5.get(ColorMatrix.class, "LED_sequence").setInterval(frame);
}

void bang() {
  selected = -1;
  cp5.get(ColorMatrix.class, "LED_sequence").clear();
}

void clean() {
  if (selected != -1) {
    arcs[selected].arcColor = 0;
    cp5.get(ColorMatrix.class, "LED_sequence").setCellColor(currentFrame, selected, 0);
    selected = -1;
  }
}

//format and save the txt file
void saveSeq() {
  String[] frames = new String[SEQUENCE_LENGTH];
  for (int x = 0; x<SEQUENCE_LENGTH; x++) {
    String frame = "{";
    for (int y = 0; y<NUMBER_OF_LED; y++) {
      int ledColor = cp5.get(ColorMatrix.class, "LED_sequence").getCellColor(x, y);
      String tempHue = hex(int(colorPicker.getHue(ledColor)), 2);
      String tempSat = hex(int(colorPicker.getSaturation(ledColor)), 2);
      String tempBright = hex(int(colorPicker.getBrightness(ledColor)), 2);
      frame += "{0x"+tempHue+ ", 0x"+tempSat+ ", 0x"+tempBright+ "},";
      //println("frame: "+frame);
    }
    frame = frame.substring( 0, frame.length()-1 );
    frames[x] = frame + "},";
  }
  saveStrings("ledSequence.txt", frames);
}

