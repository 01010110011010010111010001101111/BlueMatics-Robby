


// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
  // Reinitialize Timer 1 value
  TCNT1L=0x9C;
  ipwmcounter++; 
  if (ipwmcounter>255)
    ipwmcounter=0;  
 if(ipwmcounter >= ipwmcompareleft){
 ENGINE_ENABLE_LEFT=0;  
  }else{
  ENGINE_ENABLE_LEFT=1;
  }        
 if(ipwmcounter >= ipwmcompareright){
 ENGINE_ENABLE_RIGHT=0;     
  }else{
  ENGINE_ENABLE_RIGHT=1;}    
}