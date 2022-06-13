////////////////////////////////////////////////////
// Basic HTML server definition and its functions
//
////////////////////////////////////////////////////


//////////////////////////////////////////
// webserver methods
//////////////////////////////////////////
void handleRoot()                             //receives actions from the webserver and decides what to do
{
  //Browse information received
  for(int i=0; i<server.args(); i++) {
    Serial.println(server.arg(i));
  }
  if (server.hasArg("mode_ap") && server.args()==1) {     //when it is STA mode and we want to change to access point
      handle_APchange();
  } 
  else{
    if (server.hasArg("ssid_name") && server.args()==3) { //when it is access point and we want to change to STA
      handleSsid();
    }
    else {
      server.send(200, "text/html", SendHTML(true,true)); //refresh the website or the browser will show an empty page
    }
 }
   
}


//funtion for changing from STA to access point mode in the HMTL server
void handle_APchange() {

  Serial.println();
  Serial.println("Configuring as Access Point");
  
  //send a response
  server.send(200, "text/html", SendHTML(true,true)); 
  
  //LOAD INFORMATION IN EEPROM
  Serial.println();
  Serial.println("writing data in eeprom memory");

  Serial.print("Writing Data:");
    //writing strings at memory. First arg sets a byte address, second the data to store
  
    //clear eeprom first
    for (int i = 0 ; i < EEPROM_SIZE ; i++) {
      EEPROM.write(i, 0);
    }

    //then set flag to Access Point, the rest was cleared
    int address = 0;
    writeStringMem(0, "0");                   //flag for setting access point OR NOT (0=AP, 1=STA)

    delay(3000);
    shouldReboot = true;
}


//function for changing from Access Point mode to STA mode  with the HTML Server
void handleSsid()
{
  //some aux strings to store information typed by user at the webserver
  String new_ssid;
  String new_passw;
  String new_fixed_ip;
  String new_host_ip;
  String new_host_port;
  String new_gateway_ip;

  //check data and load wifi data
  if (!server.hasArg("ssid_name")) return returnFail("BAD ARGS");
  new_ssid = server.arg("ssid_name");
  Serial.println("New SSID to connect: " + new_ssid);

  if (!server.hasArg("password_name")) return returnFail("BAD ARGS");
  new_passw = server.arg("password_name");
  Serial.println("New passw to connect " + new_passw);
  /*
  if (!server.hasArg("fixed_IP")) return returnFail("BAD ARGS");
  new_fixed_ip = server.arg("fixed_IP");
  Serial.println("IP at new network  " + new_fixed_ip);
  
  if (!server.hasArg("host_IP")) return returnFail("BAD ARGS");
  new_host_ip = server.arg("host_IP");
  Serial.println("IP of host at new network  " + new_host_ip);

  if (!server.hasArg("gateway_IP")) return returnFail("BAD ARGS");
  new_gateway_ip = server.arg("gateway_IP");
  Serial.println("Gateway IP  " + new_gateway_ip);
  */
  if (!server.hasArg("host_Port")) return returnFail("BAD ARGS");
  new_host_port = server.arg("host_Port");
  Serial.println("OSC port to change  " + new_host_port);

  //send a response
  server.send(200, "text/html", SendHTML(true,true)); 

  //LOAD INFORMATION IN EEPROM
  Serial.println();
  Serial.println("writing data in eeprom memory");

  String data = new_ssid;


  //writing strings in flash memory. First arg sets a byte address, second the data to store
    Serial.print("Writing Data:");
    Serial.println(data);
    
  
    //clear eeprom first
    for (int i = 0 ; i < EEPROM_SIZE ; i++) {
      EEPROM.write(i, 0);
    }
  
    int address = 0;
    writeStringMem(0, "1");                   //flag for setting access point OR NOT (0=AP, 1=STA)
  
    address = 2; // as the flag "1" is two bytes long
    writeStringMem(2, String(new_ssid.length()));           //SSID string length
  
    address = 20;       //20 is arbitrary, to leave some space for other flags
    writeStringMem(address, new_ssid);                    
  
    address = 86;       //SSIDs can be 32 character long (65 bytes)
    writeStringMem(address, new_passw);                    
    /*
    address = 130;       //passw max is 20 char long (41 bytes)
    writeStringMem(address, new_host_ip);                 //IP is 16 bythes long
  
    address = 170;       //an IP is max 15 char long (31 bytes)
    writeStringMem(address, new_fixed_ip);                 
    */
    address = 200;       //an IP is max 15 char long (31 bytes)
    writeStringMem(address, new_host_port);
    /*
    address = 216;       //an IP is max 15 char long (31 bytes)
    writeStringMem(address, new_gateway_ip); 
    */
  
  //We should reboot the esp32 now
  Serial.println();
  Serial.println("data written in eeprom memory");
  delay(3000);
  shouldReboot = true;
}


