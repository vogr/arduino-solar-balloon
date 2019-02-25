#include <Arduino.h>
#include <SPI.h>
#include <SD.h>

#include <DirectIO.h>

#include <Adafruit_Sensor.h>
#include <Adafruit_BMP280.h>

#include <MQ135.h>

#define USE_SD true

// TODO: Tweak to local values!
static const float SEA_LEVEL_PRESSURE = 1013.25;
static const float HUMIDITY = 25.0;

static const int DELAY_TIME = 5000; //ms

//BMP throug I2C
Adafruit_BMP280 bmp;
MQ135 mq135 = MQ135(A2);
Output<13> led_pin;

void setup() 
{
  Serial.begin(9600);

#ifdef USE_SD
  Serial.print("Initializing SD card...");
  if (!SD.begin(10)) {
    Serial.println(" Card failed, or not present.");
  }
  else {
    Serial.println(" Card initialized.");
  }
#endif

  Serial.println(F("Initializing BMP280..."));
  bool status = bmp.begin(0x76);
  if(!status) {  
    Serial.println(" Could not find a valid BMP280 sensor, check wiring!");
    while (1);
    //TODO: use "return;" instead?
  }
  else {
    Serial.println(" BMP280 initiliazed.");
  }
}

void loop()      
{    
  led_pin.write(HIGH);
  delay(5);
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

  Serial.print(pollution);
  Serial.print(",");
  Serial.print(temperature);
  Serial.print(",");
  Serial.print(pressure);
  Serial.print(",");
  Serial.print(altitude);
  Serial.print(",");
  Serial.print(rzero);
  Serial.print(",");
  Serial.print(correctedRZero);
  Serial.print(",");
  Serial.print(resistance);
  Serial.print(",");
  Serial.print(ppm);
  Serial.print(",");
  Serial.print(correctedPPM);
  Serial.println();

#ifdef USE_SD
  Serial.print("Writing to data.txt...");
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
    Serial.println(" Done.");
  }
  else {
    Serial.println(" Error opening data.txt");
  }
#endif

  delay(DELAY_TIME - 5);
}
