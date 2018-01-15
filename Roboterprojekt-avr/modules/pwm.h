    long newvalL;
    long newvalR;  
    
    int tmr_line;
    int val_L_linesearch;

// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
  // Reinitialize Timer 1 value
  TCNT1L=0x9C;  
  
//PWM für die Motoren  
  ipwmcounter++; 
  if (ipwmcounter>100)
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
  
//Eine Spirale fahren, damit die Leitlinie gefunden wird
    if (tmr_line<3000){
  tmr_line++;}else{ 
  if(val_L_linesearch<30&&val_L_linesearch>0){
   val_L_linesearch++;
   tmr_line=0;
  }else{
   val_L_linesearch=1;
   tmr_line=0;
  }}
   
//Damit der Roboter im Verfolgungsmodus nicht stockt, wird die Geschwindigkeit langsam reduziert.
if(Wiipwmleft>0||Wiipwmright>0){
 if (tmr_wiipwm<200){
  tmr_wiipwm++;}else{ 
   Wiipwmleft--;  
   Wiipwmright--;
   tmr_wiipwm=0;
  }}else{
   Wiipwmleft=0;
   Wiipwmright=0;
   tmr_wiipwm=0;
  }
  
      
}



//Funktion fürs Fahren
//Man übergibt mit den ersten beiden Argumenten die Geschwindigkeit für den jeweiligen Motor.
//Mit den letzten beiden Argumenten übergibt man die Drehrichtung der Motoren.
  void movement(int left, int right, int dir_left, int dir_right){
  ipwmcompareleft=left; 
  ipwmcompareright=right; 
  ENGINE_DIRECTION_LEFT = dir_left;  
  ENGINE_DIRECTION_RIGHT = dir_right;
  }
  
  
