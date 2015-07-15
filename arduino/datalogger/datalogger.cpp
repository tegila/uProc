// A simple data logger for the Arduino analog pins with optional DS1307
// uses RTClib from https://github.com/adafruit/RTClib
#include <Arduino.h> 
#include "TimerOne.h"
#include <dht.h> 

#include <SdFat.h>
#include <SdFatUtil.h>  // define FreeRam()

#define DHT22_PIN 5

#define SD_CHIP_SELECT  SS  // SD chip select pin
#define USE_DS1307       0  // set nonzero to use DS1307 RTC
#define LOG_INTERVAL     2000000  // mills between entries
#define ECHO_TO_SERIAL   1  // echo data to serial port if nonzero
#define WAIT_TO_START    1  // Wait for serial input in setup()
#define ADC_DELAY       10  // ADC delay for high impedence sensors

void timerIsr();

// DHT22 object
dht DHT;

// file system object
SdFat sd;

// text file for logging
ofstream logfile;

// Serial print stream
ArduinoOutStream cout(Serial);

// buffer to format data - makes it eaiser to echo to Serial
char buf[150];

//------------------------------------------------------------------------------
// store error strings in flash to save RAM
#define error(s) sd.errorHalt_P(PSTR(s))
 
void setup() {
  Serial.begin(9600);
  
  // Initialize the digital pin as an output.
  // Pin 13 has an LED connected on most Arduino boards
  pinMode(13, OUTPUT);    
  
  Timer1.initialize(LOG_INTERVAL); // set a timer of length 100000 microseconds (or 0.1 sec - or 10Hz => the led will blink 5 times, 5 cycles of on-and-off, per second)
  Timer1.attachInterrupt( timerIsr ); // attach the service routine here

  // pstr stores strings in flash to save RAM
  cout << endl << pstr("FreeRam: ") << FreeRam() << endl;

  // initialize the SD card at SPI_HALF_SPEED to avoid bus errors with
  if (!sd.begin(SD_CHIP_SELECT, SPI_HALF_SPEED)) sd.initErrorHalt();

  // create a new file in root, the current working directory
  char name[] = "LOGGER00.CSV";

  for (uint8_t i = 0; i < 100; i++) {
    name[6] = i/10 + '0';
    name[7] = i%10 + '0';
    if (sd.exists(name)) continue;
    logfile.open(name);
    break;
  }
  if (!logfile.is_open()) error("file.open");

  cout << pstr("Logging to: ") << name << endl;
  
  // format header in buffer
  obufstream bout(buf, sizeof(buf));

  bout << pstr("millis, soil, humidity, temperature");
  logfile << buf << endl;

  #if ECHO_TO_SERIAL
    cout << buf << endl;
  #endif
}

//------------------------------------------------------------------------------

void loop() {

}
/// --------------------------
/// Custom ISR Timer Routine
/// --------------------------
void timerIsr()
{
  // use buffer stream to format line
  obufstream bout(buf, sizeof(buf));
  
  // Toggle LED
  digitalWrite( 13, digitalRead( 13 ) ^ 1 );

  // start with time in millis
  bout << millis();

  // soil moisture
  int sensorValue = analogRead(A0);
  sensorValue = constrain(sensorValue, 485, 1023);
  bout << ", " << map(sensorValue, 485, 1023, 100, 0);

  // DHT 22
  int chk = DHT.read22(DHT22_PIN);
  bout << ", " << DHT.humidity;
  bout << ", " << DHT.temperature;

  bout << endl;

  // log data and flush to SD
  logfile << buf << flush;

  // check for error
  if (!logfile) error("write data failed");

  #if ECHO_TO_SERIAL
    cout << buf;
  #endif

}