// Rotary Encoder KY-040

long virtualPosition=0; 

#define PinCLK 2                   // Used for generating interrupts using CLK signal
#define PinDT 3                    // Used for reading DT signal
#define PinSW 4                    // Used for the push button switc

void isr ()  {
  noInterrupts();
  if (digitalRead(PinCLK) == digitalRead(PinDT))
     virtualPosition++;
  else
     virtualPosition--;
  Serial.print ("Count = ");  
  Serial.println (virtualPosition);
  interrupts();
}

void setup ()  {
 pinMode(PinCLK,INPUT);
 pinMode(PinDT,INPUT);  
 pinMode(PinSW,INPUT);
 attachInterrupt (0,isr,CHANGE);  // interrupt 0 is always connected to pin 2 on Arduino UNO
 Serial.begin (9600);
 Serial.println("Start");
}

void loop ()  {

}