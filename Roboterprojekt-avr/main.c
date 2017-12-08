/*******************************************************
This program was created by the
CodeWizardAVR V3.17 UL Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : BlueMatics
Version : 0.0.8
Date    : 28.11.2017
Author  : Viktor Lau
Company : https://lauviktor.de
Comments: 


Chip type               : ATmega128
Program type            : Application
AVR Core Clock frequency: 16,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 1024
*******************************************************/

//Header includes
#include <mega128.h>
#include <delay.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stdio.h>
#include <twi.h>
#include <i2c.h>
#include <io.h>
#include "modules/port_init.h"
#include "modules/servo_ir.h"
#include "modules/esp_main_func.h"
#include "modules/wiicam.h"
#include "modules/ultrasonic.h"


//Verk�rzung von lcd_puts
#define puts lcd_puts

//STATES
#define state_linedetector  0
#define state_engine  1
#define state_engine_dir  2
#define state_distance_sensor  3
#define state_lightsensor  4
#define state_wiicam  5
#define state_irtower  6
#define state_servo  7
#define state_ultrasonic  8
#define state_vor  9
#define state_zur  10
#define state_links  11
#define state_rechts  12
#define state_90links  13
#define state_90rechts  14
#define state_drehung  15
#define state_meterlinksmeterrechts  16

int state_info = 0;
int leftCounter = 0;
int rightCounter = 0;     
int leftEnc = 0;
int rightEnc = 0;  

int engine_dir = 0;






int wiicamobject=0;




#include "modules/esp.h"


