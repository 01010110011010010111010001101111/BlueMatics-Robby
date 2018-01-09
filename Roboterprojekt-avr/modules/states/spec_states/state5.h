void STATE_5(){

lcd_clear();
puts("moth");
lcd_gotoxy(0,1);
itoa(newvalR,str);
puts(str);
puts(" ");
itoa(newvalL,str);
puts(str);

pwmmaker(70);
movement(newvalR,newvalL,0,0);
}