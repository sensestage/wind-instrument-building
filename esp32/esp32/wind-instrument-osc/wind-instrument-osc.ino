#include <WiFi.h>
#include <WiFiUdp.h>
#include <OSCMessage.h>
#include <WiFiAP.h>

#include <Adafruit_NeoPixel.h>  // go to Main Menu --> Sketch --> Include Library --> Manage libraries... search for Adafruit NeoPixel and install it (as of 4th February 2021 latest version is 1.7.0)
#define PIN 18
#define NUMPIXELS 1
#define PERIOD  10  //ms

Adafruit_NeoPixel pixels(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);


#include <TinyMPU6050.h>

/*
 *  Constructing MPU-6050
 */
MPU6050 mpu (Wire);


//IP address to send UDP data to:
// either use the ip address of the server or 
// a network broadcast address
IPAddress udpAddress(192, 168, 0, 2);  //just a dummy, it can be configured via browser
int udpPort = 57120;                   //just a dummy, it can be configured via browser

// Your name for access point.
const char *APssid = "Wind-Instrument";


//The udp library class
WiFiUDP udp;

boolean connected = false;     //wifi connection
bool accesspoint = true;       //acccess point mode
boolean APconnected = false;   //access point connected
bool registered = false;       //wifi handler registration


// Set your Static IP address (dummy values initialization)
IPAddress staIP(192,168,0,129);         //Board static IP
IPAddress staGateway(192,168,0,1);      //Gateway IP
IPAddress staSubnet(255,255,255,0);     //Subnet range
IPAddress primaryDNS(192, 168, 0, 1);   //optional
IPAddress secondaryDNS(8, 8, 4, 4);     //optional


void setup(){
  // Initilize hardware serial:
  Serial.begin(115200);

  //set the resolution to 13 bits (0-8192)
  analogReadResolution(13);

  pixels.begin();
  pixels.setPixelColor(0, pixels.Color(0, 0, 255));
  pixels.show();

  // MPU sensor
  Wire.setPins( 4, 3 );
  // Initialization
  mpu.Initialize();
  // Calibration
  Serial.println("=====================================");
  Serial.println("Starting calibration MPU 6050...");
  mpu.Calibrate();
  Serial.println("Calibration MPU6050 complete!");

  Serial.println("=====================================");
  Serial.println("Configuring access point...");

  //register event handler
  if(!registered){
    registered = true;
    WiFi.onEvent(WiFiEvent);
  }




 //Create Access Point
    WiFi.mode(WIFI_AP);
    WiFi.softAP(APssid);
    Serial.println("Wait 100 ms for AP_START...");
    delay(100);

    Serial.println("Set softAPConfig");
    IPAddress Ip(192, 168, 0, 1);       //We fix an IP easy to recover without serial monitor
    IPAddress NMask(255, 255, 255, 0);
    WiFi.softAPConfig(Ip, Ip, NMask);
  
    IPAddress myIP1 = WiFi.softAPIP();
    Serial.print("Access Point Created!!");
    Serial.print("IP address: ");
    Serial.println(myIP1);
    APconnected = true;
    connected = true;
}

void loop(){
  //only send data when connected
  if(connected){
    pixels.setPixelColor(0, pixels.Color(0, 127, 0)); // green
    pixels.show();
    
    // read out MPU
    mpu.Execute();
    // read the analog values:
    int analogValue0 = analogRead(A0);
    int analogValue1 = analogRead(A1);
    int analogValue2 = 0;
    int analogValue3 = 0;
//    int analogValue2 = analogRead(A2);
//    int analogValue3 = analogRead(A3);
  
    // print out the values you read:
//    Serial.printf("ADC analog value0 = %d\n",analogValue0);
//    Serial.printf("ADC analog value1 = %d\n",analogValue1);
//    Serial.printf("ADC analog value2 = %d\n",analogValue2);
//    Serial.printf("ADC analog value3 = %d\n",analogValue3);


  // send OSC messages
    pixels.setPixelColor(0, pixels.Color(0, 0, 127)); // yellow
    pixels.show();
    
//    sendOSCMsgOneFloat( "/analog/0", (float) analogValue0 );
//    sendOSCMsgOneFloat( "/analog/1", (float) analogValue1 );
//    sendOSCMsg( "/analog/2", (float) analogValue2 );
//    sendOSCMsg( "/analog/3", (float) analogValue3 );
    sendOSCMsgFourFloats( "/analog", (float) analogValue0/8192, (float) analogValue1/8192, (float) analogValue2/8192, (float) analogValue3/8192 );


    float accx = mpu.GetAccX();
    float accy = mpu.GetAccY();
    float accz = mpu.GetAccZ();
    sendOSCMsgThreeFloats( "/accelero", accx, accy, accz );
    float gyrox = mpu.GetGyroX();
    float gyroy = mpu.GetGyroY();
    float gyroz = mpu.GetGyroZ();
    sendOSCMsgThreeFloats( "/gyro", gyrox, gyroy, gyroz );
    float anglex = mpu.GetAngX();
    float angley = mpu.GetAngY();
    float anglez = mpu.GetAngZ();
    sendOSCMsgThreeFloats( "/angles", anglex, angley, anglez );

    pixels.setPixelColor(0, pixels.Color(0, 127, 0)); // green
    pixels.show();

  } else {
    pixels.setPixelColor(0, pixels.Color(127, 0, 0)); // red
    pixels.show();
  }
  //Wait for 25ms
  delay(25);
}

void sendOSCMsgOneFloat( const char * name, float value ){
  OSCMessage msg(name);
  msg.add(value);
  udp.beginPacket(udpAddress, udpPort);
  msg.send(udp);
  udp.endPacket();
  msg.empty();
}

void sendOSCMsgThreeFloats( const char * name, float val1, float val2, float val3 ){
  OSCMessage msg(name);
  msg.add(val1);
  msg.add(val2);
  msg.add(val3);
  udp.beginPacket(udpAddress, udpPort);
  msg.send(udp);
  udp.endPacket();
  msg.empty();
}

void sendOSCMsgFourFloats( const char * name, float val1, float val2, float val3, float val4 ){
  OSCMessage msg(name);
  msg.add(val1);
  msg.add(val2);
  msg.add(val3);
  msg.add(val4);
  udp.beginPacket(udpAddress, udpPort);
  msg.send(udp);
  udp.endPacket();
  msg.empty();
}

//wifi event handler
void WiFiEvent(WiFiEvent_t event){
    switch(event) {
      case SYSTEM_EVENT_STA_GOT_IP:
          //When connected set 
          Serial.print("WiFi connected! IP address: ");
          Serial.println(WiFi.localIP());  
          //initializes the UDP state
          //This initializes the transfer buffer
          udp.begin(WiFi.localIP(),udpPort);
          connected = true;
          
          break;
      case SYSTEM_EVENT_STA_DISCONNECTED:
          Serial.println("WiFi lost connection");
          connected = false;
          break;
    }
}
