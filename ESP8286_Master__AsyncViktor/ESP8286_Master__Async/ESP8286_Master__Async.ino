#include <SD.h>
#include <ESP8266WiFi.h>
#include <SPI.h>
#include <WebSocketsServer.h>
#include <ArduinoJson.h>
#include <ESPAsyncWebServer.h>
#include <FS.h>
#include <Wire.h>
#include <SoftwareSerial.h>
#include <Nextion.h>
#include "webpage.h"
#include "map.h"
#include "states.h"
#include "drive.h"
#include "more.h"


String line;
String dist;


SDFile Sensorfile;


int itest = 0;
//Display
//Deklaration der im Display verwendeten Buttons
NexButton b1 = NexButton(5, 6, "b1");  
NexButton m1 = NexButton(6, 6, "m1"); 
NexButton touchDodge = NexButton(7, 6, "m1"); 
NexButton touchBug = NexButton(8, 6, "m1");  
NexButton touchMoth = NexButton(9, 6, "m1");  
NexButton touchLine = NexButton(10, 6, "m1"); 
NexButton touchFollow = NexButton(11, 6, "m1");  
NexButton touchMapping = NexButton(12, 6, "m1"); 
NexButton touchStop = NexButton(3, 12, "m9");  

//Display
//Füge die Buttons zum listener hinzu
NexTouch *nex_listen_list[] = 
{
  &b1,  
  &m1,  
  &touchDodge,  
  &touchBug,  
  &touchMoth, 
  &touchLine,  
  &touchFollow, 
  &touchMapping,  
  &touchStop,  
  NULL  // String terminated
};  // End of touch event list

//Display
//Aktion beim klick des Buttons
void b1PushCallback(void *ptr)  
{itest=14;i2c_exchange_data();}  
void m1PushCallback(void *ptr) 
{itest=15;i2c_exchange_data();}  
void touchDodgePushCallback(void *ptr) 
{itest=16;i2c_exchange_data();}  
void touchBugPushCallback(void *ptr) 
{itest=17;i2c_exchange_data();}  
void touchMothPushCallback(void *ptr) 
{itest=18;i2c_exchange_data();}  
void touchLinePushCallback(void *ptr) 
{itest=19;i2c_exchange_data();}  
void touchFollowPushCallback(void *ptr) 
{itest=20;i2c_exchange_data();}  
void touchMappingPushCallback(void *ptr)  
{itest=21;i2c_exchange_data();}  
void touchStopPushCallback(void *ptr)  
{itest=21;i2c_exchange_data();}  








/*-------------------SD Defs-----------------------------------------*/
String    error;
uint8_t   sd=1;
uint8_t   sdtype;
int       formattype;
uint32_t  sdsize;
uint8_t   logfile;
uint32_t  logfilesize;

Sd2Card card;
SdVolume volume;
String timestamp;



/*----------------- Webobjekte------------------------------------- */
AsyncWebServer server(80);
WebSocketsServer webSocket = WebSocketsServer(81);
/*------------------ WLAN Defs------------------------------------- */
const char* ssid = "ssid";
const char* password = "password";
// 7-bit I2C slave adress
#define TWI_SLAVE_ADDR 0x50

//Die Größe des Buffers, sowie die struct müssen zum atmega identisch sein
// TX_BUFFER, RX_BUFFER
#define BUFFER_SIZE 18


unsigned char i = 0;
unsigned char i2c_result = 0;
bool con = false;

// Force the compiler to use one byte alignment for structures
// otherwise you have to manually add padding bytes in Codevision AVR
#pragma pack(push, 1)  // exact fit - no padding

// struct declaration
struct TData
{
  uint8_t linesensorvalue;
  uint8_t distanzsensorvalue;
  int16_t lichtlinks;
  int16_t lichtrechts;
  int16_t motorvalueleft;
  int16_t motorvalueright;
  int16_t wiicam1;
  int16_t wiicam2;
  uint8_t infarot;
  uint8_t servo;
  uint8_t ultraschall;
  uint8_t iValue;
};

#pragma pack(pop)   //back to whatever the previous packing mode was

// union declaration
union TBuffer
{
  uint8_t bytes[BUFFER_SIZE];
  struct TData data;
};

union TBuffer tx_buffer;  // master transmission buffer
union TBuffer rx_buffer;  // master receive buffer

// Returns
// byte, which indicates the status of the transmission:
// 9: number of received bytes is not correct

