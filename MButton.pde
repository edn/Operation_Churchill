class MButton {

  int positionX, positionY; //position of button 
  int pixelX, pixelY; 
  int buttonWidth, buttonHeight;
  color c; 
  PImage prev; 
  PImage curr; 
  int numPixels; 
  boolean topRight = false; 

  boolean motion = false; 
  float diff; 
  long timePassed;
  int vidThreshold = 120;

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
  int changeDetect() {

    int pixelCount = 0;

    for (int x = 0; x < buttonWidth; x ++ ) { 
      for (int y = 0; y < buttonHeight; y ++ ) {
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

        if (diff > vidThreshold) { 
          pixelCount++;
        }
      }
    }
    return pixelCount;
  } // end changeDetect() 



  //displays button
  void display() {
    // smooth(); 
    fill(c);
    rect(positionX, positionY, buttonWidth, buttonHeight);

    //    if(positionX <500){
    //    image(corner, positionX, positionY); 
    //    }
    //    else{
    //     image(corner2, positionX-20, positionY); 
    //    }
  }

}


