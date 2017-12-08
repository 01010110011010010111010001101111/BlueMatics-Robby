
//ESP
// TX_BUFFER, RX_BUFFER
#define BUFFER_SIZE 15


// 7bit slave I2C address
#define TWI_SLAVE_ADDR 0x50

char str[17];
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


/////////////////ESP//////////////////
flash char * flash status_msg[8]=
{
"OK",
"Buffer overflow",
"Arbitration lost",
"Bus error",
"NACK received",
"Bus timeout",
"Fail",
"Unknown error"
};

bool slave_rx_handler(bool rx_complete)
{
  if (twi_result==TWI_RES_OK) 
    received_ok=true; // signal that data was received without errors
  else
  {
    received_ok=false; // signal that data was received with errors
    return false; // stop reception
  }
   
  if (rx_complete)
    // the TWI master has finished transmitting data
    return false; // no more bytes to receive
   
  // signal to the TWI master that the TWI slave is ready to accept more data
  // as long as there is space in the receive buffer
  return (twi_rx_index<BUFFER_SIZE);
}

unsigned char slave_tx_handler(bool tx_complete)
{
  if (tx_complete==false)
  {
    // transmission from slave to master is about to start
    // copy the data to transmit to the TWI master in the transmission buffer

     
      tx_buffer.data.linesensorvalue = linesensorvaluetemp;        
      tx_buffer.data.distanzsensorvalue = distanzsensorvaluetemp;       
      tx_buffer.data.lichtlinks=LIGHT_SENSOR_LEFT;  
      tx_buffer.data.lichtrechts=LIGHT_SENSOR_RIGHT; 
      tx_buffer.data.motorvalueleft=wheelEncoderCounter_left;
      tx_buffer.data.motorvalueright=wheelEncoderCounter_right; 
      tx_buffer.data.wiicam=wiicamobject; 
      tx_buffer.data.infarot=ucData;       
      tx_buffer.data.servo=servo_value_cur; 
      tx_buffer.data.ultraschall=iTime/52.2;   
 
              
      tx_buffer.data.iValue = iTemp;
    
    
    // number of bytes to transmit from the TWI slave to the TWI master
    return BUFFER_SIZE;
  }
  
  // transmission from slave to master has already started,
  // no more bytes to send in this transaction
  if (received_ok)
  {
        currstate=rx_buffer.data.iValue; 
  }
  return 0; 
}
