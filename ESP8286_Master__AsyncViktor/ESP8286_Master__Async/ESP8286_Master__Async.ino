#include <SD.h>
#include <ESP8266WiFi.h>
#include <SPI.h>
//#include <WiFiClient.h>
#include <WebSocketsServer.h>
#include <ArduinoJson.h>
//#include <ESPAsyncTCP.h>
#include <ESPAsyncWebServer.h>
//#include <ESP8266WebServer.h>
#include <FS.h>
#include <Wire.h>
#include "webpage.h"
#include "map.h"



/*-------------------SD Defs-----------------------------------------*/
String    error;
uint8_t   sd=0;
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

// TX_BUFFER, RX_BUFFER
#define BUFFER_SIZE 15

int itest = 0;
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
  uint8_t wiicam;
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








void i2c_exchange_data(void)
{
  // Daten, die gesendet werden
  tx_buffer.data.iValue = itest;         
  char timestampBuffer[50];
  // transmit data from tx_buffer to the slave and receive response in rx_buffer
  i2c_result = i2c_master_trans(TWI_SLAVE_ADDR, tx_buffer.bytes, BUFFER_SIZE, rx_buffer.bytes, BUFFER_SIZE);
  // display the transaction on the terminal
  if (i2c_result == 0)
  {

    // I2C transaction was performed without errors
    if (sd=1){
    timestamp.toCharArray(timestampBuffer, 50); 
    SDFile Sensorfile = SD.open("datalog.txt", FILE_WRITE);

    // if the file is available, write to it:
    if (Sensorfile) {
    Sensorfile.printf("------------------------------------------\n");
    Sensorfile.printf(timestampBuffer);
    Sensorfile.printf("\n");
    Sensorfile.printf("I2C transaction result: %i\r\n", i2c_result);
    Sensorfile.printf("Transmitted to MEGA128: %2i\r\n", tx_buffer.data.iValue);
    Sensorfile.printf("Received from MEGA128: %4i %4i %4i %4i %4i %4i %4i %4i\r\n", rx_buffer.data.linesensorvalue, rx_buffer.data.distanzsensorvalue, 
    rx_buffer.data.lichtlinks, rx_buffer.data.lichtrechts, rx_buffer.data.motorvalueleft, rx_buffer.data.motorvalueright, rx_buffer.data.wiicam, rx_buffer.data.iValue);
    Sensorfile.printf("Content of Receive Buffer: ");
     for (int i = 0; i < BUFFER_SIZE; i++)
    Sensorfile.printf("%2X ", rx_buffer.bytes[i]);
    Sensorfile.printf("\r\n\n");
    Sensorfile.close();
  }}}
  else
  {
    if (sd=1){
    timestamp.toCharArray(timestampBuffer, 50);
    SDFile Sensorfile = SD.open("datalog.txt", FILE_WRITE);

    // if the file is available, write to it:
    if (Sensorfile) {
    Sensorfile.printf("-----------------ERROR-----------------\n");
    Sensorfile.printf(timestampBuffer);
    Sensorfile.printf("\n");
    Sensorfile.printf("I2C transaction error: %i\r\n", i2c_result);
    Sensorfile.printf("Transmitted to MEGA128: %2i\r\n", tx_buffer.data.iValue);
    Sensorfile.printf("Received from MEGA128: %4i %4i %4i %4i %4i %4i %4i %4i\r\n", rx_buffer.data.linesensorvalue, rx_buffer.data.distanzsensorvalue, 
    rx_buffer.data.lichtlinks, rx_buffer.data.lichtrechts, rx_buffer.data.motorvalueleft, rx_buffer.data.motorvalueright, rx_buffer.data.wiicam, rx_buffer.data.iValue);
    Sensorfile.printf("Content of Receive Buffer: ");
     for (int i = 0; i < BUFFER_SIZE; i++)
    Sensorfile.printf("%2X ", rx_buffer.bytes[i]);
    Sensorfile.printf("\r\n\n");
    Sensorfile.close();
  }}}
  

  
}

//---------------Prototypes for webevent handling-------------------
void webSocketEvent(uint8_t , WStype_t, uint8_t * , size_t );
void sendJasonString();



