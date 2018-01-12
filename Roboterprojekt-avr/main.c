/*******************************************************
This program was created by the
CodeWizardAVR V3.17 UL Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : BlueMatics
Version : 0.0.9
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
//state_0 = state_stop
#define state_1  13
#define state_2  14
#define state_3  15
#define state_4  16
#define state_5  17
#define state_6  18
#define state_7  19
#define state_8  20
#define state_90links  22
#define state_90rechts  23
#define state_stop 27

#include "modules/variables.h"
#include "modules/port_init.h"
#include "modules/pwm.h"
#include "modules/ir.h"
#include "modules/servo.h"
#include "modules/esp_main_func.h"
#include "modules/wiicam.h"
#include "modules/ultrasonic.h"
#include "modules/states/states.h"
#include "modules/esp.h"









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
if(LINE_DETECTOR_LEFT_ADC>500){LINE_DETECTOR_LEFT=1;}else{LINE_DETECTOR_LEFT=0;};
if(LINE_DETECTOR_MID_LEFT_ADC>500){LINE_DETECTOR_MID_LEFT=1;}else{LINE_DETECTOR_MID_LEFT=0;};      
if(LINE_DETECTOR_MID_RIGHT_ADC>500){LINE_DETECTOR_MID_RIGHT=1;}else{LINE_DETECTOR_MID_RIGHT=0;};      
if(LINE_DETECTOR_RIGHT_ADC>500){LINE_DETECTOR_RIGHT=1;}else{LINE_DETECTOR_RIGHT=0;};      

  
      fnServo();
      STATE_MACHINE();      //DEFAULT_STATE_MACHINE
      esp_states();         //ESP_STATE_MACHINE
      esp_mainfunctions();  //ESP_MAIN_FUNCTIONS
      ondata();             //IR_DATA_FUNCTION 
     
   }
}