unsigned char i2c_master_trans(unsigned char slave_addr,
                               unsigned char *tx_data,
                               unsigned char tx_count,
                               unsigned char *rx_data,
                               unsigned char rx_count)
{
  unsigned char i = 0;
  unsigned char i2c_error = 0;

  // Tansmit tx_buffer
  Wire.beginTransmission(slave_addr);
  Wire.write(tx_data, tx_count);
  i2c_error = Wire.endTransmission();
  if (i2c_error != 0) return i2c_error;
  // Receive rx_buffer
  if (Wire.requestFrom(slave_addr, rx_count) != rx_count)
  {
    i2c_error = 9;
    return i2c_error;
  }
  while (Wire.available())
  {
    rx_data[i] = Wire.read();
    i++;
  }
  return 0;
}







//Datenaustausch zwischen ESP und ATMEGA
void i2c_exchange_data(void)
{
  // Daten, die gesendet werden
  tx_buffer.data.iValue = itest;         
  char timestampBuffer[50];
  // transmit data from tx_buffer to the slave and receive response in rx_buffer
  i2c_result = i2c_master_trans(TWI_SLAVE_ADDR, tx_buffer.bytes, BUFFER_SIZE, rx_buffer.bytes, BUFFER_SIZE);
  if (i2c_result == 0)
  {

    // I2C transaction was performed without errors
    //Eintragung in log Datei auf der SD-Karte
    timestamp.toCharArray(timestampBuffer, 60); 
    Sensorfile = SD.open("datalog.txt", FILE_WRITE);
    // if the file is available, write to it:
    if (Sensorfile) {
    Sensorfile.printf("------------------------------------------\n");
    Sensorfile.printf(timestampBuffer);
    Sensorfile.printf("\n");
    Sensorfile.printf("I2C transaction result: %i\r\n", i2c_result);
    Sensorfile.printf("Transmitted to MEGA128: %2i\r\n", tx_buffer.data.iValue);
    Sensorfile.printf("Received from MEGA128: %4i %4i %4i %4i %4i %4i %4i %4i\r\n", rx_buffer.data.linesensorvalue, rx_buffer.data.distanzsensorvalue, 
    rx_buffer.data.lichtlinks, rx_buffer.data.lichtrechts, rx_buffer.data.motorvalueleft, rx_buffer.data.motorvalueright, rx_buffer.data.wiicam1, rx_buffer.data.wiicam2, rx_buffer.data.iValue);
    Sensorfile.printf("Content of Receive Buffer: ");
     for (int i = 0; i < BUFFER_SIZE; i++)
    Sensorfile.printf("%2X ", rx_buffer.bytes[i]);
    Sensorfile.printf("\r\n\n");
    Sensorfile.close();
  }}
  else
  {
    timestamp.toCharArray(timestampBuffer, 60);
    Sensorfile = SD.open("datalog.txt", FILE_WRITE);
    //Eintragung in log Datei auf der SD-Karte
    // if the file is available, write to it:
    if (Sensorfile) {
    Sensorfile.printf("-----------------ERROR-----------------\n");
    Sensorfile.printf(timestampBuffer);
    Sensorfile.printf("\n");
    Sensorfile.printf("I2C transaction error: %i\r\n", i2c_result);
    Sensorfile.printf("Transmitted to MEGA128: %2i\r\n", tx_buffer.data.iValue);
    Sensorfile.printf("Received from MEGA128: %4i %4i %4i %4i %4i %4i %4i %4i\r\n", rx_buffer.data.linesensorvalue, rx_buffer.data.distanzsensorvalue, 
    rx_buffer.data.lichtlinks, rx_buffer.data.lichtrechts, rx_buffer.data.motorvalueleft, rx_buffer.data.motorvalueright, rx_buffer.data.wiicam1, rx_buffer.data.wiicam2, rx_buffer.data.iValue);
    Sensorfile.printf("Content of Receive Buffer: ");
     for (int i = 0; i < BUFFER_SIZE; i++)
    Sensorfile.printf("%2X ", rx_buffer.bytes[i]);
    Sensorfile.printf("\r\n\n");
    Sensorfile.close();
  }}
  

  
}

//---------------Prototypes for webevent handling-------------------
void webSocketEvent(uint8_t , WStype_t, uint8_t * , size_t );
void sendJasonString();



