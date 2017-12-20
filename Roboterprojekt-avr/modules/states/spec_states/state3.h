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
   
   case 30:  
   //DISTANCE_SENSOR_FRONT_LEFT & BUMPER_LEFT
     movement(70,100,1,1);
   break;
   
   
  }

  } 