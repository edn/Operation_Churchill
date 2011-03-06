class MButton {

  int positionX, positionY; //position of button 
  int pixelX, pixelY; 
  int buttonWidth, buttonHeight;
  color c; 
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
  boolean changeDetect() {

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
        color current = video.pixels[loc];      
        color previous = prevFrame.pixels[loc]; 


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
      if (abs(current_average - previous_average)/current_average > 0.10)
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
  void display() {
    // smooth(); 
    fill(c);
    rect(positionX, positionY, buttonWidth, buttonHeight);

    // test to see if the mouse is clicking on me
    if (mousePressed && mouseX > positionX && mouseX < positionX + buttonWidth && mouseY > positionY && mouseY < positionY + buttonHeight)
      {
      positionX = int(mouseX - 0.5 * buttonWidth);
      positionY = int(mouseY - 0.5 * buttonHeight);
       
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

