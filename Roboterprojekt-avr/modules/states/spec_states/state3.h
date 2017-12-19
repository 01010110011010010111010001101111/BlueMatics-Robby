
   /////////////////////////// 
        

   
   
  void STATE_3(){
  wheelEncoderCounter_left=0;
  wheelEncoderCounter_right=0; 
  do{
      //0-255
      ipwmcompareleft=100; 
      ipwmcompareright=100; 
  ENGINE_DIRECTION_LEFT = 0;  
  ENGINE_DIRECTION_RIGHT = 0;  



  }while (wheelEncoderCounter_left<64&&wheelEncoderCounter_right<64);
  } 