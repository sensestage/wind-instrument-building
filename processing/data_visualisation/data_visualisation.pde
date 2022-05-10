
// importing libraries that we will use
import grafica.*;

import oscP5.*;
import netP5.*;

// the minibee to which we will be listening in this sketch:
int myMiniBeeID = 1;


// instance of the OSC connection
OscP5 oscP5;

// settings for the OSC reception
// NetAddress oscTarget;
String oscTargetIP = "127.0.0.1";
int oscTargetPort = 57120;

// Prepare the points for the plot
int nPoints = 100;

// prepare the different graphs for the plot
CIPlotter3Axes acceleroPlot = new CIPlotter3Axes( this, 100 );
CIPlotter2 pressurePlot = new CIPlotter2( this, 200 );
CIPlotter2 tailPlot = new CIPlotter2( this, 200 );

// later we can add more graphs for derived data
//CIPlotter2 pressureVarPlot = new CIPlotter2( this, 200 );
//CIPlotter2 tailVarPlot = new CIPlotter2( this, 200 );


// setup function
// here we initiase all the plots and the OSC connection
void setup()
{
    size(1300, 700);
    background(0);
    
    acceleroPlot.initLinePlot( "Accelerometer", 0, 0, 900, 150, "time", "acceleration" );
    acceleroPlot.init2DPlot( "Accelerometer", 1000, 0, 200, 150, "x", "y/z" );

    pressurePlot.initLinePlot( "Pressure sensor", 0, 220, 1200, 155, "time", "pressure" );
    tailPlot.initLinePlot( "Tail sensor", 0, 445, 1200, 155, "time", "tail" );

    //pressureVarPlot.initLinePlot( "Pressure Variation", 0, 750, 900, 180, "time", "pressure variation" );
    //tailVarPlot.initLinePlot( "Tail Variation", 950, 750, 900, 180, "time", "tail variation" );


    /* start oscP5, listening for incoming messages at port 12000 */
    oscP5 = new OscP5(this,12000);
    //   oscTarget = new NetAddress("127.0.0.1",57121);

}

// the draw function: here we call the update functions of each plot to redraw the data
public void draw() {
  background(0);  
  acceleroPlot.updateLinePlot();
  acceleroPlot.update2DPlot();
  
  pressurePlot.updateLinePlot();
  tailPlot.updateLinePlot();
  //pressureVarPlot.updateLinePlot();
  //tailVarPlot.updateLinePlot();
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
        float v1 = theOscMessage.get(0).floatValue();
        float v2 = theOscMessage.get(1).floatValue();
        float x = theOscMessage.get(2).floatValue();
        float y = theOscMessage.get(3).floatValue();
        float z = theOscMessage.get(4).floatValue();
        //println( "x :" + x + ", y :" + y +", z :" + z ); // optionally, you can print the data here to for debugging
        
        // add the data to the plots
        pressurePlot.addPoint( v1, 0 );
        tailPlot.addPoint( v2, 0 );
        acceleroPlot.addPoint( x, y, z );
        return;
      }
    }
  }
}
