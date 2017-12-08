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
                    itoa( x[iWII]-512, Wert);  //konvertiert die int-Ausgabe des Empfängers in char-Array   
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
 
  
  /////1m VORWÄRTS
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
 
  /////1m VORWÄRTS
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