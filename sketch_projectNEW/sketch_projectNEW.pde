import peasy.*;
PeasyCam cam;


int cols, rows;
int scl = 20;
int w = 2000;
int h = 1600;

float flying = 0;
float flyRate = 0.05; 
float[][] terrain; 
float angle;

void keyPressed() {
  if (key == CODED) { //Check if the keys are pressed
    if (keyCode == UP) { 
      angle -= 0.05; //Adjust the angle of the axis to adjust the view of the aircraft
    }
    if (keyCode == DOWN) {
      angle += 0.05;
    }
  }
}

void setup() {
  size(600, 600, P3D);

  cols = w/scl;
  rows = h/scl;
  terrain = new float[cols][rows];
  cam=new PeasyCam(this, 400, 400, 200, 700);
}

void draw() {

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
      if  (col1 <3) { //do this
        fill (32, 139,74);
      }
      else if(col1>3){ 
        fill ( 139, 79, 6);
      }
       else{ 
        fill (0, 255,0 );
      }
        vertex(x*scl, y*scl, terrain[x][y]);
        vertex(x*scl, (y+1)*scl, terrain[x][y+1]);
        //rect(x*scl, y*scl, scl, scl);
      }
      endShape();
    }
  }
