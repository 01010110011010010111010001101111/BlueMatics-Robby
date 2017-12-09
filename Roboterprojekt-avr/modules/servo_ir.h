  //////////////SERVO/////////////    
  
  interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{   
     SERVO = 0;
     
     if(servo_value_cur != servo_value_copy || servo_breaks == 5){
         servo_value_copy = servo_value_cur;
         servo_breaks = 1;
         TCNT2 = servo_value_cur;
         SERVO = 1; 
 
     }                       
     else{
        servo_breaks++;
        TCNT2 = 0x00;
     }    
}
  

//Zeigt die Position des Servos
void fnDisplay(void )
{
 char str[10];
  lcd_clear();  
  lcd_puts("POSITION-SERVO");      
  lcd_gotoxy(0, 1);
  itoa(servo_value_cur, strTemp);
  lcd_puts(strTemp);  
}
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
 
  //IR RECIVER
  TCNT0 = 254;                                    // 2 * 256 = 512 cycle
  if( ++rc5_time > PULSE_MAX )                  // count pulse time
  {            
    if( !(tmp & 0x4000) && (tmp & 0x2000) )        // only if 14 bits received
      rc5_data = tmp;
      tmp = 0;
  }
  if (rc5_bit != REMOTE_CONTROL)                       // change detect
  {     
      rc5_bit = !rc5_bit;                        // 0x00 -> 0xFF -> 0x00
      if( rc5_time < PULSE_MIN )                // too short
      tmp = 0;
    if( !tmp || rc5_time > PULSE_1_2 )          // start or long pulse time
    {    
      if( !(tmp & 0x4000) )                        // not to many bits
      tmp = tmp << 1;                            // shift
      if(!rc5_bit)                                // inverted bit
      tmp = tmp | 1;                            // insert new bit
      rc5_time = 0;                                // count next pulse time
    }
  }
  
 } 
  
  
                                   




  //////////////IR RECEIVER///////////// 
                 
int rc5_receive(unsigned char *ucToggle, unsigned char *ucAdress, unsigned char *ucData)
{
  unsigned int i;
    
  #asm("cli")
  i = rc5_data;                                // read two bytes from interrupt !
  rc5_data = 0;
  #asm("sei")  
  if( i )
  {               
    *ucToggle = i >> 11 & 1;
    *ucAdress = i >> 6 & 0x1F; 
    *ucData = (i & 0x3F) | (~i >> 7 & 0x40);    
    return i;
  }   
  else
    return 0;
}  



  //////////////IR RECEIVER/////////////
void rc5_display(void)
{ lcd_clear();
  lcd_puts("DATA");
  lcd_gotoxy(0,1);
  lcd_putchar('0'+ucToggle);	            // Toggle Bit
  lcd_putchar(' ');
  itoa(ucAdress , s);	                    // Device address
  lcd_puts(s);
  lcd_putchar(' ');
  itoa(ucData, s);                          // Key Code
  lcd_puts(s);   
}



  
  
                   