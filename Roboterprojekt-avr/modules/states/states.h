#include "modules/states/teststates.h"
#include "modules/states/dpadstates.h"
#include "modules/states/spec_states/detector.h"
#include "modules/states/spec_states/state1.h"
#include "modules/states/spec_states/state2.h"
#include "modules/states/spec_states/state3.h"




void STATE_MACHINE(){
      //0-255
      ipwmcompareleft=0; 
      ipwmcompareright=0; 
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
                lcd_puts("     ENGINE    ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_ENGINE();
       break;
                  
       case state_engine_dir:         
              if(state_info == 0){  
                lcd_clear();
                lcd_puts("     STEERING    ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_ENGINE_DIR();
       break;
       
       case state_distance_sensor: 
              if(state_info == 0){  
                lcd_clear();  
                lcd_puts(" DISTANCESENSOR ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_DISTANCE_SENSOR();     
       break;

       case state_lightsensor: 
              if(state_info == 0){
                  lcd_clear();
                  lcd_puts("  LIGHT SENSOR  ");
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
                lcd_puts("   ULTRASONIC  ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_ULTRASONIC();
       break;    
       
              case state_vor:
                if(state_info == 0){   
                lcd_clear();
                lcd_puts("     FOR       ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_VOR();
       break;    
              case state_zur:
                if(state_info == 0){   
                lcd_clear();
                lcd_puts("      BACK       ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_ZUR();
       break;    
              case state_links:
                if(state_info == 0){   
                lcd_clear();
                lcd_puts("      LEFT      ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_LINKS();
       break;   
       
              case state_rechts:
                if(state_info == 0){   
                lcd_clear();
                lcd_puts("     RIGHT     ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_RECHTS();
       break;          

              case state_90links:
                if(state_info == 0){   
                lcd_clear();
                lcd_puts("     90�LEFT     ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_90LINKS();
       break;   
       
              case state_90rechts:
                if(state_info == 0){   
                lcd_clear();
                lcd_puts("    90�RIGHT    ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_90RECHTS();
       break;     

              case state_drehung:
                if(state_info == 0){   
                lcd_clear();
                lcd_puts("    SPIN    ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_DREHUNG();
       break;    
       
              case state_meterlinksmeterrechts:
                if(state_info == 0){   
                lcd_clear();
                lcd_puts("    1st STATE    ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_METERLINKSMETERRECHTS();
             

       break;      
           
              case state_2:
                if(state_info == 0){   
                lcd_clear();
                lcd_puts("    2nd STATE    ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_3();
             

       break; 
              case state_3:
                if(state_info == 0){   
                lcd_clear();
                lcd_puts("    3rd STATE    ");
                delay_ms(1000);
                lcd_clear();
                state_info = 1;
                }
              STATE_3();
             

       break;  
       default: 
           lcd_clear();
           lcd_puts("   BlueMatics"); 
           lcd_gotoxy(0,1);
           lcd_puts("     Robby");  
      }                                
       delay_ms(50);
}