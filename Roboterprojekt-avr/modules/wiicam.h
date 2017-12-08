//WIICAM
#define slaveadress 0xB0
#define slaveread 0xB1
unsigned int data[16];
void write2Byte(char, char);
void readData(void); 
void convertdata(void); 
void wii_cam_init(void);

unsigned char Wert[5];  //Feld f�r Wertkonvertierung LCD
unsigned int x[4];     //X,Y-Koordinaten der Objekte
unsigned int y[4];    //X: 0..1023, Y: 0..767
unsigned char sWIICAM[4];     //S: 0..15 (Objektgr��e im extended Mode)
unsigned int temp;


 /////////////WIICAM////////////// 

void wii_cam_init(void)
{
 //Kamera initialisieren
    write2Byte(0x30,0x01);            //Camera on
    write2Byte(0x30,0x08);             //set sensitivity Block 1 und 2
    write2Byte(0x06,0x90);          //sensitivity part1
    write2Byte(0x08,0xC0);          //sensitivity part2
    write2Byte(0x1A,0x40);
    write2Byte(0x33,0x33);          //setting Mode : hier extended  
    delay_ms(100);
}

void write2Byte(char b1, char b2)
{
      i2c_start();
        i2c_write(slaveadress); //I2C-Adresse der Kamera, hier 0xBO
        i2c_write(b1);
        i2c_write(b2);
        i2c_stop();
        delay_ms(10);
} 

void readData(void)
{
     unsigned char i=0;
     i2c_start();
        i2c_write(slaveadress); //I2C-Adresse der Kamera
        i2c_write(0x36);
        i2c_stop();
        delay_ms(1);
        i2c_start();
        i2c_write(slaveread); //I2C-Adresse der Kamera Lesemodus 0xB1
        for(i=0; i<15; i++){
   	   	data[i]=i2c_read(1);
        }
        data[15]=i2c_read(0);
        i2c_stop();
}  

void convertdata(void)
{       
    int i=0;	
    for(i=0; i<4; i++) {
 	temp= (data[3+3*i]&0x30)<<4;
 	x[i]=data[1+3*i]+temp;
 	temp= (data[3+3*i]&0xC0)<<2;
 	y[i]=data[2+3*i]+temp; 
 	sWIICAM[i]=data[3+3*i]&0x0F;
       }
}