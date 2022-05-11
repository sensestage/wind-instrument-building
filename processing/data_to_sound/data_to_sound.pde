// importing libraries that we will use
//import grafica.*;

import oscP5.*;
import netP5.*;


import processing.sound.*;

TriOsc triOsc;
Env env; 

// Times and levels for the ASR envelope
float attackTime = 0.001;
float sustainTime = 0.004;
float sustainLevel = 0.3;
float releaseTime = 0.5;



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

PFont f;

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
    size(1200, 360);
    colorMode(HSB, 100, 100, 100);
    noStroke();
    background(0);
  
    /* start oscP5, listening for incoming messages at port 12000 */
    oscP5 = new OscP5(this,myPort);
    oscTarget = new NetAddress(oscTargetIP,oscTargetPort);
    // send a message to connect to the data    
    OscMessage myMessage = new OscMessage("/XOSC/subscribe/tag");  
    myMessage.add("/minibee/data");
    myMessage.add(myPort);
    oscP5.send(myMessage, oscTarget ); 

    f = createFont(PFont.list()[2322], 24);
    textFont(f);
    
    prevTime = millis();
    triggerTime = millis();
    
    // sound setup
    // Create triangle wave and start it
    triOsc = new TriOsc(this);

    // Create the envelope 
    env = new Env(this);
}



// the draw function: here we call the update functions of each plot to redraw the data
public void draw() {
  background(0); 
  noStroke();
  int barheightIn = (int) (input*height);
  int barheight1 = (int) (output1*height);
  int barheight2 = (int) (output2*height);
  int barheight3 = (int) (output3*height);
  int barheight4 = (int) (output4/2*height);
  int barheight5 = (int) (output5/2*height);
  
  fill(0, 100, 50);
  rect(width*0.0, barheightIn, width*0.13, height - barheightIn);
  
  fill(10, 100, 50);
  rect(width*0.17, barheight1, width*0.13, height - barheight1);
  fill(20, 100, 50);
  rect(width*0.34, barheight2, width*0.13, height - barheight2);
  fill(30, 100, 50);
  rect(width*0.5, barheight3, width*0.13, height - barheight3);
  
  // the last two are used for difference, so deviate from the middle
  fill(40, 100, 50);
  rect(width*0.67, (0.5*height), width*0.13, barheight4);
  fill(50, 100, 50);
  rect(width*0.83, (0.5*height), width*0.13, barheight5);
  
  stroke(80, 200, 100 );
  line(width*0.0, minimum * height, width*1, minimum*height);
  stroke(80, 200, 100 );
  line(width*0.0, maximum * height, width*1, maximum*height);
  
  textAlign(LEFT);
  drawValue(width * 0, input);
  drawText( 0.01*width, "input" );

  drawValue(width * 0.17, output1);
  drawText( width * 0.18, "scaled" );
  drawValue(width * 0.34, output2);
  drawText( width * 0.35, "exp smooth" );
  drawValue(width * 0.5, output3);
  drawText( width * 0.51, "mean" );
  drawValue(width * 0.67, output4);
  drawText( width * 0.68, "deviation" );
  drawValue(width * 0.83, output5);
  drawText( width * 0.84, "delta" );

  noStroke();
  if ( trigger1 ){
    fill(90,100,100);
    rect(width*0.97, 0, width*0.03, height*0.15);
  }
  if ( upDown == 1 ){
    fill(90,100,100);
    rect(width*0.97, height*0.2, width*0.03, height*0.15);
  } else if ( upDown == -1 ){
    fill(10,100,100);
    rect(width*0.97, height*0.2, width*0.03, height*0.15);
  }
  if ( trigger2 ){
    fill(90,100,100);
    rect(width*0.97, height*0.4, width*0.03, height*0.15);
  }
  if ( trigger3 ){
    fill(90,100,100);
    rect(width*0.97, height*0.6, width*0.03, height*0.15);
  }

  if ( trigger3 ){
    playSound( output1*2 );  
  } 
}

void drawText( float x, String text ){
  fill(100);
  text(text, x, height - 30);  
}

void drawValue(float x, float val) {
  fill(100);
  text(val, x, 30);
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
        
        input = v1;
        
        checkRange( input );
        
        // scaling (needs range)
        output1 = scaleToRange( input );
        
        output2 = updateExponentialSmooth( output1 );
        
        //print( output1, output2 );
        
        if ( !initialized ){
          initializeMean( output1 );
        }
        output3 = updateMean( output1 );
        
        output4 = deviation( input, output3 );
        output5 = updateDelta( input );
        //output = updateSlope( input );
        
        trigger1 = compareLarger( output1, 0.7 );
        upDown = upOrDown( output1, 0.7 );
        trigger2 = upDeadTime( output1, 0.7, 1000 ); // 1000 milliseconds (1 second) of dead time
        trigger3 = triggerAboveReset( output1, 0.7, 0.5 ); // enable retrigger when going below 0.5
        
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
  float out = (val - minimum) / (maximum - minimum );
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
float alpha=0.05;

// exponential smoothing:
float updateExponentialSmooth( float val ){
  prevSmooth = smooth;
  smooth = alpha * val + (1-alpha)*prevSmooth;
  //println( "smooth: " + smooth + "alpha: " + alpha + "val: " + val ); 
  return smooth;
}

///--------- Mean value ---------

// variables for mean
int windowSize = 10;
float inputValues[];
float sum = 0;
int inputIndex=0;

// calculating mean value:
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
  return slope;
}

///------------- Deviation of smoothed signal ----------

float deviation( float val, float smooth ){
    return ( smooth - val );
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
      // was it smaller before?
      if ( prevValUD > threshold ){
        prevValUD = val;
        return -1; // going down  
      }
  }
  prevValUD = val;
  return 0; // was already above or below threshold
}

/// ---- trigger with dead time -----

float prevValUDDT=0;

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

boolean canTrigger=true;

boolean triggerAboveReset( float val, float triggerThreshold, float resetThreshold ){
  int now = millis();
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
  int now = millis();
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


/// scale to frequency
float scaleToFrequency( float in ){
  return (pow(2, in) * 220);
}


/// sound
void playSound( float input ){
    // midiToFreq transforms the MIDI value into a frequency in Hz which we use to
    // control the triangle oscillator with an amplitute of 0.5
    triOsc.play(scaleToFrequency( input ), 0.5);

    // The envelope gets triggered with the oscillator as input and the times and
    // levels we defined earlier
    env.play(triOsc, attackTime, sustainTime, sustainLevel, releaseTime);
} 

// This helper function calculates the respective frequency of a MIDI note
float midiToFreq(int note) {
  return (pow(2, ((note-69)/12.0))) * 440;
}
