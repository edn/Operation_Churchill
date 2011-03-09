
import processing.video.*; 

//buttons 
MButton myButton; 
MButton myButton2; 


long timePassed; 
float difference1; 
float difference2; 
int threshold = 500; //motion detection 

PImage prevFrame; 
PImage currFrame; 

boolean debug = true; 

Capture video; 


void setup() {

  background(255);
  size(950, 500); 

  video = new Capture(this, 950, 500, 30); 
  prevFrame = createImage(video.width, video.height, RGB); 

  myButton = new MButton(0,0, 100, 60, #FF4608); 
  myButton2 = new MButton(850, 0, 100, 60, #08FF4B);
} // end setup 



void draw() {
  background(255);

  if (keyPressed) {
    { 
      if (key == 'r' || key == 'R' ) {
        myButton.positionX = mouseX; 
        myButton.positionY = mouseY;
      }
    }
  }

    
  if (keyPressed) {
    { 
      if (key == 'g' || key == 'G') {
        myButton2.positionX = mouseX; 
        myButton2.positionY = mouseY;
      }
    }
  }

    //setup stage

    noFill();


    if(video.available()) {
      //  prevFrame.copy(video,0,0,video.width,video.height,0,0,video.width,video.height); 
      // prevFrame.updatePixels();
      video.read();
    }

    pushMatrix();
    scale(-1.0, 1.0);
    image(video,-video.width,0);
    popMatrix();

    myButton.display();
    myButton2.display(); 





    video.loadPixels(); 
    prevFrame.loadPixels(); 


    timePassed = millis(); 

    difference1 = myButton.changeDetect(); 
    difference2 = myButton2.changeDetect();

    // println(difference1);
    //println(difference2); 

    if(difference1 > threshold && timePassed > 5000) {
      myButton.motion = true; 
      println ("NPR");
      println(myButton.positionX);
      println(myButton.positionY);
      // link("http://npr.org", "_new"); 
      //background(0);
    }
    if(difference2 > threshold && timePassed > 5000) {
      myButton2.motion = true; 
      println ("email");
      //background(255,0,0);
    }
  }

