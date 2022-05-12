
// importing libraries that we will use
import grafica.*;

import oscP5.*;
import netP5.*;

// the minibee to which we will be listening in this sketch:
int myMiniBeeID = 3;
// ADAPT this port to something unique!
int myPort = 12020;

// instance of the OSC connection
OscP5 oscP5;

// settings for the OSC reception
NetAddress oscTarget;
String myIP = "10.18.0.162";
String oscTargetIP = "10.18.0.162";
int oscTargetPort = 57300;

// prepare the different graphs for the plot
//CIPlotter3Axes acceleroPlot = new CIPlotter3Axes( this, 100 );
CIPlotter4 rawPlot = new CIPlotter4( this, 200 );
CIPlotter2 smoothPlot = new CIPlotter2( this, 200 );
CIPlotter2 differencePlot = new CIPlotter2( this, 200 );


// input value
float input = 0.5;
float output1 = 0;
float output2 = 0;
float output3 = 0;
float output4 = 0;
float output5 = 0;

// initialize parameters for range tracking
float minimum = 1.0;
float maximum = 0.0;

// declare variable for slope calculation
int prevTime;
int triggerTime;

// variable for mean calculation
boolean initialized = false;


// outputs for triggers
boolean trigger1 = false;
int upDown = 0;
boolean trigger2 = false;
boolean trigger3 = false;



// setup function
// here we initiase all the plots and the OSC connection
void setup()
{
    size(1300, 700);
    background(0);
    
    //acceleroPlot.initLinePlot( "Accelerometer", 0, 0, 900, 130, "time", "acceleration" );
    //acceleroPlot.init2DPlot( "Accelerometer", 1000, 0, 200, 130, "x", "y/z" );

    rawPlot.initLinePlot( "Raw sensor data", 0, 0, 1200, 150, "time", "sensors" );
    smoothPlot.initLinePlot( "Smoothed data", 0, 220, 1200, 150, "time", "smooth" );
    differencePlot.initLinePlot( "difference data", 0, 440, 1200, 150, "time", "difference" );

    //pressureVarPlot.initLinePlot( "Pressure Variation", 0, 750, 900, 180, "time", "pressure variation" );
    //tailVarPlot.initLinePlot( "Tail Variation", 950, 750, 900, 180, "time", "tail variation" );

    /* start oscP5, listening for incoming messages at port 12000 */
    oscP5 = new OscP5(this,myPort);
    oscTarget = new NetAddress(oscTargetIP,oscTargetPort);

    // send a message to connect to the data
    
    OscMessage myMessage = new OscMessage("/XOSC/subscribe/tag");  
    myMessage.add("/minibee/data");
    myMessage.add(myPort);

  /* send the message */
    oscP5.send(myMessage, oscTarget ); 
}

// the draw function: here we call the update functions of each plot to redraw the data
public void draw() {
  background(0);  
  //acceleroPlot.updateLinePlot();
  //acceleroPlot.update2DPlot();
  
  rawPlot.updateLinePlot();
  smoothPlot.updateLinePlot();
  differencePlot.updateLinePlot();
}

// oscEvent function: here we parse the incoming data and add it to the data to be plotted in the graphs

// incoming osc message are forwarded to the oscEvent method.
void oscEvent(OscMessage theOscMessage) {
  // print the address pattern and the typetag of the received OscMessage 
 //print("### received an osc message.");
 //print(" addrpattern: "+theOscMessage.addrPattern());
 //println(" typetag: "+theOscMessage.typetag());

  if(theOscMessage.checkAddrPattern("/XOSC/subscribe")==true){ // look for for the message type
   print("### received an osc message.");
   print(" addrpattern: "+theOscMessage.addrPattern());
   println(" typetag: "+theOscMessage.typetag());
  } else if(theOscMessage.checkAddrPattern("/minibee/data")==true){ // look for for the message type
    if(theOscMessage.checkTypetag("ifffffff")) { // receiving int (id) and five float values for the data
      // parse theOscMessage and extract the values from the osc message arguments.
      int id = theOscMessage.get(0).intValue(); // get the minibee ID from the message arguments
      if ( id == myMiniBeeID ){ // if the minibee ID matches the one we are looking for, then parse the rest of the data
        float v1 = theOscMessage.get(1).floatValue();
        float v2 = theOscMessage.get(2).floatValue();
        float v3 = theOscMessage.get(3).floatValue();
        float v4 = theOscMessage.get(4).floatValue();
        
        float x = theOscMessage.get(5).floatValue();
        float y = theOscMessage.get(6).floatValue();
        float z = theOscMessage.get(7).floatValue();
        //println( "x :" + x + ", y :" + y +", z :" + z ); // optionally, you can print the data here to for debugging
                
        // data processing
        input = v1; // select here which sensor value you want to process
        
        checkRange( input );
        
        //// scaling (needs range)
        output1 = scaleToRange( input );
        //output1 = invertUnipolar( output1 );
        
        output2 = updateExponentialSmooth( output1 );
        
        ////print( output1, output2 );
        
        if ( !initialized ){
          initializeMean( output1 );
        }
        output3 = updateMean( output1 );
        
        output4 = deviation( output1, output3 );
        output5 = updateDelta( output1 );
        //output5 = updateSlope( output1 );
        
        //trigger1 = compareLarger( output1, 0.7 );
        //upDown = upOrDown( output1, 0.7 );
        //trigger2 = upDeadTime( output1, 0.7, 1000 ); // 1000 milliseconds (1 second) of dead time
        //trigger3 = triggerAboveReset( output1, 0.7, 0.5 ); // enable retrigger when going below 0.5

      
        // add the data to the plots
        rawPlot.addPoints( v1, v2, v3, v4 );
        //acceleroPlot.addPoint( x, y, z );
        // to the smoothplot, add 
        smoothPlot.addPoints( output1, output3 ); // scaled input and mean of scaled input
        differencePlot.addPoints( output4, output5 ); // deviation of mean and delta

        return;
      }
    }
  }
}