void setup() {
  // I2C initialization
  Wire.setClock(400000);
  Wire.begin();

  // Serial initialization
    //Das Display kommunitiert mit dem ESP über das UART Interface
  Serial.begin(9600);

  //Display
  //Was soll passieren wenn die Bediengung wahr ist?
  //Funktionsaufruf
  b1.attachPush(b1PushCallback);  
  m1.attachPush(m1PushCallback);  
  touchDodge.attachPush(touchDodgePushCallback);  
  touchBug.attachPush(touchBugPushCallback);  
  touchMoth.attachPush(touchMothPushCallback); 
  touchLine.attachPush(touchLinePushCallback);
  touchLine.attachPush(touchLinePushCallback); 
  touchFollow.attachPush(touchFollowPushCallback);  
  touchMapping.attachPush(touchMappingPushCallback);  
  touchStop.attachPush(touchStopPushCallback);  
  

  delay(200);

//Initiealisierung der SD-Karte
  if (!SD.begin(14)) {
      sd=0;
      return;
  }
    
  // Typbestimmung
  switch (card.type()) {
    case SD_CARD_TYPE_SD1:
      sdtype=1;
      break;
    case SD_CARD_TYPE_SD2:
      sdtype=2;
      break;
    case SD_CARD_TYPE_SDHC:
      sdtype=3;
      break;
    default:
      sdtype=0;
  }
  if (!volume.init(card)) {
    return;
  }
      //Größenbestimmung
  uint32_t volumesize;

  formattype = volume.fatType();

  volumesize = volume.blocksPerCluster();    // clusters are collections of blocks
  volumesize *= volume.clusterCount();       // we'll have a lot of clusters
  volumesize *= 512;                            // SD card blocks are always 512 bytes
  volumesize /= 1048576;
  sdsize=volumesize;



  
  // WiFi SoftAP initialization

  // IP initialization
  IPAddress local_IP(192, 168, 2, 100);
  IPAddress gateway(192, 168, 2, 1);
  IPAddress subnet(255, 255, 255, 0);
  const char *password = "0123456789abc";

   //SSID, PASSWORD, CHANNEL, HIDDEN
  WiFi.softAP("BlueMatics-Robby", password, 0, 1);
  WiFi.softAPConfig(local_IP, gateway, subnet);
  

    if (!SPIFFS.begin())
    {
    // Serious problem
    
    //Serial.println("SPIFFS Mount failed");
    
    } else {
      
    //Serial.println("SPIFFS Mount succesfull");
    
    }
  

  // startet den WebSocket
  webSocket.begin();
  webSocket.onEvent(webSocketEvent);
  
  
  // WebServer
  // Was soll aufgerufen werden, wenn folgendes in der Adresszeile übergeben wird
  server.on("/", HTTP_GET, [](AsyncWebServerRequest *request) {
    request->send_P(200, "text/html", html);
  });
  server.on("/map", HTTP_GET, [](AsyncWebServerRequest *request) {
    request->send_P(200, "text/html", handleMAP);
  });
  server.on("/states", HTTP_GET, [](AsyncWebServerRequest *request) {
    request->send_P(200, "text/html", handleSTATES);
  });
    server.on("/more", HTTP_GET, [](AsyncWebServerRequest *request) {
    request->send_P(200, "text/html", handleMore);
  });
    server.on("/drive", HTTP_GET, [](AsyncWebServerRequest *request) {
    request->send_P(200, "text/html", handleDrive);
  });

  //startet den HTTP Server
  server.begin();
  

}



