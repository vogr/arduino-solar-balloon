#include <Arduino.h>
#include <SPI.h>
#include <SD.h>

#include <DirectIO.h>

#include <Adafruit_Sensor.h>
#include <Adafruit_BMP280.h>

#include <MQ135.h>

#define USE_SERIAL true
#define USE_SD true

#define PRINT if(USE_SERIAL)Serial

// TODO: Tweak to local values!
static const float SEA_LEVEL_PRESSURE = 1023.0;
static const float HUMIDITY = 80.0;

static const int DELAY_TIME = 5000; //ms

//BMP throug I2C
Adafruit_BMP280 bmp;
MQ135 mq135 = MQ135(A2);
Output<13> led_pin;

void setup() 
{
  PRINT.begin(9600);

#ifdef USE_SD
  PRINT.print("Initializing SD card...");
  if (!SD.begin(10)) {
    PRINT.println(" Card failed, or not present.");
  }
  else {
    PRINT.println(" Card initialized.");
  }
#endif

  PRINT.println(F("Initializing BMP280..."));
  bool status = bmp.begin(0x76);
  if(!status) {  
    PRINT.println(" Could not find a valid BMP280 sensor, check wiring!");
    while (1);
    //TODO: use "return;" instead?
  }
  else {
    PRINT.println(" BMP280 initiliazed.");
  }
}

void loop()      
{    
  led_pin.write(HIGH);
  delay(10);
  led_pin.write(LOW);

  int pollution = analogRead(0);

  float temperature = bmp.readTemperature();
  float pressure = bmp.readPressure();
  float altitude = bmp.readAltitude(SEA_LEVEL_PRESSURE);
  
  float rzero = mq135.getRZero();
  float correctedRZero = mq135.getCorrectedRZero(temperature, HUMIDITY);
  float resistance = mq135.getResistance();
  float ppm = mq135.getPPM();
  float correctedPPM = mq135.getCorrectedPPM(temperature, HUMIDITY);

  PRINT.print(pollution);
  PRINT.print(",");
  PRINT.print(temperature);
  PRINT.print(",");
  PRINT.print(pressure);
  PRINT.print(",");
  PRINT.print(altitude);
  PRINT.print(",");
  PRINT.print(rzero);
  PRINT.print(",");
  PRINT.print(correctedRZero);
  PRINT.print(",");
  PRINT.print(resistance);
  PRINT.print(",");
  PRINT.print(ppm);
  PRINT.print(",");
  PRINT.print(correctedPPM);
  PRINT.println();

#ifdef USE_SD
  PRINT.print("Writing to data.txt...");
  File data = SD.open("data.txt", FILE_WRITE);
  if (data) {
    data.print(pollution);
    data.print(",");
    data.print(temperature);
    data.print(",");
    data.print(pressure);
    data.print(",");
    data.print(altitude);
    data.print(",");
    data.print(correctedPPM);
    data.println();
    data.close();
    PRINT.println(" Done.");
  }
  else {
    PRINT.println(" Error opening data.txt");
  }
#endif

  delay(DELAY_TIME - 10);
}
