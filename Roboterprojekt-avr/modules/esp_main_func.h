
void esp_states(){
      currstate==0?(state=state_stop):(state=currstate-1); 
}
void esp_mainfunctions(){
 //Setup Linedetectorvalue for esp        
!LINE_DETECTOR_LEFT?(line_left=0):(line_left=1);
!LINE_DETECTOR_MID_LEFT?(line_mleft=0):(line_mleft=1);
!LINE_DETECTOR_MID_RIGHT?(line_mright=0):(line_mright=1);
!LINE_DETECTOR_RIGHT?(line_right=0):(line_right=1);
linesensorvaluetemp = (line_left*1000+line_mleft*100+line_mright*10+line_right);      

//Setup distancesensorvalue for esp 
  
!DISTANCE_SENSOR_LEFT?(dist_left=1):(dist_left=0);
!DISTANCE_SENSOR_FRONT_LEFT?(dist_fleft=1):(dist_fleft=0);
!DISTANCE_SENSOR_FRONT_RIGHT?(dist_fright=1):(dist_fright=0);
!DISTANCE_SENSOR_RIGHT?(dist_right=1):(dist_right=0);
distanzsensorvaluetemp = dist_left*1000+dist_fleft*100+dist_fright*10+dist_right;       
}