// other necessary handling functions
void returnFail(String msg){
  server.sendHeader("Connection", "close");
  server.sendHeader("Access-Control-Allow-Origin", "*");
  server.send(500, "text/plain", msg + "\r\n");
}

void returnOK(){
  server.sendHeader("Connection", "close");
  server.sendHeader("Access-Control-Allow-Origin", "*");
  server.send(200, "text/plain", "OK\r\n");
}
  
void handleNotFound(){
  String message = "File Not Found\n\n";
  message += "URI: ";
  message += server.uri();
  message += "\nMethod: ";
  message += (server.method() == HTTP_GET)?"GET":"POST";
  message += "\nArguments: ";
  message += server.args();
  message += "\n";
  for (uint8_t i=0; i<server.args(); i++){
    message += " " + server.argName(i) + ": " + server.arg(i) + "\n";
  }
  server.send(404, "text/plain", message);
}



////////////////////////////////////////////////////////
//// Webserver HTML code
// 
// This is a long string we can dynamically change
///////////////////////////////////////////////////////




String SendHTML(uint8_t led1stat,uint8_t led2stat){
  String ptr = "<!DOCTYPE HTML>";
ptr +="<html>";
ptr +="<head>";
ptr +="<meta name = \"viewport\" content = \"width = device-width, initial-scale = 1.0, maximum-scale = 1.0, user-scalable=0\">";
ptr +="<title>ESP32 - Tangible Core</title>";
ptr +="<style>";
ptr +="\"body { background-color: #808080; font-family: Arial, Helvetica, Sans-Serif; Color: #000000; }\"";
ptr +="</style>";
ptr +="</head>";
ptr +="<body>";
ptr +="<h1>ESP32 - Tangible Core</h1>";
ptr +="<FORM action=\"/\" method=\"post\">";
ptr +="<P>";

if(accesspoint){                              //html code when access point. it allows connecting to a network using a form
  ptr +="<P>";
  ptr +="ESP32 Configured as Access Point";
  ptr +="<P>";
  ptr +="OSC Port: ";
  ptr +=String(udpPort);
  ptr +="<P>";
  ptr +="Number of connected Devices: ";
  ptr +=String(numClients);
  ptr +="<P>";
  if (numClients > 0) {
    ptr +="<P>";
    ptr +="Clients IPs: ";
  
    for(int i = 0; i < numClients; i++) {
      ptr +=" ";
      ptr +=clientsAddress[i].toString();;
    }  
  }
  ptr +="<br>";
  // now create a few input fields for entering information about the network to connect
  ptr +="</P>";
  ptr +="To change Access Point mode and connect to a Wifi: <br>";
  ptr +="</P>";
  ptr +="Wifi name<br>";
  ptr +="<INPUT type=\"text\" name=\"ssid_name\"<BR>";
  
  ptr +="</P>";
  ptr +="Password<br>";
  ptr +="<INPUT type=\"text\" name=\"password_name\"<BR>";
  /*
  ptr +="</P>";
  ptr +="IP of the computer you will send OSC<br>";
  ptr +="<INPUT type=\"text\" name=\"host_IP\"<BR>";
  
  ptr +="</P>";
  ptr +="Your IP number in the new Wifi Network<br>";
  ptr +="<INPUT type=\"text\" name=\"fixed_IP\"<BR>";

  ptr +="</P>";
  ptr +="Gateway IP <br>";
  ptr +="<INPUT type=\"text\" name=\"gateway_IP\"<BR>";
  */
  ptr +="</P>";
  ptr +="OSC Port<br>";
  ptr +="<INPUT type=\"text\" name=\"host_Port\"<BR>";
  
  ptr +="</P>";
  ptr +="Activate Wifi Now clicking on Send<br>";
  
  ptr +="<INPUT type=\"submit\" value=\"Send\">";  //the button to submit information
  ptr +="</P>";


  
} 
/*
else{                             //html code when STA mode. it only allows setting as access point
  ptr +="<P>";
  ptr +="ESP32 Connected to WIFI: " + String(network);
  ptr +="<P>";
  ptr +="my IP is: ";
  ptr += IpAddress2String(WiFi.localIP());
  ptr +="<P>";
  ptr +="OSC Port: ";
  ptr +=String(udpPort);
  ptr +="<P>";
  if(hostSelected){
    ptr +="Transmitting to device: ";
    ptr += hostSelectedName;
    ptr +="<P>";
  } else{
    ptr +="No device selected to transmit";
    ptr +="<P>";
  }
  ptr +="Available devices to transmit OSC: ";
  ptr +="<P>";
  for (int i = 0; i < nServices; ++i) {
      // Print details for each service found
      ptr +=MDNS.hostname(i) + " (" +  IpAddress2String(MDNS.IP(i)) +") ";
      ptr +=" ";
      ptr +="<INPUT type=\"checkbox\"";
      ptr += " name=\"host" + String(i) + "\"<BR>host to transmit<br>";
      ptr +="</P>";
      
      
      
//      Serial.print("  ");
//      Serial.print(": ");
//      Serial.print(MDNS.hostname(i));
//      Serial.print(" (");
//      Serial.print(MDNS.IP(i));
//      Serial.print(":");
//      Serial.print(MDNS.port(i));
//      Serial.println(")");
      
  }

  ptr +="Transmit OSC to: ";
  
  //ptr +="Sending OSC to IP: ";
  //ptr +=IpAddress2String(udpAddress);
  ptr +="<P>";
  ptr +="<br>";
  
  ptr +="Configuration:";
  ptr +="</P>";
  ptr +="Configure ESP32 board as Access Point: ";
  ptr +="</P>";
  ptr +="<INPUT type=\"checkbox\" name=\"mode_ap\"<BR>Activate Access Point<br>";
  ptr +="</P>";
  
  ptr +="<INPUT type=\"submit\" value=\"Send\">";   //a button to reset to acccess point
  ptr +="</P>";
  ptr +="</P>";
  ptr +="</P>";
}
*/

ptr +="</FORM>";
ptr +="</body>";
ptr +="</html>";
ptr +=style;
return ptr;
}


