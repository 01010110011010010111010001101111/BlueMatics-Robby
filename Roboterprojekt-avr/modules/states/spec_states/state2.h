   /////////////////////////// 

  int wheelEncoderCounter_left_comp=0;  
  int wheelEncoderCounter_right_comp=0;

  void  STATE_2(){

  wheelEncoderCounter_left=4;
  wheelEncoderCounter_right=5; 
  

  
  lcd_clear(); 
  lcd_gotoxy(0,0);
  puts("L state");  
  puts(" 1");
  
 //forward 
  do{
         if(wheelEncoderCounter_right==wheelEncoderCounter_left){
             movement(60,60,0,0);
         }     
         if(wheelEncoderCounter_right<wheelEncoderCounter_left){
             movement(70,60,0,0);
         } 
         if(wheelEncoderCounter_right>wheelEncoderCounter_left){
             movement(60,70,0,0);
         }
         lcd_gotoxy(0,1); 
         puts("L:");
         itoa(wheelEncoderCounter_left,str);
         puts(str);
         puts(" R:");
         itoa(wheelEncoderCounter_right,str);
         puts(str);
  }while ((wheelEncoderCounter_right<205)&(wheelEncoderCounter_right>-1)); 
  movement(0,0,0,0);     
  delay_ms(1500);  
  wheelEncoderCounter_right_comp =  wheelEncoderCounter_right;  
 
   lcd_clear(); 
  lcd_gotoxy(0,0);
  puts("L state");  
  puts(" 2");
 //90�left 
  do{
  movement(50,50,0,1);
         lcd_gotoxy(0,1); 
         puts("L:");
         itoa(wheelEncoderCounter_left,str);
         puts(str);
         puts(" R:");
         itoa(wheelEncoderCounter_right,str);
         puts(str);
  }while (wheelEncoderCounter_right<(wheelEncoderCounter_right_comp+13));   
  movement(0,0,0,0);  
  delay_ms(1500);
  wheelEncoderCounter_right_comp =  wheelEncoderCounter_right;  
  
    lcd_clear(); 
  lcd_gotoxy(0,0);
  puts("L state");  
  puts(" 3");
   //forward 
  do{
         if(wheelEncoderCounter_right==wheelEncoderCounter_left){
             movement(60,60,0,0);
         }     
         if(wheelEncoderCounter_right<wheelEncoderCounter_left){
             movement(70,60,0,0);
         } 
         if(wheelEncoderCounter_right>wheelEncoderCounter_left){
             movement(60,70,0,0);
         }
         lcd_gotoxy(0,1); 
         puts("L:");
         itoa(wheelEncoderCounter_left,str);
         puts(str);
         puts(" R:");
         itoa(wheelEncoderCounter_right,str);
         puts(str);
  }while (wheelEncoderCounter_right<wheelEncoderCounter_right_comp+205);   
  movement(0,0,0,0);     
  delay_ms(1500); 
  wheelEncoderCounter_right_comp =  wheelEncoderCounter_right;  

  lcd_clear(); 
  lcd_gotoxy(0,0);
  puts("L state");  
  puts(" 4"); 
 //180�left 
  do{
  movement(50,50,0,1);
         lcd_gotoxy(0,1); 
         puts("L:");
         itoa(wheelEncoderCounter_left,str);
         puts(str);
         puts(" R:");
         itoa(wheelEncoderCounter_right,str);
         puts(str);
  }while (wheelEncoderCounter_right<wheelEncoderCounter_right_comp+30);   
  movement(0,0,0,0);  
  delay_ms(1500); 
  wheelEncoderCounter_right_comp =  wheelEncoderCounter_right;  
  
    lcd_clear(); 
  lcd_gotoxy(0,0);
  puts("L state");  
  puts(" 5");      
   //forward 
  do{
         if(wheelEncoderCounter_right==wheelEncoderCounter_left){
             movement(60,60,0,0);
         }     
         if(wheelEncoderCounter_right<wheelEncoderCounter_left){
             movement(70,60,0,0);
         } 
         if(wheelEncoderCounter_right>wheelEncoderCounter_left){
             movement(60,70,0,0);
         }
         lcd_gotoxy(0,1); 
         puts("L:");
         itoa(wheelEncoderCounter_left,str);
         puts(str);
         puts(" R:");
         itoa(wheelEncoderCounter_right,str);
         puts(str);
  }while (wheelEncoderCounter_right<wheelEncoderCounter_right_comp+205);   
  movement(0,0,0,0);     
  delay_ms(1500);  
    wheelEncoderCounter_right_comp =  wheelEncoderCounter_right;  

  lcd_clear(); 
  lcd_gotoxy(0,0);
  puts("L state");  
  puts(" 6");
   //90�right
  do{
  movement(50,50,1,0);
         lcd_gotoxy(0,1); 
         puts("L:");
         itoa(wheelEncoderCounter_left,str);
         puts(str);
         puts(" R:");
         itoa(wheelEncoderCounter_right,str);
         puts(str);
  }while (wheelEncoderCounter_right>wheelEncoderCounter_right_comp-13);   
  movement(0,0,0,0);  
  delay_ms(1500); 
  wheelEncoderCounter_right_comp =  wheelEncoderCounter_right;  

  lcd_clear(); 
  lcd_gotoxy(0,0);
  puts("L state");  
  puts(" 7");
     //forward 
  do{
         if(wheelEncoderCounter_right==wheelEncoderCounter_left){
             movement(60,60,0,0);
         }     
         if(wheelEncoderCounter_right<wheelEncoderCounter_left){
             movement(70,60,0,0);
         } 
         if(wheelEncoderCounter_right>wheelEncoderCounter_left){
             movement(60,70,0,0);
         }
         lcd_gotoxy(0,1); 
         puts("L:");
         itoa(wheelEncoderCounter_left,str);
         puts(str);
         puts(" R:");
         itoa(wheelEncoderCounter_right,str);
         puts(str);
  }while (wheelEncoderCounter_right<wheelEncoderCounter_right_comp+205);   
  movement(0,0,0,0);     
  wheelEncoderCounter_left=0;
  wheelEncoderCounter_right=0; 
  delay_ms(1500);       

  } 
 