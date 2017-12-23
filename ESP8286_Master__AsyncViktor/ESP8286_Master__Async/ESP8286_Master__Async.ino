#include <SD.h>
#include <ESP8266WiFi.h>
//#include <WiFiClient.h>
#include <WebSocketsServer.h>
#include <ArduinoJson.h>
//#include <ESPAsyncTCP.h>
#include <ESPAsyncWebServer.h>
//#include <ESP8266WebServer.h>
#include <FS.h>
#include <Wire.h>
#include "webpage.h"
#include <GPD2846.h>


/*-------------------Voice-Modul-------------------------------------*/
GPD2846 speech(15,16,10); // ESP pins GPIO10 = S1, GPIO16 = S2, GPIO2 = S3 on Voice Modul
/*-------------------SD Defs-----------------------------------------*/
int sd=0;
int newboot=0;
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
        
  // transmit data from tx_buffer to the slave and receive response in rx_buffer
  i2c_result = i2c_master_trans(TWI_SLAVE_ADDR, tx_buffer.bytes, BUFFER_SIZE, rx_buffer.bytes, BUFFER_SIZE);
  // display the transaction on the terminal
  if (i2c_result == 0)
  {
    // I2C transaction was performed without errors
    Serial.printf("I2C transaction result: %i\r\n", i2c_result);
    Serial.printf("Transmitted to MEGA128: %2i\r\n", tx_buffer.data.iValue);
    Serial.printf("Received from MEGA128: %4i %4i %4i %4i %4i %4i %4i %4i\r\n", rx_buffer.data.linesensorvalue, rx_buffer.data.distanzsensorvalue, 
    rx_buffer.data.lichtlinks, rx_buffer.data.lichtrechts, rx_buffer.data.motorvalueleft, rx_buffer.data.motorvalueright, rx_buffer.data.wiicam, rx_buffer.data.iValue);
    Serial.printf("Content of Receive Buffer: ");
    for (int i = 0; i < BUFFER_SIZE; i++)
      Serial.printf("%2X ", rx_buffer.bytes[i]);
    Serial.printf("\r\n");
  }
  else
  {
    // I2C transaction was performed with errors
    Serial.printf("I2C transaction error: %i\r\n\r\n", i2c_result);
    Serial.printf("Received from MEGA128: %4i %4i %4i %4i %4i %4i %4i %4i\r\n", rx_buffer.data.linesensorvalue, rx_buffer.data.distanzsensorvalue, 
    rx_buffer.data.lichtlinks, rx_buffer.data.lichtrechts, rx_buffer.data.motorvalueleft, rx_buffer.data.motorvalueright, rx_buffer.data.wiicam, rx_buffer.data.iValue);
    Serial.printf("Content of Receive Buffer: ");
    for (int i = 0; i < BUFFER_SIZE; i++)
      Serial.printf("%2X ", rx_buffer.bytes[i]);
    Serial.printf("\r\n");
  }
  
    if (sd=1){
    SDFile Sensorfile = SD.open("datalog.txt", FILE_WRITE);
    // if the file is available, write to it:
    if (Sensorfile) {
    Sensorfile.printf("------------------------------------------\n\n\n");
    Sensorfile.printf("I2C transaction result: %i\r\n", i2c_result);
    Sensorfile.printf("Transmitted to MEGA128: %2i\r\n", tx_buffer.data.iValue);
    Sensorfile.printf("Received from MEGA128: %4i %4i %4i %4i %4i %4i %4i %4i\r\n", rx_buffer.data.linesensorvalue, rx_buffer.data.distanzsensorvalue, 
    rx_buffer.data.lichtlinks, rx_buffer.data.lichtrechts, rx_buffer.data.motorvalueleft, rx_buffer.data.motorvalueright, rx_buffer.data.wiicam, rx_buffer.data.iValue);
    Sensorfile.printf("Content of Receive Buffer: ");
     for (int i = 0; i < BUFFER_SIZE; i++)
    Sensorfile.printf("%2X ", rx_buffer.bytes[i]);
    Sensorfile.printf("\r\n");
    Sensorfile.close();
  }
  }
  
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

    //SD CARD
  Serial.print("Initializing SD card...");
  if (!SD.begin(14)) {
    Serial.println("initialization failed!");
    sd=0;
    return;
  }else{
    Serial.println("SD Card found");
    sd=1;  
  }

  
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
    }}}
    
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
        Serial.println(text);

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

        if (text == "playpause") {speech.pause();}
        if (text == "next") {speech.next();}
        if (text == "prev") {speech.previous();}
        if (text == "volumeup") {speech.volumeUp();}
        if (text == "volumedown") {speech.volumeDown();}
     }
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
    
  char buf[512];
  size_t size = root.printTo(buf, sizeof(buf));
  webSocket.sendTXT(0, buf, size);
}





