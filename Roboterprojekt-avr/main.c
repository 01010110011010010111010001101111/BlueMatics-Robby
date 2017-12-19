/*******************************************************
This program was created by the
CodeWizardAVR V3.17 UL Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
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
#define state_2  17
#define state_3  18

#define state_stop 19



#include "modules/variables.h"
#include "modules/port_init.h"


/*
 void radkorrektur(){
char strrad [17];
 float newval = 100/(wheelEncoderCounter_right+wheelEncoderCounter_left);
 float newvalprozent= newval*wheelEncoderCounter_left;
 itoa(newvalprozent,strrad); 
  lcd_clear();
 lcd_puts(strrad);

}
*/


#include "modules/ir.h"
#include "modules/servo.h"
#include "modules/esp_main_func.h"
#include "modules/wiicam.h"
#include "modules/ultrasonic.h"
#include "modules/states/states.h"
#include "modules/esp.h"




// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
  // Reinitialize Timer 1 value
  TCNT1L=0x9C;
  ipwmcounter++; 



  
  
  if (ipwmcounter>255)
    ipwmcounter=0;  
          





    

 if(ipwmcounter >= ipwmcompareleft){
 ENGINE_ENABLE_LEFT=0;  
  }else{
  ENGINE_ENABLE_LEFT=1;
  }  
      
 if(ipwmcounter >= ipwmcompareright){
 ENGINE_ENABLE_RIGHT=0;     
  }else{
  ENGINE_ENABLE_RIGHT=1;}    
}






void main(void)
{
// Ports initialisieren
port_init();
//Other inits
i2c_init();
wii_cam_init();
twiinit();

while (1)
      {          
      STATE_MACHINE(); 
      esp_states();      
      
      ondata();   
      esp_mainfunctions();
      


      }
}