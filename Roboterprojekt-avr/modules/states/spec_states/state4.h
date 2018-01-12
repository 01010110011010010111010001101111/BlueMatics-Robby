int min_light=0;

void STATE_4(){
if (min_light==0){
if (LIGHT_SENSOR_LEFT<LIGHT_SENSOR_RIGHT){
min_light=LIGHT_SENSOR_LEFT;}else
{min_light=LIGHT_SENSOR_RIGHT;}
}

lcd_clear();
puts("bug");
lcd_gotoxy(0,1);
itoa(newvalR,str);
puts(str);
puts(" ");
itoa(newvalL,str);
puts(str);

if(LIGHT_SENSOR_LEFT>min_light+100|LIGHT_SENSOR_RIGHT>min_light+100){
if(LIGHT_SENSOR_LEFT>LIGHT_SENSOR_RIGHT){
newvalL=100;
newvalR=0;
}

if(LIGHT_SENSOR_LEFT<LIGHT_SENSOR_RIGHT){
newvalL=0;
newvalR=100;
}
}

//Data for left and right reversed, so that the robot can drive away from light
movement(newvalR,newvalL,1,1);
newvalL=0;
newvalR=0;
}


