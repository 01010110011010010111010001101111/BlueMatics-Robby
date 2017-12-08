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




//Verkürzung von lcd_puts
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
#define state_stop 17

#include "modules/variables.h"
#include "modules/port_init.h"
#include "modules/servo_ir.h"
#include "modules/esp_main_func.h"
#include "modules/wiicam.h"
#include "modules/ultrasonic.h"
#include "modules/states/states.h"
#include "modules/esp.h"






  


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