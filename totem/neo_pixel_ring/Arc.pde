class Arc {

    color arcColor;
    float rotation;
    PVector pos;
    color strokeColor;
    boolean select = false;
    int strokeW = 1;

    Arc(float rot, PVector posit) {
       rotation = rot;
       pos = posit;
       arcColor = color(.5, 0, 0);
       strokeColor = 0;
   }

   boolean update() {
    if(select) {
      strokeColor = color(0, 0, 1);
      strokeW = 2;
      }else{
        strokeColor = color(0, 0, .4);
        strokeW = 1;
      }
    float far = dist(mouseX, mouseY, pos.x, pos.y);
    float angle = atan2(mouseY-pos.y,mouseX-pos.x);
    if(angle<-0.175) angle += TAU;
    if(mousePressed && far>110 && far < 150 && angle < .175+rotation && angle> -.175+rotation) {
        return true;
        }else{
          return false;
    }
    
}

void display() {
    fill(arcColor);
    strokeWeight(strokeW);
    stroke(strokeColor);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(rotation);
    shape(arc1, 0, 0);
    popMatrix();

}

}
