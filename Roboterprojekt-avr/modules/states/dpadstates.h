 
  void STATE_VOR(){ 
 // radkorrektur();
      //0-255
      ipwmcompareleft=100; 
      ipwmcompareright=100; 
  ENGINE_DIRECTION_LEFT = 0;  
  ENGINE_DIRECTION_RIGHT = 0;
  }    
    /////////////////////////// 
 
  void STATE_ZUR(){
      //0-255
      ipwmcompareleft=100; 
      ipwmcompareright=100;
  ENGINE_DIRECTION_LEFT = 1;  
  ENGINE_DIRECTION_RIGHT = 1;   
  }  
    /////////////////////////// 
 
  void STATE_LINKS(){
      //0-255
      ipwmcompareleft=0; 
      ipwmcompareright=100;
  ENGINE_DIRECTION_LEFT = 0;  
  ENGINE_DIRECTION_RIGHT = 0;
  }  
    /////////////////////////// 
 
  void STATE_RECHTS(){
      //0-255
      ipwmcompareleft=100; 
      ipwmcompareright=0; 
  ENGINE_DIRECTION_LEFT = 0;  
  ENGINE_DIRECTION_RIGHT = 0;
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