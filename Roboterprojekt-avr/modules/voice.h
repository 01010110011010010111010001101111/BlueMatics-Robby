#include <stdio.h>
#include <stdlib.h>

int default_buffer[10] = {0x7E , 0xFF , 0x06 , 0x00 , 0x00 , 0x00 , 0x00 , 0xEF}; // Default Buffer
int buffer_data[10] = {0x7E , 0xFF , 0x06 , 0x00 , 0x00 , 0x00 , 0x00 , 0xEF}; // Sending Buffer

// Send Buffer to UART TX Pin
void send_buffer(void) {
    int i;
    for( i=0; i< 10; i++){
        putchar(buffer_data[i]);
        buffer_data[i] = default_buffer[i];
    } 
}
// Set Volume And Send it's Serial Command
void set_volume( int volume ) {
    buffer_data[3] = 0x06;
    buffer_data[6] = volume;
    send_buffer();     
}

// Set a Track (1-3000) to Play
void play_track(int track_id) {
  buffer_data[3] = 0x03;
  if(track_id < 256) {
    buffer_data[6] = track_id;
  } else {
    buffer_data[5] = track_id / 256;
    buffer_data[6] = track_id - 256 * buffer_data[6];
  }
    send_buffer();
}



// Pause Current Playing Track
void pause_current_track() {
    buffer_data[3] = 0x0E;
    send_buffer(); 
}
