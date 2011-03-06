class Slider {
  int startWidth;
  int startHeight;
  color fillColor;
  int sliderColor;
  int sliderVal;
  int maxVal; 
  int minVal;
  int xPos;
  int yPos;
  boolean inside;	

  Slider() {
  }

  void update() {
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

  void render() {
    noStroke();
    pushMatrix();
    translate(xPos,yPos);
    fill(fillColor);
    rect(0,0,startWidth,startHeight);
    fill(sliderColor);
    rect(0,0,sliderVal,startHeight);
    popMatrix();
  }


  void setupSlider(int _startWidth, int _startHeight, int _fillColor, int _sliderColor, int _maxVal, int _minVal, int _sliderVal, int _xPos, int _yPos) {
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


