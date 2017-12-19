#include <lcd.h>



  /////////////ADC PORT////////////// 


#define FIRST_ADC_INPUT 0
#define LAST_ADC_INPUT 5
unsigned int adc_data[LAST_ADC_INPUT-FIRST_ADC_INPUT+1];
// Voltage Reference: AVCC pin
#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
// ADC interrupt service routine
// with auto input scanning
interrupt [ADC_INT] void adc_isr(void)
{
static unsigned char input_index=0;
// Read the AD conversion result
adc_data[input_index]=ADCW;
// Select next ADC input
if (++input_index > (LAST_ADC_INPUT-FIRST_ADC_INPUT))
   input_index=0;
ADMUX=(FIRST_ADC_INPUT | ADC_VREF_TYPE)+input_index;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
}


  /////////////INTERRUPTS////////////// 
  
  
 int wheelEncoderCounter_left  = 0;
 int wheelEncoderCounter_right = 0;           
// External Interrupt 4 Wheel encoder Left
 interrupt [EXT_INT4] void ext_int4_isr(void)
 {
 if (wheelEncoderCounter_right<20000){
  wheelEncoderCounter_right++;      
  }else{wheelEncoderCounter_right=0;}
 }
// External Interrupt 6 Wheel encoder Right
 interrupt [EXT_INT6] void ext_int6_isr(void)
 {
 if (wheelEncoderCounter_left<20000){
  wheelEncoderCounter_left++;      
  }else{wheelEncoderCounter_left=0;}
 }



  /////////////PORT A////////////// 

//NOT IN USE #define PORTA.0
#define ENGINE_ENABLE_RIGHT         PORTA.1
#define REMOTE_CONTROL               PINA.2
#define ENGINE_ENABLE_LEFT          PORTA.3
#define BUMPER_LEFT                  PINA.4
#define ENGINE_DIRECTION_RIGHT      PORTA.5
#define BUMPER_RIGHT                 PINA.6
#define ENGINE_DIRECTION_LEFT       PORTA.7

  /////////////PORT B////////////// 

#define DISTANCE_SENSOR_LEFT         PINB.0
#define TRIGGER                      PORTB.1
#define DISTANCE_SENSOR_FRONT_LEFT   PINB.2
#define WII_CAM_SCL                  PORTB.3
#define DISTANCE_SENSOR_FRONT_RIGHT  PINB.4
#define WII_CAM_SDA                  PINB.5
#define DISTANCE_SENSOR_RIGHT        PINB.6
//NOT IN USE #define PORTB.7

  /////////////PORT C////////////// 

//LCD USES THIS  #define PORTC.0
//LCD USES THIS  #define PortC.1
//LCD USES THIS  #define PortC.2
//LCD USES THIS  #define PortC.3
//LCD USES THIS  #define PortC.4
//LCD USES THIS  #define PortC.5
//LCD USES THIS  #define PortC.6
//LCD USES THIS  #define PortC.7

  /////////////PORT D////////////// 

#define WIFI_BOARD_SDA               PIND.0
#define WIFI_BOARD_SCL              PORTD.1
//NOT IN USE #define PORTD.2
//NOT IN USE #define PORTD.3
//NOT IN USE #define PORTD.4
//NOT IN USE #define PORTD.5
//NOT IN USE#define  PORTD.6
#define SERVO                       PORTD.7

  /////////////PORT E////////////// 

//NOT IN USE #define PORTE.0
//NOT IN USE #define PORTE.1
//NOT IN USE #define PORTE.2
//NOT IN USE #define PORTE.3
#define WHEEL_ENCODER_RIGHT           PINE.4
//NOT IN USE #define PORTE.5
#define WHEEL_ENCODER_LEFT            PINE.6
#define ECHO                          PINE.7

  /////////////PORT F////////////// 

#define LINE_DETECTOR_LEFT           PINF.0
#define LIGHT_SENSOR_LEFT            adc_data[1]
#define LINE_DETECTOR_MID_LEFT       PINF.2
#define LIGHT_SENSOR_RIGHT           adc_data[3]
#define LINE_DETECTOR_MID_RIGHT      PINF.4
//NOTI IN USE#define PORTF.5
#define LINE_DETECTOR_RIGHT          PINF.6
//NOT IN USE #define PORTF.7

#asm
   .equ __lcd_port=0x15 ;PORTC
#endasm

void port_init(){

// Port initialization
DDRA  = 0b10001010;
DDRB  = 0b00000010;
//LCD USES THIS PORT DDRC  = 0b11111111;
DDRD  = 0b10100001;
DDRE  = 0b00100000;
DDRF  = 0b00100000;

// LCD initialization
lcd_init(16);


// ADC initialization
// ADC Clock frequency: 125,000 kHz
// ADC Voltage Reference: AVCC pin
ADMUX=FIRST_ADC_INPUT | ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (1<<ADSC) | (0<<ADFR) | (0<<ADIF) | (1<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
SFIOR=(0<<ACME);

ACSR=0x80;

//Interrupt init
EICRA = 0b00000000;
EICRB = 0b00010001;
EIMSK = 0b01010000;
EIFR  = 0b00000000;


  // Timer/Counter 0 initialization
  // Clock source: System Clock
  // Clock value: 62,500 kHz
  // Mode: Normal top=FFh
  // OC0 output: Disconnected 
  
ASSR=0x00;
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (1<<CS01) | (0<<CS00);
TCNT0=131;
OCR0=0x00;
  
//////////////////////////////////////////timer1
// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 2000,000 kHz
// Mode: Fast PWM top=0x00FF
// OC1A output: Disconnected
// OC1B output: Disconnected
// OC1C output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 0,128 ms
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<COM1C1) | (0<<COM1C0) | (0<<WGM11) | (1<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
OCR1CH=0x00;
OCR1CL=0x00;



//TIMER 2
TCCR2=(0<<WGM20) | (0<<COM21) | (0<<COM20) | (0<<WGM21) | (1<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;


/////////////////////////////////////////////////////////////


  // Timer/Counter 3 initialization
  // Clock source: System Clock
  // Clock value: 250.000 kHz
  // Mode: CTC top=OCR3A
  // OC3A output: Disconnected
  // OC3B output: Disconnected
  // OC3C output: Disconnected
  // Noise Canceler: On
  // Input Capture on Rising Edge
  // Timer Period: 0.1 s
  // Timer3 Overflow Interrupt: Off
  // Input Capture Interrupt: On
  // Compare A Match Interrupt: On
  // Compare B Match Interrupt: Off
  // Compare C Match Interrupt: Off        
  
  TCCR3A=(0<<COM3A1) | (0<<COM3A0) | (0<<COM3B1) | (0<<COM3B0) | (0<<COM3C1) | (0<<COM3C0) | (0<<WGM31) | (0<<WGM30);
  TCCR3B=(1<<ICNC3) | (1<<ICES3) | (0<<WGM33) | (1<<WGM32) | (0<<CS32) | (1<<CS31) | (1<<CS30);
  TCNT3H=0x00;
  TCNT3L=0x00;
  ICR3H=0x00;
  ICR3L=0x00;
  OCR3AH=0x61;
  OCR3AL=0xA8;
  OCR3BH=0x00;
  OCR3BL=0x00;
  OCR3CH=0x00;
  OCR3CL=0x00;

/////////////////////////////////////////////////////////////




  // Timer(s)/Counter(s) Interrupt(s) initialization  

TIMSK=( 0x01 | (1 <<TOIE2)| (1<<TOIE1));
ETIMSK=(1<<TICIE3) | (1<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);


// Global enable interrupts
#asm("sei")

}