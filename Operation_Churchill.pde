
import processing.video.*; 

import java.awt.Robot;
import java.awt.event.InputEvent;


//buttons 
MButton myButton; 
MButton myButton2; 


Slider mySlider;


long timePassed; 
//float difference1; 
//float difference2; 
int threshold = 800; //motion detection 

PImage prevFrame; 
PImage currFrame; 

boolean debug = true; 

Robot r;

Capture video; 



void setup() {
  println(Capture.list());
  background(255);
  size(950, 500); 

  video = new Capture(this, 950, 500, 30); 
  prevFrame = createImage(video.width, video.height, RGB); 

  myButton = new MButton(0,0, 100, 60, #FA0AB6); 
  myButton2 = new MButton(850, 0, 100, 60, #08FF4B);

  mySlider = new Slider();
  mySlider.setupSlider(120,10,120,200,100,0,60,50,50);
  mySlider.render();
  smooth();


//create robot instance
try {
    r = new Robot();
  }
  catch (Exception e) {
    println("error");
  }
  
 }

void draw() {

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



  //trigger specific actions with the buttons

    timePassed = millis();  //variable to delay button functionality after video loads 

    if(myButton.changeDetect() && timePassed > 7000) 
  {
    myButton.motion = true; 
    println ("NPR");
    link("http://npr.org", "_new");
  }

  if(myButton2.changeDetect() && timePassed > 7000) 
  {
    myButton2.motion = true; 
    println ("Program link clicked");
    r.mouseMove(690,250);
    r.mousePress(InputEvent.BUTTON1_MASK);
    r.mouseRelease(InputEvent.BUTTON1_MASK);
    
  }
  
  
  // handle any slider changes
  mySlider.update();
  mySlider.render();
  
  // use the slider value to update the threshold
  myButton.vidThreshold = int (map(mySlider.sliderVal, 0, 100, 50, 300) );  
  myButton2.vidThreshold = int (map(mySlider.sliderVal, 0, 100, 50, 300) );
  
  //make buttons draggable
  
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
  
  
  
}




