void STATE_5(){
//Mottenverhalten
if (min_light==0){
if (LIGHT_SENSOR_LEFT<LIGHT_SENSOR_RIGHT){
min_light=LIGHT_SENSOR_LEFT;}else
{min_light=LIGHT_SENSOR_RIGHT;}
}

lcd_clear();
puts("moth");
lcd_gotoxy(0,1);
itoa(newvalR,str);
puts(str);
puts(" ");
itoa(newvalL,str);
puts(str);
//Prüft die LDRs nach Lichteinfluss (Reagiert erst bei 100 mehr als min_light, d.h. es muss eine zusätzliche Lichtquelle verwendet werden)
if(LIGHT_SENSOR_LEFT>min_light+100|LIGHT_SENSOR_RIGHT>min_light+100){
if(LIGHT_SENSOR_LEFT>LIGHT_SENSOR_RIGHT){
newvalL=50;
newvalR=0;
}

if(LIGHT_SENSOR_LEFT<LIGHT_SENSOR_RIGHT){
newvalL=0;
newvalR=50;
}
}



movement(newvalR,newvalL,0,0);
}