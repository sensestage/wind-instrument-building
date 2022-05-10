
// importing libraries that we will use
//import grafica.*;

import oscP5.*;
import netP5.*;

// the minibee to which we will be listening in this sketch:
int myMiniBeeID = 1;

PFont f;

// instance of the OSC connection
OscP5 oscP5;

// settings for the OSC reception
// NetAddress oscTarget;
String oscTargetIP = "127.0.0.1";
int oscTargetPort = 57120;

// Prepare the points for the plot
int nPoints = 100;

// setup function
// here we initiase all the plots and the OSC connection
void setup()
{    
    size(640, 360);
    colorMode(HSB, width, 100, height);
    noStroke();
    background(0);
  
    /* start oscP5, listening for incoming messages at port 12000 */
    oscP5 = new OscP5(this,12000);
    //   oscTarget = new NetAddress("127.0.0.1",57121);

  //printArray(PFont.list());
//  PFont.list();
  f = createFont(PFont.list()[2322], 24);
  textFont(f);
}

float value1 = 0.5;
float output = 0.6;
float prevOutput = 0;
float alpha=0.05;


// the draw function: here we call the update functions of each plot to redraw the data
public void draw() {
  background(0); 
  noStroke();
  fill(200, 200, 100);
  int barheight1 = (int) (value1*height);
  int barheight2 = (int) (output*height);
  rect(width*0.3, barheight1, width*0.15, height - barheight1);
  rect(width*0.55, barheight2, width*0.15, height - barheight2);
  
  textAlign(RIGHT);
  drawValue(width * 0.25, value1);

  textAlign(LEFT);
  drawValue(width * 0.75, output);

}

void drawValue(float x, float val) {
  stroke(250);
  line(x, 0, x, 65);
  line(x, 100, x, height);
  fill(250);
  text(val, x, 95);
}

// oscEvent function: here we parse the incoming data and add it to the data to be plotted in the graphs

// incoming osc message are forwarded to the oscEvent method.
void oscEvent(OscMessage theOscMessage) {
  // print the address pattern and the typetag of the received OscMessage 
 //print("### received an osc message.");
 //print(" addrpattern: "+theOscMessage.addrPattern());
 //println(" typetag: "+theOscMessage.typetag());
  
  if(theOscMessage.checkAddrPattern("/minibee/data")==true){ // look for for the message type
    if(theOscMessage.checkTypetag("ifffff")) { // receiving int (id) and five float values for the data
      // parse theOscMessage and extract the values from the osc message arguments.
      int id = theOscMessage.get(0).intValue(); // get the minibee ID from the message arguments
      if ( id == myMiniBeeID ){ // if the minibee ID matches the one we are looking for, then parse the rest of the data
        float v1 = theOscMessage.get(1).floatValue();
        float v2 = theOscMessage.get(2).floatValue();
        float x = theOscMessage.get(3).floatValue();
        float y = theOscMessage.get(4).floatValue();
        float z = theOscMessage.get(5).floatValue();
        //println( "x :" + x + ", y :" + y +", z :" + z ); // optionally, you can print the data here to for debugging
        
        value1 = v1;
        updateOutput();
        return;
      }
    }
  }
}

void updateOutput(){
  prevOutput = output;
  output = alpha * value1 + (1-alpha)*prevOutput;
}