///--------- Tracking the range ---------
void checkRange( float val ){
  if ( val > maximum ){
    maximum = val; 
  }
  if ( val < minimum ){
    minimum = val;  
  }
}

///--------- Scaling the data ---------

float scaleToRange( float val ){
  if ( minimum == maximum ){
    print( "WARNING: maximum equals minimum, not scaling, returning input value" );
    return val;  
  }
  float out = (val - minimum) / (maximum - minimum);
  return out;
}

///--------- Invert (unipolar) -------------

float invertUnipolar( float val ){
  return ( 1 - val );  
}

///--------- Exponential smoothing ---------

// variables for smoothing
float smooth = 0.0;
float prevSmooth = 0.0;
float alpha=0.1;

// exponential smoothing:
float updateExponentialSmooth( float val ){
  prevSmooth = smooth;
  smooth = alpha * val + (1-alpha)*prevSmooth;
  //println( "smooth: " + smooth + "alpha: " + alpha + "val: " + val ); 
  return smooth;
}

///--------- Mean value ---------

// variables for mean/average
int windowSize = 10; // we calculate over N samples, the windowSize
float inputValues[]; // the array for the input values
float sum = 0; // the sum we calculate
int inputIndex=0; // the current index where we are writing the next sample in the array

// calculating mean/average value:
void initializeMean( float val ){ // initialization
 inputValues = new float[windowSize];
 for ( int i=0; i<windowSize; i++ ){
   inputValues[i] = val;
   sum += val;
 }
 initialized = true; 
}

float updateMean( float val ){ // update
  sum -= inputValues[inputIndex];
  sum += val;
  inputValues[inputIndex] = val;
  inputIndex++;
  inputIndex = inputIndex%windowSize;
  return (sum/windowSize);
}

///------------ Delta -------------
float prevInputDelta = 0;

float updateDelta( float val ){
  float delta = val - prevInputDelta;
  prevInputDelta = val;
  return delta;
}

///------------ Slope -------------
float prevInputSlope = 0;

float updateSlope( float val ){
  int now = millis(); 
  float slope = (val-prevInputSlope) / (now-prevTime);
  prevTime = now;
  prevInputSlope = val;
  return slope*10;
}

///------------- Deviation of smoothed signal ----------

float deviation( float val, float smooth ){
    return ( val - smooth );
}

///------------- Compare with threshold ----------------
boolean compareLarger( float val, float threshold ){
  return ( val > threshold);
}

boolean compareSmaller( float val, float threshold ){
  return ( val < threshold);
}

float prevValUD=0;

int upOrDown( float val, float threshold ){
  if ( val > threshold ){ // now larger than threshold
      // was it smaller before?
      if ( prevValUD < threshold ){
        prevValUD = val;
        return 1; // going up  
      }
  }
  if ( val < threshold ){ // now smaller than threshold
      // was it larger before?
      if ( prevValUD > threshold ){
        prevValUD = val;
        return -1; // going down  
      }
  }
  prevValUD = val;
  return 0; // was already above or below threshold
}

/// ---- trigger with dead time -----

boolean compareLargerDeadTime( float val, float threshold, int deadtime ){
  int now = millis();
  if ( val > threshold ){
    if ( (now-triggerTime) > deadtime ){
      triggerTime = now;
      return true;
    }
  }
  return false;
}

boolean compareSmallerDeadTime( float val, float threshold, int deadtime ){
  int now = millis();
  if ( val < threshold ){
    if ( (now-triggerTime) > deadtime ){
      triggerTime = now;
      return true;
    }
  }
  return false;
}

float prevValUDDT=0; // used by both upDeadTime and downDeadTime!

boolean upDeadTime( float val, float threshold, int deadTime ){
  int now = millis();
  //println( "val: " + val + " prevValUDDT: " + prevValUDDT + " threshold: " + threshold + " deadTime " + deadTime + " triggerTime " + triggerTime + " now " + now );
  if ( val > threshold ){ // now larger than threshold
      // was it smaller before?
      if ( prevValUDDT < threshold ){
        prevValUDDT = val;
        if ( (now-triggerTime) > deadTime ){
          triggerTime = now;
          return true; // going up 
        }
      }
  }
  prevValUDDT = val;
  return false;
}

boolean downDeadTime( float val, float threshold, int deadTime ){
  int now = millis();
  if ( val < threshold ){ // now larger than threshold
      // was it smaller before?
      if ( prevValUDDT > threshold ){
        prevValUDDT = val;
        if ( (now-triggerTime) > deadTime ){
          triggerTime = now;
          return true; // going up 
        }
      }
  }
  prevValUDDT = val;
  return false;
}

/// ---- trigger with reet threshold -----

boolean canTrigger=true; // used both by triggerAboveReset and triggerBelowReset

boolean triggerAboveReset( float val, float triggerThreshold, float resetThreshold ){
  //int now = millis();
  if ( val > triggerThreshold ){ // now larger than threshold
    if ( canTrigger ){
      canTrigger = false;
      return true;
    }
  }
  if ( val < resetThreshold ){
    canTrigger = true;  
  }
  return false;
}

boolean triggerBelowReset( float val, float triggerThreshold, float resetThreshold ){
  //int now = millis();
  if ( val < triggerThreshold ){ // now larger than threshold
    if ( canTrigger ){
      canTrigger = false;
      return true;
    }
  }
  if ( val > resetThreshold ){
    canTrigger = true;  
  }
  return false;
}