void STATE_LINE_SENSOR(){
         lcd_clear();   
   if(!LINE_DETECTOR_LEFT)
     lcd_puts("LEFT: 1");
   else  
     lcd_puts("LEFT: 0");
   if(!LINE_DETECTOR_RIGHT)
     lcd_puts(" RIGHT: 1");
   else  
     lcd_puts(" RIGHT: 0");
   lcd_gotoxy(0,1);
   if(!LINE_DETECTOR_MID_LEFT)
     lcd_puts("MLEFT: 1");
   else  
     lcd_puts("MLEFT: 0");
   if(!LINE_DETECTOR_MID_RIGHT)
     lcd_puts("MRIGHT:1");
   else  
     lcd_puts("MRIGHT:0");       
 }
 
  /////////////////////////// 
 
  void STATE_ENGINE(){
 char str[17];
      ENGINE_ENABLE_RIGHT = 1;
      ENGINE_ENABLE_LEFT = 1;
             lcd_clear();                      
      if(engine_dir == 0){
        lcd_puts("     ENCODER  >>");
        ENGINE_DIRECTION_LEFT = 0;  
        ENGINE_DIRECTION_RIGHT = 0;
        }
      else{                           
        lcd_puts("<<   ENCODER    ");     
        ENGINE_DIRECTION_LEFT = 1;  
        ENGINE_DIRECTION_RIGHT = 1;
        }
         lcd_gotoxy(0,1); 
         puts("L:");
         itoa(wheelEncoderCounter_left,str);
         puts(str);
         puts(" R:");
         itoa(wheelEncoderCounter_right,str);
         puts(str);    
       if(!BUMPER_RIGHT){   
       delay_ms(250);  
       engine_dir = !engine_dir;
       }      
 }   
                             
  /////////////////////////// 
 
   void STATE_ENGINE_DIR(){
 char str[10];
      ENGINE_ENABLE_RIGHT = 1;
      ENGINE_ENABLE_LEFT = 1;
      lcd_clear();                      
      if(engine_dir == 0){
        lcd_puts("     RECHTS    ");
        ENGINE_DIRECTION_LEFT = 0;  
        ENGINE_DIRECTION_RIGHT = 1;
        }
      else{                           
        lcd_puts("     LINKS    ");     
        ENGINE_DIRECTION_LEFT = 1;  
        ENGINE_DIRECTION_RIGHT = 0;
        }
         lcd_gotoxy(0,1); 
         puts("L:");
         itoa(wheelEncoderCounter_left,str);
         puts(str);
         puts(" R:");
         itoa(wheelEncoderCounter_right,str);
         puts(str);    
       if(!BUMPER_RIGHT){   
       delay_ms(250);  
       engine_dir = !engine_dir;
       }      
 }
 
  ///////////////////////////   

 void STATE_DISTANCE_SENSOR(){   
   lcd_clear();
   if(!DISTANCE_SENSOR_LEFT)
     lcd_puts("LEFT: 1");
   else  
     lcd_puts("LEFT: 0");
   if(!DISTANCE_SENSOR_RIGHT)
     lcd_puts(" RIGHT: 1");
   else  
     lcd_puts(" RIGHT: 0");
   lcd_gotoxy(0,1);
   if(!DISTANCE_SENSOR_FRONT_LEFT)
     lcd_puts("FLEFT: 1");
   else  
     lcd_puts("FLEFT: 0");
   if(!DISTANCE_SENSOR_FRONT_RIGHT)
     lcd_puts("FRIGHT:1");
   else  
     lcd_puts("FRIGHT:0");       
 }
 
  ///////////////////////////
  
 void STATE_LIGHTSENSOR(){ 
 int right = LIGHT_SENSOR_RIGHT;
 int left = LIGHT_SENSOR_LEFT;  
 char str[10];
 lcd_clear();
    puts("LEFT:");
    itoa(left,str);
    puts(str);
    lcd_gotoxy(0,1);
    puts("RIGHT:");
    itoa(right,str);
    puts(str);   
 }   
          
  ///////////////////////////

 void STATE_WIICAM(){ 
        unsigned char iWII=0;
        readData();
        convertdata();
        lcd_clear();
        //Anzeige der Blobs als X/X-Wertepaare
        for(iWII=0; iWII<4; iWII++){
                if (iWII<2){           //erste Zeile: Blob 1 und 2
                   if(x[iWII]==1023||y[iWII]==1023){
                        lcd_gotoxy(20 * (iWII), 0);
                   lcd_putsf("No Object!");  
                   wiicamobject=0;
                  }
                   else{
                    itoa( x[iWII]-512, Wert);  //konvertiert die int-Ausgabe des Empf�ngers in char-Array   
                  lcd_gotoxy(20 * (iWII), 0);
                   lcd_puts(Wert);
                   itoa( y[iWII]-374, Wert);
                   lcd_gotoxy(20 * (iWII)+ 8, 0);
                   lcd_puts(Wert);
                   itoa( sWIICAM[iWII], Wert);
                   lcd_gotoxy(20 * (iWII)+ 16, 0);
                   lcd_puts(Wert);  
                   wiicamobject=1;

                   }
               }
               else
               { 
                   if(x[iWII]==1023||y[iWII]==1023){
                        lcd_gotoxy(20 * (iWII-2), 1);
                   lcd_putsf("No Object!");   
                   wiicamobject=0;

                  }
                 else{                   //zweite Zeile: Blob 3 und 4
                    itoa( x[iWII]-512, Wert);   
                  lcd_gotoxy(20 * (iWII-2), 1);
                   lcd_puts(Wert);
                       itoa( y[iWII]-374, Wert);
                   lcd_gotoxy(20 * (iWII-2)+ 8, 1);
                   lcd_puts(Wert);
                       itoa( sWIICAM[iWII], Wert);
                   lcd_gotoxy(20 * (iWII-2)+ 16, 1);
                   lcd_puts(Wert);
                   wiicamobject=1;
                   }
               }
          }
    delay_ms(30);
    WII_CAM_SCL = !WII_CAM_SCL;
 }       

  ///////////////////////////
  
 void STATE_IRTOWER(){
    #ifndef DEBUG
      rc5_display();
    #endif 
     
    if(rc5_receive(&ucToggle, &ucAdress, &ucData))
    {               
      switch (ucData)
      {
        case 1: 
          delay_ms(100);
          break;
      }
    }
 }      
    
 
  ///////////////////////////
 
  void STATE_SERVO(){  
    lcd_clear();    
      fnDisplay();
      delay_ms(200);
 }

  /////////////////////////// 
 
  void STATE_ULTRASONIC(){
       if (bChange2)
    {   
      lcd_gotoxy(0,1);
      if (iTime <= 6000)
      {   
      lcd_clear();  
      lcd_putsf("Objekt gefunden");
          lcd_gotoxy(0,1);

        itoa(iTime/52.2, strULTRA);
        lcd_puts(strULTRA); 
        
      }  
      else
      {  
      lcd_clear();
        lcd_putsf("Kein Objekt");
      }
      bChange2 = 0;
    }
  }
    
  /////////////////////////// 
 
  void STATE_VOR(){
  ENGINE_ENABLE_RIGHT = 1;
  ENGINE_ENABLE_LEFT = 1;      
  ENGINE_DIRECTION_LEFT = 0;  
  ENGINE_DIRECTION_RIGHT = 0;
  }    
    /////////////////////////// 
 
  void STATE_ZUR(){
  ENGINE_ENABLE_RIGHT = 1;
  ENGINE_ENABLE_LEFT = 1; 
  ENGINE_DIRECTION_LEFT = 1;  
  ENGINE_DIRECTION_RIGHT = 1;   
  }  
    /////////////////////////// 
 
  void STATE_LINKS(){
  ENGINE_ENABLE_RIGHT = 1;
  ENGINE_ENABLE_LEFT = 0;  
  ENGINE_DIRECTION_LEFT = 0;  
  ENGINE_DIRECTION_RIGHT = 0;
  }  
    /////////////////////////// 
 
  void STATE_RECHTS(){
  ENGINE_ENABLE_RIGHT = 0;
  ENGINE_ENABLE_LEFT = 1;   
  ENGINE_DIRECTION_LEFT = 0;  
  ENGINE_DIRECTION_RIGHT = 0;
  }       
    /////////////////////////// 
 
  void STATE_90RECHTS(){
  wheelEncoderCounter_left=0;
  wheelEncoderCounter_right=0; 
  do{
  ENGINE_ENABLE_RIGHT = 1;
  ENGINE_ENABLE_LEFT = 0;   
  ENGINE_DIRECTION_LEFT = 0;  
  ENGINE_DIRECTION_RIGHT = 1;  
         lcd_clear();
         lcd_gotoxy(0,1); 
         puts("L:");
         itoa(wheelEncoderCounter_left,str);
         puts(str);
         puts(" R:");
         itoa(wheelEncoderCounter_right,str);
         puts(str);
  
  }while (wheelEncoderCounter_right<17);
  } 
   
         
    /////////////////////////// 
 
  void STATE_90LINKS(){
  wheelEncoderCounter_left=0;
  wheelEncoderCounter_right=0; 
  do{
  ENGINE_ENABLE_RIGHT = 0;
  ENGINE_ENABLE_LEFT = 1;   
  ENGINE_DIRECTION_LEFT = 1;  
  ENGINE_DIRECTION_RIGHT = 0;  
         lcd_clear();
         lcd_gotoxy(0,1); 
         puts("L:");
         itoa(wheelEncoderCounter_left,str);
         puts(str);
         puts(" R:");
         itoa(wheelEncoderCounter_right,str);
         puts(str);
  
  }while (wheelEncoderCounter_left<17);
  }   
  
   /////////////////////////// 
 
  void STATE_DREHUNG(){
  wheelEncoderCounter_left=0;
  wheelEncoderCounter_right=0; 
  do{
  ENGINE_ENABLE_RIGHT = 1;
  ENGINE_ENABLE_LEFT = 1;   
  ENGINE_DIRECTION_LEFT = 1;  
  ENGINE_DIRECTION_RIGHT = 0;  
         lcd_clear();
         lcd_gotoxy(0,1); 
         puts("L:");
         itoa(wheelEncoderCounter_left,str);
         puts(str);
         puts(" R:");
         itoa(wheelEncoderCounter_right,str);
         puts(str);
  
  }while (wheelEncoderCounter_left<64&&wheelEncoderCounter_right<64);
  } 

   /////////////////////////// 
 
  void  STATE_METERLINKSMETERRECHTS(){
  
  /////DREHUNG NACH LINKS
  wheelEncoderCounter_left=0;
  wheelEncoderCounter_right=0; 
  do{
  ENGINE_ENABLE_RIGHT = 0;
  ENGINE_ENABLE_LEFT = 1;   
  ENGINE_DIRECTION_LEFT = 1;  
  ENGINE_DIRECTION_RIGHT = 0;  
         lcd_clear();
         lcd_gotoxy(0,1); 
         puts("L:");
         itoa(wheelEncoderCounter_left,str);
         puts(str);
         puts(" R:");
         itoa(wheelEncoderCounter_right,str);
         puts(str);
  
  }while (wheelEncoderCounter_left<17);   

  ENGINE_ENABLE_RIGHT = 0;
  ENGINE_ENABLE_LEFT = 0; 
  delay_ms(1000);
 
  
  /////1m VORW�RTS
  wheelEncoderCounter_left=0;
  wheelEncoderCounter_right=0; 
  do{
  ENGINE_ENABLE_RIGHT = 1;
  ENGINE_ENABLE_LEFT = 1;   
  ENGINE_DIRECTION_LEFT = 0;  
  ENGINE_DIRECTION_RIGHT = 0;  
         lcd_clear();
         lcd_gotoxy(0,1); 
         puts("L:");
         itoa(wheelEncoderCounter_left,str);
         puts(str);
         puts(" R:");
         itoa(wheelEncoderCounter_right,str);
         puts(str); 
  }while (wheelEncoderCounter_left<100&&wheelEncoderCounter_right<100);
  
  ENGINE_ENABLE_RIGHT = 0;
  ENGINE_ENABLE_LEFT = 0;   
  delay_ms(1000);

  
  /////DREHUNG NACH RECHTS
  wheelEncoderCounter_left=0;
  wheelEncoderCounter_right=0; 
  do{
  ENGINE_ENABLE_RIGHT = 1;
  ENGINE_ENABLE_LEFT = 0;   
  ENGINE_DIRECTION_LEFT = 0;  
  ENGINE_DIRECTION_RIGHT = 1;  
         lcd_clear();
         lcd_gotoxy(0,1); 
         puts("L:");
         itoa(wheelEncoderCounter_left,str);
         puts(str);
         puts(" R:");
         itoa(wheelEncoderCounter_right,str);
         puts(str);
  
  }while (wheelEncoderCounter_right<17); 

  ENGINE_ENABLE_RIGHT = 0;
  ENGINE_ENABLE_LEFT = 0;   
  delay_ms(1000);
 
  /////1m VORW�RTS
  wheelEncoderCounter_left=0;
  wheelEncoderCounter_right=0; 
  do{
  ENGINE_ENABLE_RIGHT = 1;
  ENGINE_ENABLE_LEFT = 1;   
  ENGINE_DIRECTION_LEFT = 0;  
  ENGINE_DIRECTION_RIGHT = 0;  
         lcd_clear();
         lcd_gotoxy(0,1); 
         puts("L:");
         itoa(wheelEncoderCounter_left,str);
         puts(str);
         puts(" R:");
         itoa(wheelEncoderCounter_right,str);
         puts(str); 
  }while (wheelEncoderCounter_left<100&&wheelEncoderCounter_right<100);  
  
  } 
    
  