void setup() {
  // I2C initialization
  Wire.setClock(400000);
  Wire.begin();

  // Serial initialization
  Serial.begin(115200);
  Serial.println();
  delay(200);
  if (!card.init(SPI_HALF_SPEED, 14)) {
    //sd-card not found
    sd=0;
    return;
  } else {
    //sd-card found
    sd=1;
    }
  // get the type of card
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
    Serial.println("Could not find FAT16/FAT32 partition.\nMake sure you've formatted the card");
    return;
  }
  // print the type and size of the first FAT-type volume
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

  Serial.print("Setting soft-AP configuration ... ");
  Serial.println(WiFi.softAPConfig(local_IP, gateway, subnet) ? "Ready" : "Failed!");
  Serial.print("Setting soft-AP ... ");
  Serial.println(WiFi.softAP("ESPsoftAP_01") ? "Ready" : "Failed!");
  Serial.print("Soft-AP IP address = ");
  Serial.println(WiFi.softAPIP());
  Serial.print("Station IP address = ");
  Serial.println(WiFi.localIP());
  
    // SPIFFS initialization
    if (!SPIFFS.begin())
    {
    // Serious problem
    Serial.println("SPIFFS Mount failed");
    } else {
    Serial.println("SPIFFS Mount succesfull");
    }
  

  // WebSocket
  webSocket.begin();
  webSocket.onEvent(webSocketEvent);
  Serial.println("WebSocket gestartet!");
  
  // WebServer
  server.on("/", HTTP_GET, [](AsyncWebServerRequest *request) {
    request->send_P(200, "text/html", html);
  });
  server.on("/map", HTTP_GET, [](AsyncWebServerRequest *request) {
    request->send_P(200, "text/html", handleMAP);
  });
  
  server.begin();
  Serial.println("HTTP server gestartet!");
}



void loop() {
  unsigned long currentMillis = millis();
  webSocket.loop();    
  //avoid overloading the serial pipe which causes hanging up the terminal and watchdog
  if (currentMillis % 1000 == 0) {
    if (con == true) {
      i2c_exchange_data();
      sendJasonString(); //Daten über Websocket nur schicken, wenn Verbindung besteht!
    }}


    
    }





    
void webSocketEvent(uint8_t num, WStype_t type, uint8_t *payload, size_t lenght) {
  switch (type) {
    case WStype_DISCONNECTED:
      Serial.println("Websocket disconnected!");
      con = false;
      break;
    case WStype_CONNECTED:
      {
      IPAddress ip = webSocket.remoteIP(num);
      Serial.println("Websocket Connected!");
      Serial.println(ip);
      con = true;
      }
      break;
    case WStype_TEXT:
      {
        String text = String((char *) &payload[0]);

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
        if (text == "off") {itest=0; i2c_exchange_data();}
        if (text == "servo+") {itest=20; i2c_exchange_data();}
        if (text == "servo-") {itest=21; i2c_exchange_data();}
        if (text.startsWith("Client connected")){
          if (sd=1){
                  SDFile Sensorfile = SD.open("datalog.txt", FILE_WRITE);
                  if (Sensorfile) {
                      Sensorfile.printf("\n------------------------------------------\n");
                      Sensorfile.printf("------------------------------------------\n");
                      Sensorfile.printf("      NEW CONNECTION ESTABLISHED\n");
                      Sensorfile.printf("------------------------------------------\n");
                      Sensorfile.printf("------------------------------------------\n");
                  Sensorfile.close();
                                    }}}
          if (text.startsWith("TIMESTAMP:")){timestamp=text;}else{Serial.println(text);}}
      break;
  }
}

