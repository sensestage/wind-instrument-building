/////////////////////////////////////////////////////////////////////////
/// ESP32 Tangible Core  . OSC Client Generic Solution                 //
///                                                                    //
/// This sends OSC data to a host                                      //
/// configured as access point or connected to a wifi network          //
//                                                                     //
//  It uses pin 15 (LOW) to hardreset the board in access point mode   //
//  so you need to connect pin 15 to HIGH to make it work.             //
/// enrique.tomas@ufg.at may 2019                                      //
/////////////////////////////////////////////////////////////////////////


#include "EEPROM.h"
#include <Arduino.h>


///////////////////////
//global variables
///////////////////////

//int LED_BUILTIN = 2;    //LED BUILT_IN pin in DOIT DEV KIT is 2

// Name of your default access point.
const char *APssid = "kike-AP";




bool shouldReboot = false;     //flag to use from web update to reboot the ESP



//EEPROM global vars
#define EEPROM_SIZE 256
int addr = 0; // the current address in the EEPROM (i.e. which byte we're going to write to next)





//////////////////////
// setup
//////////////////////
void setup(){

  delay(10000);
  // Initialize hardware serial:
  Serial.begin(115200);
  Serial.println();
  Serial.println("/////////////////////////////");
  Serial.println("Generic ESP30 EEPROM CLEANER solution");
  Serial.println("Tangible Music Lab 2019 (enrique.tomas@ufg.at)");
  Serial.println("/////////////////////////////");
    
  //pinMode(LED_BUILTIN, OUTPUT);
  pinMode(15, INPUT);             //hardreset pin
  
  ///eeprom init
  EEPROM.begin(EEPROM_SIZE);
  
  // First check hardreset pin
  // A hardreset pin at pin 15 will save us when a network configuration fails!!
  // It resets the board to access point, stores this mode in the eeprom and restarts
  bool j = true;

    //digitalWrite(LED_BUILTIN, LOW);
    Serial.println();
    Serial.println("RESET pin 15 is low!!");
    
    resetBoard();   // reset board, fix Access Point mode and save to EEPROM

    Serial.println("Rebooting in 2 secs...");
    delay(2000);
    //digitalWrite(LED_BUILTIN, HIGH);
    delay(10000);
    ESP.restart();
    
  
}



void loop(){


}


////////////////////////////////////////////////////
// Eeprom functions to store configuration presets
//
////////////////////////////////////////////////////



///////////////////////////////////////////////////////
/// reset board to Access Point mode and clear eeprom
////
void resetBoard(){
  Serial.println();
  Serial.println("I will reset this ESP32");
  
  //LOAD INFORMATION IN EEPROM
  Serial.println();
  Serial.println("writing original data in eeprom memory");
  
    //clear eeprom
    for (int i = 0 ; i < EEPROM_SIZE ; i++) {
      EEPROM.write(i, 0);
    }
  
    int address = 0;
    writeStringMem(0, "0");                   //flag for setting access point OR NOT (0=AP, 1=STA)

    Serial.println("ESP32 should be in AP mode, rebooting...");
    delay(300);
    //shouldReboot = true;
  
}

// eeprom basic read/write functions
void writeStringMem(char add,String data){
  int _size = data.length();
  int i;
  for(i=0;i<_size;i++)
  {
    EEPROM.write(add+i,data[i]);
  }
  EEPROM.write(add+_size,'\0');   //Add termination null character for String Data
  EEPROM.commit();
}
 

// eeprom functions
String read_String(char add){
  int i;
  char data[100]; //Max 100 Bytes
  int len=0;
  unsigned char k;
  k=EEPROM.read(add);
  while(k != '\0' && len<500)   //Read until null character
  {    
    k=EEPROM.read(add+len);
    data[len]=k;
    len++;
  }
  data[len]='\0';
  return String(data);
}
