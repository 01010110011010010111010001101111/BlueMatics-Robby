  
   /////////////////////////// 
 
  void STATE_1(){
  //wheelEncoderCounter_left=0;
  //wheelEncoderCounter_right=0; 
  do{
      //0-255
      ipwmcompareleft=100; 
      ipwmcompareright=100; 
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