
//ULTRASONIC
char strULTRA[17];
unsigned int iRisingEdge, iFallingEdge;
unsigned int iTime;
    bit bChange2=0;

/* union declaration */
union alpha 
{
  unsigned char byte[2];
  unsigned int  word;
} icr3;




  //////////////ULTRASONIC/////////////
// Timer3 input capture interrupt service routine
interrupt [TIM3_CAPT] void timer3_capt_isr(void)
{
  icr3.byte[0] = ICR3L;
  icr3.byte[1] = ICR3H;
  if (ECHO)
  { 
    // Rising Edge of ECHO
    iRisingEdge = icr3.word;
    // Capture next Input on falling edge
    TCCR3B &= ~(1<<ICES3);    
  }
  else
  {        
    // Faling Edge of ECHO        
    iFallingEdge = icr3.word;
     // Capture next Input on rising edge
    TCCR3B |= (1<<ICES3);           
    // Calculate length of ECHO (time per count is 4 us)
    iTime = (iFallingEdge-iRisingEdge)*4;
    bChange2 = 1;    
  }
}
// Timer3 output compare A interrupt service routine
interrupt [TIM3_COMPA] void timer3_compa_isr(void)
{
  // Trigger is fired every 100 ms
  TRIGGER = 1;
  delay_us(10); 
  TRIGGER = 0; 
}
