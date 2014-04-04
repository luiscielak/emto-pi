import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class build extends PApplet {

// gestures.pde
// prototype gestures for web ios app

public void setup() {
  // size(640,1113);
  size(600,800);
  background(0xff000000);
  noCursor();

}

public void draw() {
  background(0,0,0);


  // Custom mouse cursor
  fill(240,240,240,120);
  strokeWeight(2);
  stroke(200,200,200,120);
  ellipse(mouseX,mouseY,20,20);

}


public void mousePressed(){

  background(240,240,240);

  for (int i = 0; i < 30; ++i) {

    fill(240,240,240,i+10);
    // ellipse(pmouseX,pmouseY,20 *i,20*i);

  }



}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "build" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