/* Style */
String style =
"<style>#file-input,input{width:100%;height:44px;border-radius:4px;margin:10px auto;font-size:15px}"
"input{background:#f1f1f1;border:0;padding:0 15px}body{background:#3498db;font-family:sans-serif;font-size:14px;color:#777}"
"#file-input{padding:0;border:1px solid #ddd;line-height:44px;text-align:left;display:block;cursor:pointer}"
"#bar,#prgbar{background-color:#f1f1f1;border-radius:10px}#bar{background-color:#3498db;width:0%;height:10px}"
"form{background:#fff;max-width:358px;margin:75px auto;padding:30px;border-radius:5px;text-align:center}"
".btn{background:#3498db;color:#fff;cursor:pointer}</style>";


/* Login page */
String loginIndex = 
"<form name=loginForm>"
"<h1>ESP32 Login</h1>"
"<input name=userid placeholder='User ID'> "
"<input name=pwd placeholder=Password type=Password> "
"<input type=submit onclick=check(this.form) class=btn value=Login></form>"
"<script>"
"function check(form) {"
"if(form.userid.value=='admin' && form.pwd.value=='admin')"
"{window.open('/serverIndex')}"
"else"
"{alert('Error Password or Username')}"
"}"
"</script>" + style;

 

/* Server Index Page */
 String updateform = 
"<script src='https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js'></script>"
"<form method='POST' action='#' enctype='multipart/form-data' id='upload_form'>"
"<input type='file' name='update' id='file' onchange='sub(this)' style=display:none>"
"<label id='file-input' for='file'>   Choose file...</label>"
"<input type='submit' class=btn value='Update'>"
"<br><br>"
"<div id='prg'></div>"
"<br><div id='prgbar'><div id='bar'></div></div><br></form>"
"<script>"
"function sub(obj){"
"var fileName = obj.value.split('\\\\');"
"document.getElementById('file-input').innerHTML = '   '+ fileName[fileName.length-1];"
"};"
"$('form').submit(function(e){"
"e.preventDefault();"
"var form = $('#upload_form')[0];"
"var data = new FormData(form);"
"$.ajax({"
"url: '/update',"
"type: 'POST',"
"data: data,"
"contentType: false,"
"processData:false,"
"xhr: function() {"
"var xhr = new window.XMLHttpRequest();"
"xhr.upload.addEventListener('progress', function(evt) {"
"if (evt.lengthComputable) {"
"var per = evt.loaded / evt.total;"
"$('#prg').html('progress: ' + Math.round(per*100) + '%');"
"$('#bar').css('width',Math.round(per*100) + '%');"
"}"
"}, false);"
"return xhr;"
"},"
"success:function(d, s) {"
"console.log('success!') "
"},"
"error: function (a, b, c) {"
"}"
"});"
"});"
"</script>" + style;
