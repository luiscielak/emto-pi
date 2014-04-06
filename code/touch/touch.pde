color currentColor;

void setup() {
//  size(600, 800);
  size(640,1136);
  background(30);
  noCursor();

  currentColor = 2;

  stroke(240);
  noFill();
}



void draw() {
  background(30);


  drawMouse();
}



void drawMouse() {

  ellipse(mouseX, mouseY, 10, 10);

  stroke(currentColor);
  noFill();
  ellipse(mouseX, mouseY, 30, 30);

  if (mousePressed) {

    if (mouseX>width/2 && mouseY>height/2) background(235, 128, 32);
    if (mouseX<width/2 && mouseY>height/2) background(235, 32, 128);
    if (mouseX<width/2 && mouseY<height/2) background(32, 235, 128);
    if (mouseX>width/2 && mouseY<height/2) background(32, 128, 235);

    currentColor = 200;

    stroke(240);
    noFill();
    ellipse(mouseX, mouseY, 30, 30);
    ellipse(mouseX, mouseY, 10, 10);
  } 
  else {
    currentColor = 2;
  }
}
