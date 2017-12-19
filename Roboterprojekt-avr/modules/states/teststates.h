void STATE_LINE_SENSOR(){
   lcd_clear();   
   if(!LINE_DETECTOR_LEFT)lcd_puts("LEFT: 1");
   else  lcd_puts("LEFT: 0");
   if(!LINE_DETECTOR_RIGHT)lcd_puts(" RIGHT: 1");
   else  lcd_puts(" RIGHT: 0");
   lcd_gotoxy(0,1);
   if(!LINE_DETECTOR_MID_LEFT)lcd_puts("MLEFT: 1");
   else  lcd_puts("MLEFT: 0");
   if(!LINE_DETECTOR_MID_RIGHT)lcd_puts("MRIGHT:1");
   else  lcd_puts("MRIGHT:0");       
 }
 
  /////////////////////////// 
 
  void STATE_ENGINE(){
 char str[17];
      //0-255
      ipwmcompareleft=100; 
      ipwmcompareright=100;  
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
      //0-255
      ipwmcompareleft=100; 
      ipwmcompareright=100;
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
   if(!DISTANCE_SENSOR_LEFT)lcd_puts("LEFT: 1");
   else  lcd_puts("LEFT: 0");
   if(!DISTANCE_SENSOR_RIGHT)lcd_puts(" RIGHT: 1");
   else  lcd_puts(" RIGHT: 0");
   lcd_gotoxy(0,1);
   if(!DISTANCE_SENSOR_FRONT_LEFT)lcd_puts("FLEFT: 1");
   else  lcd_puts("FLEFT: 0");
   if(!DISTANCE_SENSOR_FRONT_RIGHT)lcd_puts("FRIGHT:1");
   else  lcd_puts("FRIGHT:0");       
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