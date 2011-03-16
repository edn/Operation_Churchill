
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

boolean iTunesLaunched = false;
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

    if (iTunesLaunched==false) {
      myButton.motion = true; 
      println ("iTunes"); 
      //open spotlight
      r.keyPress(KeyEvent.VK_CONTROL); 
      r.keyPress(KeyEvent.VK_SPACE);
      r.delay(200);
      r.keyRelease(KeyEvent.VK_CONTROL); 
      r.keyRelease(KeyEvent.VK_SPACE);
      r.delay(2000);
      //open iTunes
      r.keyPress(KeyEvent.VK_I); 
      r.keyPress(KeyEvent.VK_T);
      r.keyPress(KeyEvent.VK_U); 
      r.keyPress(KeyEvent.VK_N);
      r.keyPress(KeyEvent.VK_ENTER);
      iTunesLaunched=true;
    }
    if(iTunesLaunched==true) {
      myButton.motion = true; 
      println ("next song"); 
      r.keyPress(KeyEvent.VK_RIGHT);
      r.keyRelease(KeyEvent.VK_RIGHT);
    }
  } 


//  if(myButton.changeDetect() && myButton2.changeDetect()) 
//  {
//    myButton.motion = true;
//   
//    println ("previous track"); 
//    r.keyPress(keyEvent.VK_LEFT);
//    r.keyRelease(KeyEvent.VK_LEFT  );
//  }

  if(myButton2.changeDetect() && timePassed > 12000) 
  {
    myButton2.motion = true; 
    println ("play/pause"); 
    r.keyPress(keyEvent.VK_SPACE);
    r.keyRelease(KeyEvent.VK_SPACE);
  }


  // handle any slider changes
  mySlider.update();
  mySlider.render();

  // use the slider value to update the threshold
  myButton.vidThreshold = int (map(mySlider.sliderVal, 0, 100, 50, 300) );  
  myButton2.vidThreshold = int (map(mySlider.sliderVal, 0, 100, 50, 300) );
}