void loop() {

  unsigned long currentMillis = millis();
  webSocket.loop();  
      //Alle 1,2 Sekunden einen Datenaustausch durchführen
  if (currentMillis % 1200 == 0) {
      i2c_exchange_data();  //get data from atmega
      sendDisplayValue();
        
    if (con == true) {
      sendJasonString(); //Daten über Websocket nur schicken, wenn Verbindung besteht!
    }}
   nexLoop(nex_listen_list); // Display Toucheventlistener


}    





    
void webSocketEvent(uint8_t num, WStype_t type, uint8_t *payload, size_t lenght) {
  switch (type) {
    case WStype_DISCONNECTED:

      con = false;
      break;
    case WStype_CONNECTED:
      {
      IPAddress ip = webSocket.remoteIP(num);
           
      con = true;
      }
      break;
    case WStype_TEXT:
      {
        String text = String((char *) &payload[0]);
        
//Prüft die Übergabe des Json Objektes von der Website
        if (text == "state_linedetector") {itest=1; i2c_exchange_data();}   
        if (text == "state_engine") {itest=2; i2c_exchange_data();}
        if (text == "state_engine_dir") {itest=3; i2c_exchange_data();}
        if (text == "state_distance_sensor") {itest=4; i2c_exchange_data();}
        if (text == "state_lightsensor") {itest=5; i2c_exchange_data();}
        if (text == "state_wiicam") {itest=6; i2c_exchange_data();}
        if (text == "state_irtower") {itest=7; i2c_exchange_data();}
        if (text == "state_servo") {itest=8; i2c_exchange_data();}
        if (text == "state_ultrasonic") {itest=9; i2c_exchange_data();}
        if (text == "vor") {itest=10; i2c_exchange_data();}
        if (text == "zur") {itest=11; i2c_exchange_data();}
        if (text == "links") {itest=12; i2c_exchange_data();}
        if (text == "rechts") {itest=13; i2c_exchange_data();}
        if (text == "spin") {itest=14; i2c_exchange_data();}
        if (text == "L") {itest=15; i2c_exchange_data();}
        if (text == "dodge") {itest=16; i2c_exchange_data();}
        if (text == "bug") {itest=17; i2c_exchange_data();}
        if (text == "moth") {itest=18; i2c_exchange_data();}
        if (text == "line") {itest=19; i2c_exchange_data();}
        if (text == "follow") {itest=20; i2c_exchange_data();}
        if (text == "map") {itest=21; i2c_exchange_data();}        
        if (text == "servo+") {itest=25; i2c_exchange_data();}
        if (text == "servo-") {itest=26; i2c_exchange_data();}
        if (text == "getUS") {itest=50; i2c_exchange_data();}        
        if (text == "off") {itest=0; i2c_exchange_data();}
        if (text.startsWith("Client connected")){
                  SDFile Sensorfile = SD.open("datalog.txt", FILE_WRITE);
                  if (Sensorfile) {
                      Sensorfile.printf("\n------------------------------------------\n");
                      Sensorfile.printf("------------------------------------------\n");
                      Sensorfile.printf("      NEW CONNECTION ESTABLISHED\n");
                      Sensorfile.printf("------------------------------------------\n");
                      Sensorfile.printf("------------------------------------------\n");
                  Sensorfile.close();
                                    }}
          if (text.startsWith("TIMESTAMP:")){timestamp=text;}else{Serial.println(text);}}
      break;
  }
}




