 void STATE_8(){ 
        unsigned char iWII=0; 
        unsigned char pwmleft=0;
        unsigned char pwmright=0; 
        readData();
        convertdata(); 
        //Anzeige der Blobs als X/X-Wertepaare   
        for(iWII=0; iWII<2; iWII++){            
                if (iWII<2){           //erste Zeile: Blob 1 und 2  
                   if(x[iWII]==1023||y[iWII]==1023){ 
                  }
                   else{                          
                   itoa( x[iWII]-512, Wert);  //konvertiert die int-Ausgabe des Empf�ngers in char-Array   
                   lcd_gotoxy(20 * (iWII), 0);
                   lcd_puts(Wert);
                   itoa( y[iWII]-374, Wert);
                   lcd_gotoxy(20 * (iWII)+ 8, 0);
                   lcd_puts(Wert);
                   if ((x[iWII]-512)<1023){
                   pwmright=100;
                   pwmleft=0;
                   }else{
                   pwmleft=100;
                   pwmright=0;
                   }                   
                   } 
               }    
          }     
    movement(pwmleft,pwmright,0,0);                   
    delay_ms(30); 
    WII_CAM_SCL = !WII_CAM_SCL;               
 }   