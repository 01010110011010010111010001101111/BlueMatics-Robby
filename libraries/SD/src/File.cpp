/*

 SD - a slightly more friendly wrapper for sdfatlib

 This library aims to expose a subset of SD card functionality
 in the form of a higher level "wrapper" object.

 License: GNU General Public License V3
          (Because sdfatlib is licensed with this.)

 (C) Copyright 2010 SparkFun Electronics

 */

#include <SD.h>

/* for debugging file open/close leaks
   uint8_t nfilecount=0;
*/

SDFile::SDFile(SdFile f, const char *n) { // DAE
  // oh man you are kidding me, new() doesnt exist? Ok we do it by hand!
  _file = (SdFile *)malloc(sizeof(SdFile)); 
  if (_file) {
    memcpy(_file, &f, sizeof(SdFile));
    
    strncpy(_name, n, 12);
    _name[12] = 0;
    
    /* for debugging file open/close leaks
       nfilecount++;
       Serial.print("Created \"");
       Serial.print(n);
       Serial.print("\": ");
       Serial.println(nfilecount, DEC);
    */
  }
}

SDFile::SDFile(void) { // DAE
  _file = 0;
  _name[0] = 0;
  //Serial.print("Created empty file object");
}

// returns a pointer to the file name
char *SDFile::name(void) { // DAE
  return _name;
}

// a directory is a special type of file
boolean SDFile::isDirectory(void) { // DAE
  return (_file && _file->isDir());
}


size_t SDFile::write(uint8_t val) { // DAE
  return write(&val, 1);
}

size_t SDFile::write(const uint8_t *buf, size_t size) { // DAE
  size_t t;
  if (!_file) {
    setWriteError();
    return 0;
  }
  _file->clearWriteError();
  t = _file->write(buf, size);
  if (_file->getWriteError()) {
    setWriteError();
    return 0;
  }
  return t;
}

int SDFile::peek() { // DAE
  if (! _file) 
    return 0;

  int c = _file->read();
  if (c != -1) _file->seekCur(-1);
  return c;
}

int SDFile::read() { // DAE
  if (_file) 
    return _file->read();
  return -1;
}

// buffered read for more efficient, high speed reading
int SDFile::read(void *buf, uint16_t nbyte) { // DAE
  if (_file) 
    return _file->read(buf, nbyte);
  return 0;
}

int SDFile::available() { // DAE
  if (! _file) return 0;

  uint32_t n = size() - position();

  return n > 0X7FFF ? 0X7FFF : n;
}

void SDFile::flush() { // DAE
  if (_file)
    _file->sync();
}

boolean SDFile::seek(uint32_t pos) { // DAE
  if (! _file) return false;

  return _file->seekSet(pos);
}

uint32_t SDFile::position() {  // DAE
  if (! _file) return -1;
  return _file->curPosition();
}

uint32_t SDFile::size() { // DAE
  if (! _file) return 0;
  return _file->fileSize();
}

void SDFile::close() { // DAE
  if (_file) {
    _file->close();
    free(_file); 
    _file = 0;

    /* for debugging file open/close leaks
    nfilecount--;
    Serial.print("Deleted ");
    Serial.println(nfilecount, DEC);
    */
  }
}

SDFile::operator bool() { // DAE
  if (_file) 
    return  _file->isOpen();
  return false;
}

