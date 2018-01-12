
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{ 
/*
        SERVO=0; 
  static int counter=0;
  static int mode=0;  
    if(mode==0){
        if (++counter>=150){
        SERVO=0;
        TCCR2=0x04;
        counter=0;
        mode=1;
        }
    }else{
        SERVO=1; 
        TCCR2=0x01; 
        mode=0;
    }
    
   */
     SERVO=0; 
     if(servo_value_cur != servo_value_copy || servo_breaks == 50){
         servo_value_copy = servo_value_cur;
         servo_breaks = 1;
         TCNT2 = servo_value_cur;
         SERVO = 1;
     }                       
     else{
        servo_breaks+=2;
        TCNT2 = 0x00;
     } 
  
}
//show position of servo
void fnDisplay(void )
{
 char str[10];
  lcd_clear();  
  lcd_puts("POSITION-SERVO");      
  lcd_gotoxy(0, 1);
  itoa(servo_value_cur, strTemp);
  lcd_puts(strTemp);  
}

void fnServo(){
if (state==24)if (servo_value_cur<220)servo_value_cur+=1;
if (state==25)if (servo_value_cur>120)servo_value_cur-=1;
}