void sendJasonString()
{
  DynamicJsonBuffer jsonBuf;
  JsonObject& root = jsonBuf.createObject();
  root["action"] = "request";
  //Liniensensor
  if (rx_buffer.data.linesensorvalue==0){root["linesensorvalue"] = "LEFT:0  mLEFT:0  mRIGHT:0  RIGHT:0";}
  if (rx_buffer.data.linesensorvalue==1){root["linesensorvalue"] = "LEFT:0  mLEFT:0  mRIGHT:0  RIGHT:1";}
  if (rx_buffer.data.linesensorvalue==10){root["linesensorvalue"] = "LEFT:0  mLEFT:0  mRIGHT:1  RIGHT:0";}
  if (rx_buffer.data.linesensorvalue==100){root["linesensorvalue"] = "LEFT:0  mLEFT:1  mRIGHT:0  RIGHT:0";}
  if (rx_buffer.data.linesensorvalue==232){root["linesensorvalue"] = "LEFT:1  mLEFT:0  mRIGHT:0  RIGHT:0";}
  if (rx_buffer.data.linesensorvalue==76){root["linesensorvalue"] = "LEFT:1  mLEFT:1  mRIGHT:0  RIGHT:0";}
  if (rx_buffer.data.linesensorvalue==11){root["linesensorvalue"] = "LEFT:0  mLEFT:0  mRIGHT:1  RIGHT:1";}
  if (rx_buffer.data.linesensorvalue==233){root["linesensorvalue"] = "LEFT:1  mLEFT:0  mRIGHT:0  RIGHT:1";}
  if (rx_buffer.data.linesensorvalue==110){root["linesensorvalue"] = "LEFT:0  mLEFT:1  mRIGHT:1  RIGHT:0";}
  if (rx_buffer.data.linesensorvalue==87){root["linesensorvalue"] = "LEFT:1  mLEFT:1  mRIGHT:1  RIGHT:1";}
  if (rx_buffer.data.linesensorvalue==111){root["linesensorvalue"] = "LEFT:0  mLEFT:1  mRIGHT:1  RIGHT:1";}
  if (rx_buffer.data.linesensorvalue==86){root["linesensorvalue"] = "LEFT:1  mLEFT:1  mRIGHT:1  RIGHT:0";}
  if (rx_buffer.data.linesensorvalue==243){root["linesensorvalue"] = "LEFT:1  mLEFT:0  mRIGHT:1  RIGHT:1";}
  if (rx_buffer.data.linesensorvalue==77){root["linesensorvalue"] = "LEFT:1  mLEFT:1  mRIGHT:0  RIGHT:1";}
  if (rx_buffer.data.linesensorvalue==101){root["linesensorvalue"] = "LEFT:0  mLEFT:1  mRIGHT:0  RIGHT:1";}
  
  root["motorleft"] = rx_buffer.data.motorvalueleft;
  root["motorright"] = rx_buffer.data.motorvalueright;

  if (rx_buffer.data.distanzsensorvalue==0){root["distanzsensorvalue"] = "LEFT:0  fLEFT:0  fRIGHT:0  RIGHT:0";}
  if (rx_buffer.data.distanzsensorvalue==1){root["distanzsensorvalue"] = "LEFT:0  fLEFT:0  fRIGHT:0  RIGHT:1";}
  if (rx_buffer.data.distanzsensorvalue==10){root["distanzsensorvalue"] = "LEFT:0  fLEFT:0  fRIGHT:1  RIGHT:0";}
  if (rx_buffer.data.distanzsensorvalue==100){root["distanzsensorvalue"] = "LEFT:0  fLEFT:1  fRIGHT:0  RIGHT:0";}
  if (rx_buffer.data.distanzsensorvalue==232){root["distanzsensorvalue"] = "LEFT:1  fLEFT:0  fRIGHT:0  RIGHT:0";}
  if (rx_buffer.data.distanzsensorvalue==76){root["distanzsensorvalue"] = "LEFT:1  fLEFT:1  fRIGHT:0  RIGHT:0";}
  if (rx_buffer.data.distanzsensorvalue==11){root["distanzsensorvalue"] = "LEFT:0  fLEFT:0  fRIGHT:1  RIGHT:1";}
  if (rx_buffer.data.distanzsensorvalue==233){root["distanzsensorvalue"] = "LEFT:1  fLEFT:0  fRIGHT:0  RIGHT:1";}
  if (rx_buffer.data.distanzsensorvalue==110){root["distanzsensorvalue"] = "LEFT:0  fLEFT:1  fRIGHT:1  RIGHT:0";}
  if (rx_buffer.data.distanzsensorvalue==87){root["distanzsensorvalue"] = "LEFT:1  fLEFT:1  fRIGHT:1  RIGHT:1";}
  if (rx_buffer.data.distanzsensorvalue==111){root["distanzsensorvalue"] = "LEFT:0  fLEFT:1  fRIGHT:1  RIGHT:1";}
  if (rx_buffer.data.distanzsensorvalue==86){root["distanzsensorvalue"] = "LEFT:1  fLEFT:1  fRIGHT:1  RIGHT:0";}
  if (rx_buffer.data.distanzsensorvalue==243){root["distanzsensorvalue"] = "LEFT:1  fLEFT:0  fRIGHT:1  RIGHT:1";}
  if (rx_buffer.data.distanzsensorvalue==77){root["distanzsensorvalue"] = "LEFT:1  fLEFT:1  fRIGHT:0  RIGHT:1";}
  if (rx_buffer.data.distanzsensorvalue==101){root["distanzsensorvalue"] = "LEFT:0  fLEFT:1  fRIGHT:0  RIGHT:1";}
  root["lichtlinks"] = rx_buffer.data.lichtlinks;
  root["lichtrechts"] = rx_buffer.data.lichtrechts;
  root["wiicam"] = rx_buffer.data.wiicam;
  root["infarot"] = rx_buffer.data.infarot;
  root["ultraschall"] = rx_buffer.data.ultraschall;
  root["servovalue"] = rx_buffer.data.servo;
  root["integer"] = rx_buffer.data.iValue;


  //esp-intern
  if (sd=1){
      root["sd"] = 1;
      root["sd_type"] = sdtype;
      root["sd_format"] = formattype;
      root["sd_size"] = sdsize;
  }else{
      root["sd"] = 0;   
  }
    
  char buf[512];
  size_t size = root.printTo(buf, sizeof(buf));
  webSocket.sendTXT(0, buf, size);
}







