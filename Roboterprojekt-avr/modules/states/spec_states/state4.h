
void STATE_4(){
lcd_clear();
puts("bug");
lcd_gotoxy(0,1);
itoa(newvalR,str);
puts(str);
puts(" ");
itoa(newvalL,str);
puts(str);

pwmmaker(70);
//Data for left and right reversed, so that the robot can drive away from light
movement(newvalR,newvalL,1,1);
}


