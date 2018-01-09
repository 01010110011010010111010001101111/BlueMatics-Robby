#include "modules/states/teststates.h"
#include "modules/states/dpadstates.h"
#include "modules/states/spec_states/detector.h"
#include "modules/states/spec_states/state1.h"
#include "modules/states/spec_states/state2.h"
#include "modules/states/spec_states/state3.h"
#include "modules/states/spec_states/state4.h"
#include "modules/states/spec_states/state5.h"
#include "modules/states/spec_states/state6.h"
#include "modules/states/spec_states/state7.h"
#include "modules/states/spec_states/state8.h"




void STATE_MACHINE(){
      //0-255
      ipwmcompareleft=0; 
      ipwmcompareright=0; 
       switch(state){
       case state_linedetector:  
              if(state_info == 0){ 
                state_info = 1;
                }
              STATE_LINE_SENSOR();
       break; 
       
       case state_engine:         
              if(state_info == 0){
                state_info = 1;
                }
              STATE_ENGINE();
       break;
                  
       case state_engine_dir:         
              if(state_info == 0){  
                state_info = 1;
                }
              STATE_ENGINE_DIR();
       break;
       
       case state_distance_sensor: 
              if(state_info == 0){  
                state_info = 1;
                }
              STATE_DISTANCE_SENSOR();     
       break;

       case state_lightsensor: 
              if(state_info == 0){
                  state_info = 1;
                }
              STATE_LIGHTSENSOR();
       break;

       case state_wiicam:
                if(state_info == 0){    
                state_info = 1;
                }
              STATE_WIICAM();
       break;     
       
       case state_irtower:
                if(state_info == 0){   
                state_info = 1;
                }
              STATE_IRTOWER();
       break;    
       
       case state_servo:
                if(state_info == 0){
                state_info = 1;
                }
              STATE_SERVO();
       break;       
       
       case state_ultrasonic:
                if(state_info == 0){   
                state_info = 1;
                }
              STATE_ULTRASONIC();
       break;    
       
              case state_vor:
                if(state_info == 0){   
                state_info = 1;
                }
              STATE_VOR();
       break;    
              case state_zur:
                if(state_info == 0){   
                state_info = 1;
                }
              STATE_ZUR();
       break;    
              case state_links:
                if(state_info == 0){   
                state_info = 1;
                }
              STATE_LINKS();
       break;   
       
              case state_rechts:
                if(state_info == 0){   
                state_info = 1;
                }
              STATE_RECHTS();
       break;          

              case state_90links:
                if(state_info == 0){   
                state_info = 1;
                }
              STATE_90LINKS();
       break;   
       
              case state_90rechts:
                if(state_info == 0){   
                state_info = 1;
                }
              STATE_90RECHTS();
       break;     

              case state_1:
                if(state_info == 0){   
                state_info = 1;
                }
              STATE_1();
       break;    
       
              case state_2:
                if(state_info == 0){   
                state_info = 1;
                }
              STATE_2();
             

       break;      
           
              case state_3:
                if(state_info == 0){   
                state_info = 1;
                }
              STATE_3();
             

       break; 
              case state_4:
                if(state_info == 0){   
                state_info = 1;
                }
              STATE_4(); 
              
       break; 
              case state_5:
                if(state_info == 0){   
                state_info = 1;
                }
              STATE_5();
       break;   
       
              case state_6:
                if(state_info == 0){   
                state_info = 1;
                }
              STATE_6();
       break; 
       
              case state_7:
                if(state_info == 0){   
                state_info = 1;
                }
              STATE_7();
       break;  
       
              case state_8:
                if(state_info == 0){   
                state_info = 1;
                }
              STATE_8();
       break; 
       

       default:  
       
           lcd_clear();
           lcd_puts("   BlueMatics"); 
           lcd_gotoxy(0,1);
           lcd_puts("     Robby");   
        
      }                              
       delay_ms(50);
}