
int currstate=0;
int state = state_stop; 
int line_left;
int line_mleft;
int line_mright;
int line_right;
int dist_left;
int dist_fleft;
int dist_fright;
int dist_right;
int linesensorvaluetemp;
int distanzsensorvaluetemp;

//SERVO
#define MAX_SERVOS 1
#define LEFT MIDDLE-220
#define MIDDLE 350
#define RIGHT MIDDLE+220
#define PERIOD 4000

/*
*IR RECEIVER
*/
#define RC5TIME     1.778e-3        // 1.778msec
#define    XTAL        16.0E6
#define PULSE_MIN    (unsigned char)(XTAL / 512 * RC5TIME * 0.2 + 0.5)
#define PULSE_1_2    (unsigned char)(XTAL / 512 * RC5TIME * 0.8 + 0.5)
#define PULSE_MAX    (unsigned char)(XTAL / 512 * RC5TIME * 1.2 + 0.5)

//IR RECEIVER
bit              rc5_bit=1;            // bit value
unsigned char rc5_time=0;            // count bit time
unsigned int  rc5_data=0;            // store result  
unsigned int  tmp;
unsigned char ucToggle;                         
unsigned char ucAdress;                         
unsigned char ucData;
char s[17];
// Globale Variablen für Servo
signed char arTrim[MAX_SERVOS] = {0};
unsigned int arServos[MAX_SERVOS] = {MIDDLE};
unsigned int Pause = PERIOD;
int ucServoNr = 0;
int ucNr = 0;
char strTemp[17] = "";
bit bChange = 1;
bit bPause = 0;
bit bMerk=1;
bit inSERVOTEST=0;
int servo_breaks = 1;
int servo_value_cur = 170; 
int servo_value_copy = 0;
int servo_test = 0;



//ESP
// TX_BUFFER, RX_BUFFER
#define BUFFER_SIZE 15
// 7bit slave I2C address
#define TWI_SLAVE_ADDR 0x50
unsigned char i=10;
int iTemp;
                
float fDistance;
// flag that signals that the TWI slave reception was OK
bit received_ok=false;
// struct declaration
struct TData
{
  uint8_t linesensorvalue; 
  uint8_t distanzsensorvalue;  
  int16_t lichtlinks;  
  int16_t lichtrechts;
  int16_t motorvalueleft;
  int16_t motorvalueright;
  uint8_t wiicam;
  uint8_t infarot;
  uint8_t servo;
  uint8_t ultraschall;
  uint8_t iValue;
};
// union declaration 
union TBuffer
{
  uint8_t bytes[BUFFER_SIZE];
  struct TData data; 
};
union TBuffer rx_buffer;  // slave receive buffer
union TBuffer tx_buffer;  // slave transmission buffer



//ULTRASONIC
char strULTRA[17];
unsigned int iRisingEdge, iFallingEdge;
unsigned int iTime;
    bit bChange2=0;

/* union declaration */
union alpha 
{
  unsigned char byte[2];
  unsigned int  word;
} icr3;


//WIICAM
#define slaveadress 0xB0
#define slaveread 0xB1
unsigned int data[16];
void write2Byte(char, char);
void readData(void); 
void convertdata(void); 
void wii_cam_init(void);

unsigned char Wert[5];  //Feld für Wertkonvertierung LCD
unsigned int x[4];     //X,Y-Koordinaten der Objekte
unsigned int y[4];    //X: 0..1023, Y: 0..767
unsigned char sWIICAM[4];     //S: 0..15 (Objektgröße im extended Mode)
unsigned int temp;

//aus main.c
int state_info = 0;
int leftCounter = 0;
int rightCounter = 0;     
int leftEnc = 0;
int rightEnc = 0;  
int engine_dir = 0;
int wiicamobject=0;
char str[17];