void sendDisplayValue(){
//Sendet Daten an das Display
  
  //Line Sensor
  //get the overflow-value (it's ok, because the value is constant)
  if (rx_buffer.data.linesensorvalue==0){line="L:0 mL:0 mR:0 R:0";}
  if (rx_buffer.data.linesensorvalue==1){line="L:0 mL:0 mR:0 R:1";}
  if (rx_buffer.data.linesensorvalue==10){line="L:0 mL:0 mR:1 R:0";}
  if (rx_buffer.data.linesensorvalue==100){line="L:0 mL:1 mR:0 R:0";}
  if (rx_buffer.data.linesensorvalue==232){line="L:1 mL:0 mR:0 R:0";}
  if (rx_buffer.data.linesensorvalue==76){line="L:1 mL:1 mR:0 R:0";}
  if (rx_buffer.data.linesensorvalue==11){line="L:0 mL:0 mR:1 R:1";}
  if (rx_buffer.data.linesensorvalue==233){line="L:1 mL:0 mR:0 R:1";}
  if (rx_buffer.data.linesensorvalue==110){line="L:0 mL:1 mR:1 R:0";}
  if (rx_buffer.data.linesensorvalue==87){line="L:1 mL:1 mR:1 R:1";}
  if (rx_buffer.data.linesensorvalue==111){line="L:0 mL:1 mR:1 R:1";}
  if (rx_buffer.data.linesensorvalue==86){line="L:1 mL:1 mR:1 R:0";}
  if (rx_buffer.data.linesensorvalue==243){line="L:1 mL:0 mR:1 R:1";}
  if (rx_buffer.data.linesensorvalue==77){line="L:1 mL:1 mR:0 R:1";}
  if (rx_buffer.data.linesensorvalue==101){line="L:0 mL:1 mR:0 R:1";}

  if (rx_buffer.data.distanzsensorvalue==0){dist = "L:0 fL:0 fR:0 R:0";}
  if (rx_buffer.data.distanzsensorvalue==1){dist = "L:0 fL:0 fR:0 R:1";}
  if (rx_buffer.data.distanzsensorvalue==10){dist = "L:0 fL:0 fR:1 R:0";}
  if (rx_buffer.data.distanzsensorvalue==100){dist = "L:0 fL:1 fR:0 R:0";}
  if (rx_buffer.data.distanzsensorvalue==232){dist = "L:1 fL:0 fR:0 R:0";}
  if (rx_buffer.data.distanzsensorvalue==76){dist = "L:1 fL:1 fR:0 R:0";}
  if (rx_buffer.data.distanzsensorvalue==11){dist = "L:0 fL:0 fR:1 R:1";}
  if (rx_buffer.data.distanzsensorvalue==233){dist = "L:1 fL:0 fR:0 R:1";}
  if (rx_buffer.data.distanzsensorvalue==110){dist = "L:0 fL:1 fR:1 R:0";}
  if (rx_buffer.data.distanzsensorvalue==87){dist = "L:1 fL:1 fR:1 R:1";}
  if (rx_buffer.data.distanzsensorvalue==111){dist = "L:0 fL:1 fR:1 R:1";}
  if (rx_buffer.data.distanzsensorvalue==86){dist = "L:1 fL:1 fR:1 R:0";}
  if (rx_buffer.data.distanzsensorvalue==243){dist = "L:1 fL:0 fR:1 R:1";}
  if (rx_buffer.data.distanzsensorvalue==77){dist = "L:1 fL:1 fR:0 R:1";}
  if (rx_buffer.data.distanzsensorvalue==101){dist = "L:0 fL:1 fR:0 R:1";}

  /*
   * first we send object name and atribute to our display.
   * since we are sending a text we need to send double quotes before and after the actual text.
   * We always have to send 3x 8Bit after each command sent to our display.
   * 
   * EXAMPLE (sending text)
   * 
   * Serial.print("ourObjectName.txt=");
   * Serial.print("\"");   
   * Serial.print("our text");   
   * Serial.print("\"");       
   * Serial.write(0xff);       
   * Serial.write(0xff);
   * Serial.write(0xff);
   * 
   * EXAMPLE (sending integer)
   * 
   * Serial.print("ourObjectName.val=");
   * Serial.print("our value");      
   * Serial.write(0xff);       
   * Serial.write(0xff);
   * Serial.write(0xff);
   * 
   * https://lauviktor.de
   */
    
    
  
    Serial.print("tLine.txt=");
    Serial.print("\"");    
    Serial.print(line);   
    Serial.print("\"");       
    Serial.write(0xff);       
    Serial.write(0xff);
    Serial.write(0xff);

    Serial.print("tDist.txt=");
    Serial.print("\"");    
    Serial.print(dist);   
    Serial.print("\"");       
    Serial.write(0xff);       
    Serial.write(0xff);
    Serial.write(0xff);

    Serial.print("tLichtR.txt=");
    Serial.print("\"");    
    Serial.print(rx_buffer.data.lichtrechts);   
    Serial.print("\"");       
    Serial.write(0xff);       
    Serial.write(0xff);
    Serial.write(0xff);

    Serial.print("tLichtL.txt=");
    Serial.print("\"");    
    Serial.print(rx_buffer.data.lichtlinks);   
    Serial.print("\"");       
    Serial.write(0xff);       
    Serial.write(0xff);
    Serial.write(0xff);

    Serial.print("tInfrarot.txt=");
    Serial.print("\"");    
    Serial.print(rx_buffer.data.infarot);   
    Serial.print("\"");       
    Serial.write(0xff);       
    Serial.write(0xff);
    Serial.write(0xff);

    Serial.print("tUltraschall.txt=");
    Serial.print("\"");    
    Serial.print(rx_buffer.data.ultraschall);   
    Serial.print("\"");       
    Serial.write(0xff);       
    Serial.write(0xff);
    Serial.write(0xff);



}




void sendJasonString()
{
//Sendet Daten an die Website über ws 7 json Objekt  
  DynamicJsonBuffer jsonBuf;
  JsonObject& root = jsonBuf.createObject();
  root["action"] = "request";
  
  root["linesensorvalue"] = line;
  root["motorleft"] = rx_buffer.data.motorvalueleft;
  root["motorright"] = rx_buffer.data.motorvalueright;
  root["distanzsensorvalue"] = dist;
  root["lichtlinks"] = rx_buffer.data.lichtlinks;
  root["lichtrechts"] = rx_buffer.data.lichtrechts;
  root["wiicam1"] = rx_buffer.data.wiicam1;
  root["wiicam2"] = rx_buffer.data.wiicam2;
  root["infarot"] = rx_buffer.data.infarot;
  root["ultraschall"] = rx_buffer.data.ultraschall;
  root["servovalue"] = rx_buffer.data.servo;
  root["integer"] = rx_buffer.data.iValue;
  


  //esp-intern
      root["sd"] = sd;
      root["sd_type"] = sdtype;
      root["sd_format"] = formattype;
      root["sd_size"] = sdsize;

    
  char buf[512];
  size_t size = root.printTo(buf, sizeof(buf));
  webSocket.sendTXT(0, buf, size);
}







