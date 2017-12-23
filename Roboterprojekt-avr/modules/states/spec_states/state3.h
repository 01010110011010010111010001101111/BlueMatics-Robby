  /////////////////////////// 
  void movement(int left, int right, int dir_left, int dir_right){
  ipwmcompareleft=left; 
  ipwmcompareright=right; 
  ENGINE_DIRECTION_LEFT = dir_left;  
  ENGINE_DIRECTION_RIGHT = dir_right;
  }
  

        
  void STATE_3(){
  
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
            
           
   
  }

  } 