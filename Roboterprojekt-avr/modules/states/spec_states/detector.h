  
//Detector

  /////////////////////////// 
  void movement(int left, int right, int dir_left, int dir_right){
  ipwmcompareleft=left; 
  ipwmcompareright=right; 
  ENGINE_DIRECTION_LEFT = dir_left;  
  ENGINE_DIRECTION_RIGHT = dir_right;
  }


int detector_value;
int detector_value_line;
int tmr_line=0;
int val_R_linesearch=0;
 
  void detector(){   
  if (      BUMPER_LEFT&&  BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=0;        
  if (      BUMPER_LEFT&&  BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=1;            
  if (      BUMPER_LEFT&&  BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=2;          
  if (      BUMPER_LEFT&&  BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=3;      
  if (      BUMPER_LEFT&&  BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=4;     
  if (      BUMPER_LEFT&& !BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=5;     
  if (     !BUMPER_LEFT&&  BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=6;    
  if (      BUMPER_LEFT&&  BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=7;      
  if (      BUMPER_LEFT&&  BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=8; 
  if (      BUMPER_LEFT&&  BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=9;  
  if (      BUMPER_LEFT&& !BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=10;           
  if (     !BUMPER_LEFT&& !BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=11;     
  if (      BUMPER_LEFT&&  BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=12;                            
  if (      BUMPER_LEFT&&  BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=13;      
  if (      BUMPER_LEFT&& !BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=14;       
  if (     !BUMPER_LEFT&& !BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=15;   
  if (      BUMPER_LEFT&&  BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=16;   
  if (      BUMPER_LEFT&& !BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=17;          
  if (     !BUMPER_LEFT&& !BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=18;   
  if (      BUMPER_LEFT&& !BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=19;   
  if (     !BUMPER_LEFT&& !BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=20;    
  if (     !BUMPER_LEFT&& !BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=21;        
  if (      BUMPER_LEFT&&  BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=22;            
  if (      BUMPER_LEFT&&  BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=23;          
  if (      BUMPER_LEFT&& !BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=24;      
  if (     !BUMPER_LEFT&&  BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=25;     
  if (      BUMPER_LEFT&&  BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=26;     
  if (      BUMPER_LEFT&& !BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=27;    
  if (     !BUMPER_LEFT&&  BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=28;      
  if (      BUMPER_LEFT&& !BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=29; 
  if (     !BUMPER_LEFT&&  BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=30;  
  if (     !BUMPER_LEFT&&  BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=31;           
  if (     !BUMPER_LEFT&& !BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=32;     
  if (     !BUMPER_LEFT&& !BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=33;                            
  if (     !BUMPER_LEFT&& !BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=34;      
  if (     !BUMPER_LEFT&&  BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=35;       
  if (     !BUMPER_LEFT&& !BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=36;   
  if (     !BUMPER_LEFT&& !BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=37;   
  if (     !BUMPER_LEFT&&  BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=38;          
  if (     !BUMPER_LEFT&&  BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=39;   
  if (      BUMPER_LEFT&& !BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=40;   
  if (     !BUMPER_LEFT&&  BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=41;   
  if (      BUMPER_LEFT&& !BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=42;          
  if (     !BUMPER_LEFT&& !BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=43;      
  if (     !BUMPER_LEFT&& !BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=44;     
  if (     !BUMPER_LEFT&&  BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=45;     
  if (     !BUMPER_LEFT&&  BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=46;    
  if (      BUMPER_LEFT&& !BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=47;      
  if (      BUMPER_LEFT&& !BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=48; 
  if (     !BUMPER_LEFT&& !BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=49;  
  if (      BUMPER_LEFT&& !BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=50;           
  if (     !BUMPER_LEFT&& !BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=51;     
  if (     !BUMPER_LEFT&& !BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=52;                            
  if (     !BUMPER_LEFT&& !BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=53;      
  if (      BUMPER_LEFT&&  BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=54;       
  if (     !BUMPER_LEFT&&  BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=55;   
  if (     !BUMPER_LEFT&&  BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=56;   
  if (      BUMPER_LEFT&&  BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=57;          
  if (      BUMPER_LEFT&& !BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=58;   
  if (      BUMPER_LEFT&& !BUMPER_RIGHT&&  DISTANCE_SENSOR_LEFT&&  DISTANCE_SENSOR_RIGHT&& !DISTANCE_SENSOR_FRONT_LEFT&& !DISTANCE_SENSOR_FRONT_RIGHT)detector_value=59;   
  if (     !BUMPER_LEFT&&  BUMPER_RIGHT&& !DISTANCE_SENSOR_LEFT&& !DISTANCE_SENSOR_RIGHT&&  DISTANCE_SENSOR_FRONT_LEFT&&  DISTANCE_SENSOR_FRONT_RIGHT)detector_value=60;        
        
  if (     (iTime/52.2)<10)detector_value=64;        
  
  } 
  
  
void line_detector(){

  if (      LINE_DETECTOR_LEFT&&  LINE_DETECTOR_MID_LEFT&&  LINE_DETECTOR_MID_RIGHT&&  LINE_DETECTOR_RIGHT)detector_value_line=0;     
  if (     !LINE_DETECTOR_LEFT&& !LINE_DETECTOR_MID_LEFT&& !LINE_DETECTOR_MID_RIGHT&& !LINE_DETECTOR_RIGHT)detector_value_line=1;  
  if (     !LINE_DETECTOR_LEFT&&  LINE_DETECTOR_MID_LEFT&&  LINE_DETECTOR_MID_RIGHT&&  LINE_DETECTOR_RIGHT)detector_value_line=2;  
  if (     !LINE_DETECTOR_LEFT&& !LINE_DETECTOR_MID_LEFT&&  LINE_DETECTOR_MID_RIGHT&&  LINE_DETECTOR_RIGHT)detector_value_line=3;  
  if (     !LINE_DETECTOR_LEFT&& !LINE_DETECTOR_MID_LEFT&& !LINE_DETECTOR_MID_RIGHT&&  LINE_DETECTOR_RIGHT)detector_value_line=4;  
  if (      LINE_DETECTOR_LEFT&&  LINE_DETECTOR_MID_LEFT&&  LINE_DETECTOR_MID_RIGHT&& !LINE_DETECTOR_RIGHT)detector_value_line=5;  
  if (      LINE_DETECTOR_LEFT&&  LINE_DETECTOR_MID_LEFT&& !LINE_DETECTOR_MID_RIGHT&& !LINE_DETECTOR_RIGHT)detector_value_line=6;     
  if (      LINE_DETECTOR_LEFT&& !LINE_DETECTOR_MID_LEFT&& !LINE_DETECTOR_MID_RIGHT&& !LINE_DETECTOR_RIGHT)detector_value_line=7; 
  if (     !LINE_DETECTOR_LEFT&&  LINE_DETECTOR_MID_LEFT&&  LINE_DETECTOR_MID_RIGHT&& !LINE_DETECTOR_RIGHT)detector_value_line=8; 
  if (      LINE_DETECTOR_LEFT&& !LINE_DETECTOR_MID_LEFT&& !LINE_DETECTOR_MID_RIGHT&&  LINE_DETECTOR_RIGHT)detector_value_line=9; 

}  
  
void detectorcase_line(){

  if (tmr_line<10000){
  tmr_line++;}else{
   val_R_linesearch++;
   tmr_line=0;
  }
  
  
    switch (detector_value_line){
   case 0:  
    //detected a line on all sensors 
    //Robby is driving slowly to the left
     movement(0,65,0,0); 
   break; 
    
   case 1:   
    //nothing detected
    //Robby is driving a spiral (right)
     movement(80,val_R_linesearch,0,0); 
   break;   

   case 2:  
   //detected a line on right, midright and midleft sensor
   //Robby is driving to the left 
     movement(60,80,0,0);
   break;   
   
   case 3:   
    //detected a line on right and midright sensor 
    //Robby is driving slowly to the right
     movement(70,60,0,0);
   break;   

   case 4:  
    //detected a line on right sensor 
    //Robby is driving slowly right 
     movement(70,60,0,0);
   break;      

   case 5:  
    //detected a line on left, midleft and midright sensor 
    //Robby is driving slowly to the left
     movement(60,70,0,0);
   break;  
 
   case 6:  
    //detected a line on left and midleft sensor 
    //Robby is driving slowly to the left
     movement(60,70,0,0);
   break;  
   
   case 7:  
    //detected a line on left sensor 
    //Robby is driving slowly left
     movement(65,75,0,0);
   break;  
   
   case 8:  
    //detected a line on midleft and midright sensor 
    //Robby is driving slowly
     movement(70,70,0,0);
   break;      
   
   case 9:  
    //detected a line on left and right sensor 
    //Robby is driving slowly to the left
     movement(65,72,0,0);
   break;     
  }  

}  
  
  void detectorcase(){
  
    switch (detector_value){
   case 0:  
    //nothing detected 
     movement(100,100,0,0);  
   break; 
    
   case 1:   
    //DISTANCE_SENSOR_FRONT_RIGHT
     movement(100,70,1,1);
   break;   

   case 2:  
   //DISTANCE_SENSOR_FRONT_LEFT
     movement(70,100,1,1);
   break;   
   
   case 3:   
    //DISTANCE_SENSOR_RIGHT
     movement(70,100,0,0);
   break;   

   case 4:  
   //DISTANCE_SENSOR_LEFT
     movement(100,70,0,0);
   break;      

   case 5:  
   //BUMPER_RIGHT
     movement(100,70,1,1);
   break;  
 
   case 6:  
   //BUMPER_LEFT
     movement(70,100,1,1);
   break;  
   
   case 7:  
   //DISTANCE_SENSOR_FRONT_RIGHT & DISTANCE_SENSOR_FRONT_LEFT
     movement(50,100,1,1);
   break;  
   
   case 8:  
   //DISTANCE_SENSOR_FRONT_LEFT & DISTANCE_SENSOR_RIGHT
     movement(100,70,1,1);
   break;  
    
   case 9:  
   //DISTANCE_SENSOR_LEFT & DISTANCE_SENSOR_RIGHT
     movement(80,80,0,0);
   break;  
  
   case 10:  
   //BUMPER_RIGHT & DISTANCE_SENSOR_LEFT
     movement(100,70,1,1);
   break;   
   
   case 11:  
   //BUMPER_RIGHT & BUMPER_LEFT
     movement(100,70,1,1);
   break; 
   
   case 12:  
   //DISTANCE_SENSOR_FRONT_RIGHT & DISTANCE_SENSOR_FRONT_LEFT & DISTANCE_SENSOR_RIGHT
     movement(100,50,1,1);
   break; 
   
   case 13:  
   //DISTANCE_SENSOR_FRONT_LEFT & DISTANCE_SENSOR_RIGHT & DISTANCE_SENSOR_LEFT
     movement(50,100,1,1);
   break;  
   
   case 14:  
   //DISTANCE_SENSOR_RIGHT & DISTANCE_SENSOR_LEFT & BUMPER_RIGHT
     movement(100,80,1,1);
   break;  
   
   case 15:  
   //DISTANCE_SENSOR_LEFT & BUMPER_RIGHT & BUMPER_LEFT
     movement(80,100,1,1);
   break;  
   
   case 16:  
   //DISTANCE_SENSOR_FRONT_RIGHT & DISTANCE_SENSOR_FRONT_LEFT & DISTANCE_SENSOR_RIGHT & DISTANCE_SENSOR_LEFT
     movement(90,100,1,1);
   break;  
   
   case 17:  
   //DISTANCE_SENSOR_FRONT_LEFT & DISTANCE_SENSOR_RIGHT & DISTANCE_SENSOR_LEFT & BUMPER_RIGHT
     movement(90,100,1,1);
   break;  
   
   case 18:  
   //DISTANCE_SENSOR_RIGHT & DISTANCE_SENSOR_LEFT & BUMPER_RIGHT & BUMPER_LEFT
     movement(90,100,1,1);
   break;   
   
   case 19:  
   //DISTANCE_SENSOR_FRONT_RIGHT & DISTANCE_SENSOR_FRONT_LEFT & DISTANCE_SENSOR_RIGHT & DISTANCE_SENSOR_LEFT & BUMPER_RIGHT
     movement(70,80,1,1);
   break;    
  
   case 20:  
   //DISTANCE_SENSOR_FRONT_LEFT & DISTANCE_SENSOR_RIGHT & DISTANCE_SENSOR_LEFT & BUMPER_RIGHT & BUMPER_LEFT
     movement(70,80,1,1);
   break;    
   
   case 21:  
   //All sensors active
     movement(90,85,1,1);
   break;           
   
   case 22:  
   //DISTANCE_SENSOR_FRONT_RIGHT & DISTANCE_SENSOR_RIGHT
     movement(100,70,1,1);
   break;   
   
   case 23:  
   //DISTANCE_SENSOR_FRONT_LEFT & DISTANCE_SENSOR_LEFT
     movement(70,100,1,1);
   break; 
     
   case 24:  
   //DISTANCE_SENSOR_RIGHT & BUMPER_RIGHT
     movement(100,70,1,1);
   break; 
 
   case 25:  
   //DISTANCE_SENSOR_LEFT & BUMPER_LEFT
     movement(70,100,1,1);
   break;  
   
   case 26:  
   //DISTANCE_SENSOR_FRONT_RIGHT & DISTANCE_SENSOR_LEFT
     movement(100,70,1,1);
   break;   
   
   case 27:  
   //DISTANCE_SENSOR_FRONT_LEFT & BUMPER_RIGHT
     movement(70,100,1,1);
   break; 
   
   case 28:  
   //DISTANCE_SENSOR_RIGHT & BUMPER_LEFT
     movement(100,70,1,1);
   break; 
   
   case 29:  
   //DISTANCE_SENSOR_FRONT_RIGHT & BUMPER_RIGHT
     movement(100,70,1,1);
   break;    
   
   case 30:  
   //DISTANCE_SENSOR_FRONT_LEFT & BUMPER_LEFT
     movement(70,100,1,1);
   break; 
 
   case 31:  
   //DISTANCE_SENSOR_FRONT_RIGHT & BUMPER_LEFT
     movement(70,100,1,1);
   break; 
   
   case 32:  
   //DISTANCE_SENSOR_FRONT_RIGHT & DISTANCE_SENSOR_RIGHT & DISTANCE_SENSOR_LEFT & BUMPER_RIGHT & BUMPER_LEFT
     movement(100,85,1,1);
   break;      
   
   case 33:  
   //DISTANCE_SENSOR_FRONT_RIGHT & DISTANCE_SENSOR_FRONT_LEFT & DISTANCE_SENSOR_LEFT & BUMPER_RIGHT & BUMPER_LEFT
     movement(85,100,1,1);
   break;     
   
   case 34:  
   //DISTANCE_SENSOR_FRONT_RIGHT & DISTANCE_SENSOR_FRONT_LEFT & DISTANCE_SENSOR_RIGHT & BUMPER_RIGHT & BUMPER_LEFT
     movement(70,100,1,1);
   break;   
   
   case 35:  
   //DISTANCE_SENSOR_FRONT_RIGHT & DISTANCE_SENSOR_FRONT_LEFT & DISTANCE_SENSOR_RIGHT & DISTANCE_SENSOR_LEFT & BUMPER_LEFT
     movement(85,100,1,1);
   break;            

   case 36:  
   //DISTANCE_SENSOR_FRONT_RIGHT & DISTANCE_SENSOR_LEFT & BUMPER_RIGHT & BUMPER_LEFT
     movement(100,70,1,1);
   break;    
   
   case 37:  
   //DISTANCE_SENSOR_FRONT_RIGHT & DISTANCE_SENSOR_FRONT_LEFT & BUMPER_RIGHT & BUMPER_LEFT
     movement(70,100,1,1);
   break;  
   
   case 38:  
   //DISTANCE_SENSOR_FRONT_RIGHT & DISTANCE_SENSOR_FRONT_LEFT & DISTANCE_SENSOR_RIGHT & BUMPER_LEFT
     movement(100,70,1,1);
   break;   
   
   case 39:  
   //DISTANCE_SENSOR_FRONT_LEFT & DISTANCE_SENSOR_LEFT & BUMPER_LEFT
     movement(70,100,1,1);
   break; 
   
   case 40:  
   //DISTANCE_SENSOR_FRONT_RIGHT & DISTANCE_SENSOR_RIGHT & BUMPER_RIGHT
     movement(100,70,1,1);
   break;   
   
   case 41:  
   //DISTANCE_SENSOR_FRONT_LEFT & DISTANCE_SENSOR_RIGHT & BUMPER_LEFT
     movement(70,100,1,1);
   break;   
   
   case 42:  
   //DISTANCE_SENSOR_FRONT_RIGHT & DISTANCE_SENSOR_LEFT & BUMPER_RIGHT
     movement(70,100,1,1);
   break;  
   
   case 43:  
   //DISTANCE_SENSOR_FRONT_RIGHT & DISTANCE_SENSOR_RIGHT & BUMPER_RIGHT & BUMPER_LEFT
     movement(100,70,1,1);
   break;     
   
   case 44:  
   //DISTANCE_SENSOR_FRONT_LEFT & DISTANCE_SENSOR_RIGHT & BUMPER_RIGHT & BUMPER_LEFT
     movement(65,100,1,1);
   break;      
   
   case 45:  
   //DISTANCE_SENSOR_FRONT_RIGHT & DISTANCE_SENSOR_RIGHT & DISTANCE_SENSOR_LEFT & BUMPER_LEFT
     movement(80,90,1,1);
   break;  
   
   case 46:  
   //DISTANCE_SENSOR_FRONT_LEFT & DISTANCE_SENSOR_RIGHT & DISTANCE_SENSOR_LEFT & BUMPER_LEFT
     movement(80,90,1,1);
   break;    
   
   case 47:  
   //DISTANCE_SENSOR_FRONT_RIGHT & DISTANCE_SENSOR_RIGHT & DISTANCE_SENSOR_LEFT & BUMPER_RIGHT
     movement(90,80,1,1);
   break;  
   
   case 48:  
   //DISTANCE_SENSOR_FRONT_RIGHT & DISTANCE_SENSOR_FRONT_LEFT & DISTANCE_SENSOR_LEFT & BUMPER_RIGHT
     movement(90,80,1,1);
   break;   
   
   case 49:  
   //DISTANCE_SENSOR_FRONT_LEFT & BUMPER_RIGHT & BUMPER_LEFT
     movement(75,100,1,1);
   break; 
   
   case 50:  
   //DISTANCE_SENSOR_FRONT_RIGHT & DISTANCE_SENSOR_LEFT & BUMPER_RIGHT
     movement(80,70,1,1);
   break;      
   
   case 51:  
   //DISTANCE_SENSOR_FRONT_LEFT & BUMPER_RIGHT & BUMPER_LEFT
     movement(100,90,1,1);
   break;    
   
   case 52:  
   //DISTANCE_SENSOR_RIGHT & BUMPER_RIGHT & BUMPER_LEFT
     movement(100,70,1,1);
   break;   
   
   case 53:  
   //DISTANCE_SENSOR_FRONT_LEFT & DISTANCE_SENSOR_LEFT & BUMPER_RIGHT & BUMPER_LEFT
     movement(75,100,1,1);
   break;   
   
   case 54:  
   //DISTANCE_SENSOR_FRONT_RIGHT & DISTANCE_SENSOR_RIGHT & DISTANCE_SENSOR_LEFT
     movement(80,65,1,1);
   break;   
   
   case 55:  
   //DISTANCE_SENSOR_FRONT_RIGHT & DISTANCE_SENSOR_FRONT_LEFT & BUMPER_LEFT
     movement(80,100,1,1);
   break;   
   
   case 56:  
   //DISTANCE_SENSOR_FRONT_RIGHT & DISTANCE_SENSOR_FRONT_LEFT & DISTANCE_SENSOR_LEFT & BUMPER_LEFT
     movement(80,100,1,1);
   break;                                                   

   case 57:  
   //DISTANCE_SENSOR_FRONT_RIGHT & DISTANCE_SENSOR_FRONT_LEFT & DISTANCE_SENSOR_LEFT
     movement(80,100,1,1);
   break;   
   
   case 58:  
   //DISTANCE_SENSOR_FRONT_RIGHT & DISTANCE_SENSOR_FRONT_LEFT & DISTANCE_SENSOR_RIGHT & BUMPER_RIGHT
     movement(100,80,1,1);
   break;                                                      
 
   case 59:  
   //DISTANCE_SENSOR_FRONT_RIGHT & DISTANCE_SENSOR_FRONT_LEFT & BUMPER_RIGHT
     movement(100,85,1,1);
   break;   
   
   case 60:  
   //DISTANCE_SENSOR_RIGHT & DISTANCE_SENSOR_LEFT & BUMPER_LEFT
     movement(80,70,1,1);
   break;                                                      

   
   case 64:  
   //ULTRASONC_SENSOR
     movement(70,100,1,1);
   break;                                                      
                     
   
  }

  

  
  
  
  } 