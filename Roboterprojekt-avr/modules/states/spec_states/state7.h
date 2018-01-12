void STATE_7(){ 
        unsigned char iWII=0; 
        readData();
        convertdata();
        lcd_clear();
        puts("FOLLOW"); 

        for(iWII=0; iWII<2; iWII++){            
                if (iWII<2){
                   if(x[iWII]==1023||y[iWII]==1023){ 
                  }
                   else{                          
                   if ((x[iWII]-512)<1023){
                   Wiipwmright=60; 
                   }else{
                   Wiipwmleft=60;               
                   } 
                   wiicamobject1=x[iWII]-512;  
                   wiicamobject2=y[i]-374;                  
                   } 
               }    
          }
    if((iTime/52.2)>40){     
    movement(Wiipwmleft,Wiipwmright,0,0);    
    }               
    delay_ms(30); 
    WII_CAM_SCL = !WII_CAM_SCL;        
}