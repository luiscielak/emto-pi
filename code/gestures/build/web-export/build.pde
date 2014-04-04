// gestures.pde
// prototype gestures for web ios app

void setup() {
  // size(640,1113);
  size(600,800);
  background(#000000);
  noCursor();

}

void draw() {
  background(0,0,0);


  // Custom mouse cursor
  fill(240,240,240,120);
  strokeWeight(2);
  stroke(200,200,200,120);
  ellipse(mouseX,mouseY,20,20);

}


void mousePressed(){

  background(240,240,240);

  for (int i = 0; i < 30; ++i) {

    fill(240,240,240,i+10);
    // ellipse(pmouseX,pmouseY,20 *i,20*i);

  }



}

