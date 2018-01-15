//States mit PWM-Ausgleich
  void STATE_VOR(){
    wheelEncoderCounter_left=2;
    wheelEncoderCounter_right=0;  
         if(wheelEncoderCounter_right==wheelEncoderCounter_left){
             movement(100,100,0,0);
         }     
         if(wheelEncoderCounter_right<wheelEncoderCounter_left){
             movement(100,80,0,0);
         } 
         if(wheelEncoderCounter_right>wheelEncoderCounter_left){
             movement(80,100,0,0);
         }
  }    
    /////////////////////////// 
 
  void STATE_ZUR(){
    wheelEncoderCounter_left=2;
    wheelEncoderCounter_right=0;  
         if(wheelEncoderCounter_right==wheelEncoderCounter_left){
             movement(100,100,1,1);
         }     
         if(wheelEncoderCounter_right<wheelEncoderCounter_left){
             movement(100,80,1,1);
         } 
         if(wheelEncoderCounter_right>wheelEncoderCounter_left){
             movement(80,100,1,1);
         }   
  }  
    /////////////////////////// 
 
  void STATE_LINKS(){
        //movement(0,100,1,0);
        movement(0,100,0,0);
  }  
    /////////////////////////// 
 
  void STATE_RECHTS(){
        //movement(100,100,0,0);
        movement(100,0,0,0);
  }       
    /////////////////////////// 
 
 
 
 
  void STATE_90RECHTS(){
  wheelEncoderCounter_left=0;
  wheelEncoderCounter_right=0; 
  do{
      //0-255
      ipwmcompareleft=0; 
      ipwmcompareright=100;  
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
      //0-255
      ipwmcompareleft=100; 
      ipwmcompareright=0;
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