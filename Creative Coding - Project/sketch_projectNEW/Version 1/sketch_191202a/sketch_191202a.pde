
//Necessary for OSC communication with Wekinator:
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress dest;
import damkjer.ocd.*;

Camera myCam;





int cols, rows;
int scl = 20;
int w = 2000;
int h = 1600;

float flying = 0;
float flyRate = 0.0; 
float[][] terrain; 
float angle;
float roll = 0;
float tilt = 0;
void keyPressed() {
  if (key == CODED) { //Check if the keys are pressed
    if (keyCode == UP) { 
      angle -= 0.05; //;Adjust the angle of the axis to adjust the view of the aircraft
    }
    if (keyCode == DOWN) {
      angle += 0.05;
    }
  }
}

void setup() {
  size(600, 600, P3D);

  //Initialize OSC communication
  oscP5 = new OscP5(this, 12000); //listen for OSC messages on port 12000 (Wekinator default)
  dest = new NetAddress("127.0.0.1", 6448); //send messages back to Wekinator on port 6448, localhost (this machine) (default)

  cols = w/scl;
  rows = h/scl;
  terrain = new float[cols][rows];
  // myCam = new Camera(this, 100, -125, 150); // this is camera starting position!
  myCam = new Camera(this, 100, 0, 150); // this is camera starting position!  myCam = new Camera(this, 100, -125, 150); // this is camera starting position!
}

void draw() {
  myCam.feed();
  myCam.tilt(radians(map(roll, 0, 1, -.5, .5)));

  flying -= 0.1;
  flying -= flyRate; //flyrate is a constant. You can meddle with this value
  float yoff = flying; // We constantly adjust the value of yoff using flying



  yoff = flying; 
  for (int y =0; y < rows; y++) { 
    float xoff = 0;
    for (int x = 0; x < cols; x++) {
      terrain[x][y] = map(noise(xoff, yoff), 0, 1, -100, 100);
      xoff += 0.2;
      //  println(terrain[1]);
    }
    yoff += 0.2;
  }

  background(0);
  stroke(255);
  noFill(); 
  translate(width/2, height/2+70);
  rotateX(PI/3);
  translate(-w/2, -h/2); 

  for (int y =0; y < rows-1; y++) { 
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      float col1 = (terrain[x][y]);
      //println(terrain[x][y]);


   
      if (col1 >= 25)
      {
        fill(97, 46, 2);
      }
      else if (col1 < 20 &&col1 >= -10)
      {
        fill(88, 156, 0);
      }
      else if (col1 < -21)
      {
       fill(0, 120, 156); 
      }

      vertex(x*scl, y*scl, terrain[x][y]);
      vertex(x*scl, (y+1)*scl, terrain[x][y+1]);
      //rect(x*scl, y*scl, scl, scl);
    }
    endShape();
  }
}

//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
  println("received message");
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    if (theOscMessage.checkTypetag("ff")) {
      roll = theOscMessage.get(0).floatValue();
      tilt = theOscMessage.get(1).floatValue();
      println("received1");
      println(roll);
    }
  }
}
