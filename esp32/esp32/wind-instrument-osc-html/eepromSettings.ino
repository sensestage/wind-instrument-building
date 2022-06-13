
////////////////////////////////////////////////////
// Eeprom functions to store configuration presets
//
////////////////////////////////////////////////////


//////////////////////////////////////////////////
/// Configuration Settings loaded from EEPROM
void confSettings(){
  Serial.println();
  Serial.println("* Reading EEPROM:");
  
  String d;
  int address;

  // the first byte is a flag (0 or 1) informing about wifi modes
  address = 0;
  d = read_String(address);
  Serial.print("- AccesPoint flag (0= AP, 1=STA):");
  Serial.println(d);
  if(d.toInt()==0){
    accesspoint = true;
  } else {
    accesspoint = false;
  }
  
  address = 2; //we know the flag is always 2 bytes long
  d = read_String(2);
  //Serial.print("- SSID Length:");
  //Serial.println(d);
  
  d = read_String(20);  //reading ssid, address (20) is arbitrary, the following are too. 
  Serial.print("- SSID:");
  Serial.println(d);
  network = d; 
  
  d = read_String(86);
  Serial.print("- Password:");
  Serial.println(d);
  password = d;
  /*
  d = read_String(130);
  Serial.print("- host ip:");
  Serial.println(d);
  if(!accesspoint ) udpAddress = string2IP(d);
  

  d = read_String(170);
  Serial.print("- ip at new network:");
  Serial.println(d);
  if(!accesspoint ) staIP = string2IP(d);
  */
  
  d = read_String(200);
  Serial.print("- OSC port:");
  Serial.println(d);
  if(!accesspoint ) udpPort = d.toInt();  //cause it can be empty at the beginning
  
  /*
  d = read_String(216);
  Serial.print("- Gateway ip:");
  Serial.println(d);
  if(!accesspoint ) staGateway = string2IP(d);
  */
  
}

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
