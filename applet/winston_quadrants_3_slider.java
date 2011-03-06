import processing.core.*; 
import processing.xml.*; 

import processing.video.*; 
import java.awt.Robot; 
import java.awt.event.InputEvent; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class winston_quadrants_3_slider extends PApplet {


 





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



public void setup() {
  println(Capture.list());
  background(255);
  size(950, 500); 

  video = new Capture(this, 950, 500, 30); 
  prevFrame = createImage(video.width, video.height, RGB); 

  myButton = new MButton(0,0, 100, 60, 0xffFA0AB6); 
  myButton2 = new MButton(850, 0, 100, 60, 0xff08FF4B);

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

public void draw() {

  if(video.available()) {
    //  prevFrame.copy(video,0,0,video.width,video.height,0,0,video.width,video.height); 
    // prevFrame.updatePixels();
    video.read();
  }


  pushMatrix();
  scale(-1.0f, 1.0f);
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
  myButton.vidThreshold = PApplet.parseInt (map(mySlider.sliderVal, 0, 100, 50, 300) );  
  myButton2.vidThreshold = PApplet.parseInt (map(mySlider.sliderVal, 0, 100, 50, 300) );
  
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




class MButton {

  int positionX, positionY; //position of button 
  int pixelX, pixelY; 
  int buttonWidth, buttonHeight;
  int c; 
  PImage prev; 
  PImage curr; 
  int numPixels;  
  boolean topRight = false; 
  
  boolean isdragging = false;

  float previous_average;
  float current_average;

  boolean motion = false; 
  float diff; 
  long timePassed;
  int vidThreshold = 150; //sensitivity
  
  int cooldown_counter = 0; //frequency

  MButton(int tempX, int tempY, int tempbuttonWidth, int tempbuttonHeight, int bcolor) {
    buttonWidth = tempbuttonWidth; //hi erica
    buttonHeight = tempbuttonHeight; 
    c = color(bcolor);
    positionX = tempX; 
    positionY = tempY; 
    // prev = tempP;
    // curr = tempC;
  } // end constructor


  //returns the difference
  public boolean changeDetect() {

    if (isdragging == false)
      {
    
    int pixelCount = 0;
    float difavg = 0;
    int numpixels = 0;

    for (int x = positionX; x < positionX + buttonWidth; x ++ ) { 
      for (int y = positionY; y < positionY + buttonHeight; y ++ ) {
        int newX = x + positionX; 
        int newY = y + positionY; 

        int loc = newX + newY*video.width;           
        int current = video.pixels[loc];      
        int previous = prevFrame.pixels[loc]; 


        float r1 = red(current); 
        float g1 = green(current); 
        float b1 = blue(current);
        float r2 = red(previous); 
        float g2 = green(previous); 
        float b2 = blue(previous);
        diff = dist(r1,g1,b1,r2,g2,b2);

        difavg = difavg + diff;
        numpixels++;
        }
      }

    // calculate the current average
    current_average = difavg/numpixels;

    // only check to see if we have a difference if we are not in cooldown mode
    if (cooldown_counter <= 0)
      {
      // if the current average is significnatly different than the previous average
      // then we should trigger a button press
      if (abs(current_average - previous_average)/current_average > 0.10f)
        {
        println ("BUTTON PRESS!");
        cooldown_counter = 10;
        
        return (true);
        }
      }
    // otherwise we should decrease our cooldown counter by 1
    else
      {
      cooldown_counter--;
     
      if (cooldown_counter < 0)
        {
        cooldown_counter = 0;
        } 
      }
      
    // now store the current average as the previous average
    previous_average = current_average;


    return false;
    
      }
      
   // if we are dragging, return false
   else
     {
     return false; 
     }
    
    
  } // end changeDetect() 



  //displays button
  public void display() {
    // smooth(); 
    fill(c);
    rect(positionX, positionY, buttonWidth, buttonHeight);

    // test to see if the mouse is clicking on me
    if (mousePressed && mouseX > positionX && mouseX < positionX + buttonWidth && mouseY > positionY && mouseY < positionY + buttonHeight)
      {
      positionX = PApplet.parseInt(mouseX - 0.5f * buttonWidth);
      positionY = PApplet.parseInt(mouseY - 0.5f * buttonHeight);
       
      if (positionX > 850)
        {
        positionX = 850; 
        }
        
      isdragging = true;
        
      println ("dragging the button!"); 
      }
      
    else
      {
      isdragging = false; 
      }
    
  }

  
} // end class 

class Slider {
  int startWidth;
  int startHeight;
  int fillColor;
  int sliderColor;
  int sliderVal;
  int maxVal; 
  int minVal;
  int xPos;
  int yPos;
  boolean inside;	

  Slider() {
  }

  public void update() {
    //if the mouse is inside

      if(mouseX>this.xPos & mouseX<this.xPos+startWidth & mouseY>this.yPos & mouseY<this.yPos+startHeight) {

      inside = true;
    }	

    else {

      inside = false;
    }

    //is the mouse down

    if(mousePressed && inside == true) {	

      //println("button click");

      sliderVal = mouseX-xPos;	

      render();
    }
  }

  public void render() {
    noStroke();
    pushMatrix();
    translate(xPos,yPos);
    fill(fillColor);
    rect(0,0,startWidth,startHeight);
    fill(sliderColor);
    rect(0,0,sliderVal,startHeight);
    popMatrix();
  }


  public void setupSlider(int _startWidth, int _startHeight, int _fillColor, int _sliderColor, int _maxVal, int _minVal, int _sliderVal, int _xPos, int _yPos) {
    startWidth = _startWidth;
    startHeight = _startHeight;
    fillColor = _fillColor;
    sliderColor = _sliderColor;
    maxVal = _maxVal;
    minVal = _minVal;
    sliderVal = _sliderVal;
    xPos = _xPos;
    yPos = _yPos;
  }
}


  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "winston_quadrants_3_slider" });
  }
}
