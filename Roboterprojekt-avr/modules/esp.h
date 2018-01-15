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

//Prüft den Buffer auf Vollständigkeit
bool slave_rx_handler(bool rx_complete)
{
  if (twi_result==TWI_RES_OK) received_ok=true;
  else{
    received_ok=false;
    return false;
  }
  if (rx_complete)return false;
  return (twi_rx_index<BUFFER_SIZE);
}

unsigned char slave_tx_handler(bool tx_complete)
{
  if (tx_complete==false)
  {   
  //sendet Daten an den ESP
      tx_buffer.data.linesensorvalue = linesensorvaluetemp;        
      tx_buffer.data.distanzsensorvalue = distanzsensorvaluetemp;       
      tx_buffer.data.lichtlinks=LIGHT_SENSOR_LEFT;  
      tx_buffer.data.lichtrechts=LIGHT_SENSOR_RIGHT; 
      tx_buffer.data.motorvalueleft=wheelEncoderCounter_left;
      tx_buffer.data.motorvalueright=wheelEncoderCounter_right; 
      tx_buffer.data.wiicam1=wiicamobject1; 
      tx_buffer.data.wiicam2=wiicamobject2; 
      tx_buffer.data.infarot=ucData;       
      tx_buffer.data.servo=servo_value_cur-170; 
      tx_buffer.data.ultraschall=iTime/52.2;           
      tx_buffer.data.iValue = iTemp;
    return BUFFER_SIZE;
  }  
  //Empfängt Daten vom ESP
  if (received_ok) currstate=rx_buffer.data.iValue;
  return 0; 
}


//initialisiert das TWO WIRE INTERFACE
void twiinit(){twi_slave_init(false,TWI_SLAVE_ADDR,rx_buffer.bytes,BUFFER_SIZE,tx_buffer.bytes,slave_rx_handler,slave_tx_handler);}