void STATE_MACHINE(){
        ENGINE_ENABLE_RIGHT = 0;  
        ENGINE_ENABLE_LEFT = 0;
       switch(state){
       case state_linedetector:  
              if(state_info == 0){ 
                lcd_clear();
                lcd_puts("  LINEDETECTOR  ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_LINE_SENSOR();
       break; 
       
       case state_engine:         
              if(state_info == 0){
                lcd_clear();
                lcd_puts("     MOTOREN    ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_ENGINE();
       break;
                  
       case state_engine_dir:         
              if(state_info == 0){  
                lcd_clear();
                lcd_puts("     LENKUNG    ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_ENGINE_DIR();
       break;
       
       case state_distance_sensor: 
              if(state_info == 0){  
                lcd_clear();  
                lcd_puts(" DISTANZ SENSOR ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_DISTANCE_SENSOR();     
       break;

       case state_lightsensor: 
              if(state_info == 0){
                  lcd_clear();
                  lcd_puts("  LICHT SENSOR  ");
                  delay_ms(1000);
                  lcd_clear();
                  state_info = 1;
                }
              STATE_LIGHTSENSOR();
       break;

       case state_wiicam:
                if(state_info == 0){    
                lcd_clear();
                lcd_puts("     WII CAM   ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_WIICAM();
       break;     
       
       case state_irtower:
                if(state_info == 0){   
                lcd_clear();
                lcd_puts("    IR TOWER    ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_IRTOWER();
       break;    
       
       case state_servo:
                if(state_info == 0){
                lcd_clear();
                lcd_puts("     SERVO    ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_SERVO();
       break;       
       
       case state_ultrasonic:
                if(state_info == 0){   
                lcd_clear();
                lcd_puts("   ULTRASCHALL  ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_ULTRASONIC();
       break;    
       
              case state_vor:
                if(state_info == 0){   
                lcd_clear();
                lcd_puts("      VOR       ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_VOR();
       break;    
              case state_zur:
                if(state_info == 0){   
                lcd_clear();
                lcd_puts("      ZUR       ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_ZUR();
       break;    
              case state_links:
                if(state_info == 0){   
                lcd_clear();
                lcd_puts("      LINKS      ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_LINKS();
       break;   
       
              case state_rechts:
                if(state_info == 0){   
                lcd_clear();
                lcd_puts("     RECHTS     ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_RECHTS();
       break;          

              case state_90links:
                if(state_info == 0){   
                lcd_clear();
                lcd_puts("     90LINKS     ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_90LINKS();
       break;   
       
              case state_90rechts:
                if(state_info == 0){   
                lcd_clear();
                lcd_puts("    90RECHTS    ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_90RECHTS();
       break;     

              case state_drehung:
                if(state_info == 0){   
                lcd_clear();
                lcd_puts("    DREHUNG    ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_DREHUNG();
       break;    
       
              case state_meterlinksmeterrechts:
                if(state_info == 0){   
                lcd_clear();
                lcd_puts("    1m1m    ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_METERLINKSMETERRECHTS();
             

       break;    
       default: 
           lcd_clear();
           lcd_puts("   BlueMatics"); 
           lcd_gotoxy(0,1);
           lcd_puts("     Robby");  
      }                                
       delay_ms(50);
}


  


void main(void)
{
// Ports initialisieren
port_init();
// I2C Bus initialisieren
i2c_init();
//Kamera initialisieren
wii_cam_init();
// TWI slave initialization 
  twi_slave_init(false,TWI_SLAVE_ADDR,rx_buffer.bytes,BUFFER_SIZE,tx_buffer.bytes,slave_rx_handler,slave_tx_handler);

while (1)
      {          
      STATE_MACHINE();     
      esp_states();      
      
      if (!BUMPER_RIGHT){
        state=16;
      } 
        
      

      
      
///////IR DATEN AUSWERTEN//////////
    if(rc5_receive(&ucToggle, &ucAdress, &ucData))
    {               
      switch (ucData)
      {
        case 0: 
        state=state_stop;
          delay_ms(100);
          break;
        case 1: 
        state=15;
          delay_ms(100);
          break;
        case 2: 
        state=16;
          delay_ms(100);
          break;  
            
      }
    }      
esp_mainfunctions();
}
}