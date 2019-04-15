//Gari Pahayo 04/09/2019
//2790
//flight code for methane sensor

// Libraries 
#include <Wire.h>
#include <Adafruit_MPL3115A2.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <Wire.h>
float methane;
#include <SD.h>

#include <Wire.h>

#include "SparkFunCCS811.h" //Click here to get the library: http://librarymanager/All#SparkFun_CCS811

#define CCS811_ADDR 0x5B //Default I2C Address
//#define CCS811_ADDR 0x5A //Alternate I2C Address

CCS811 mySensor(CCS811_ADDR);

int sensorvolt;
float adc;
float volt;
float res;
int ADCvalue;
double Voltage;
double Resistance;

Adafruit_MPL3115A2 baro = Adafruit_MPL3115A2();

// Hardware Pin Variable
const int cin = 3;
const int LEDB = 6;
const int LEDA = 7;
const int cns = 10;
const int cs = 9;

// Global Variables
int err;                    // Error flag

void setup()
{
  /******************** Initialize Aurdino  ******************/
  Serial.begin(9600);
  Serial.println("Arduino Start");
  /******************** Initialize Aurdino End ******************/
Wire.begin(); //Inialize I2C Harware
  /******************** Set Pin Mode  ******************/
  pinMode(cin, INPUT);
  pinMode(LEDA, OUTPUT);
  pinMode(LEDB, OUTPUT);
  pinMode(cs,OUTPUT);
   pinMode(cns,OUTPUT);
  /******************** Set Pin Mode End ******************/
 CCS811Core::status returnCode = mySensor.begin();
  if (returnCode != CCS811Core::SENSOR_SUCCESS)
  {
    Serial.println(".begin() returned with an error.");
    while (1); //Hang if there was a problem.
  }
  /******************** Initialize SD  ******************/
  Serial.print("Initializing SD card...");
  if (!SD.begin(cs)) 
  {
    Serial.println("Card failed, or not present");
    // don't do anything more:
    err=1;
    error(err);
    return;
  }
  Serial.println("card initialized.");
  /******************** Initialize SD END ******************/
}

void loop()
{
  methane = analogRead(A0);       // read analog input pin 1
  sensorvolt = methane * 3.3 / 4095;
  File dataFile = SD.open("datag.txt", FILE_WRITE); // Oprn data file for writng
  if (dataFile) 
  {
  Serial.print(sensorvolt);  // prints the value read
  Serial.print("\t");
  delay(1000);                        // wait 100ms for next reading
     dataFile.print(sensorvolt);
     dataFile.print("\t");
  if (! baro.begin()) {
    Serial.println("Couldnt find sensor");
    return;
  }
  
  float pascals = baro.getPressure();
  Serial.print(pascals); Serial.print(" pascals");
  Serial.print("\t");
  dataFile.print(pascals); 
  dataFile.print("\t");
  float altm = baro.getAltitude();
  Serial.print(altm); Serial.print(" meters");
  Serial.print("\t");
  dataFile.print(altm); 
  dataFile.print("\t");
  float tempC = baro.getTemperature();
  Serial.print(tempC); Serial.print("*C""\t");
  dataFile.print(tempC); dataFile.print("\t");

  delay(1000);   
  
ADCvalue = analogRead(A3);
Voltage = 5.0*ADCvalue/1023.0;
Resistance = 10000.0*(5.0/Voltage - 1.0);
Serial.print (Resistance, 3);
Serial.print("\t");
dataFile.print (Resistance, 3);
dataFile.print("\t");
delay(1000);

    
  if (tempC>10 & tempC<20)
    {
      pinMode(2,HIGH);
      Serial.print("on""\t");
      dataFile.print("1""\t");
      dataFile.print("\t");
      delay(1000);
    }
  else
    {
      pinMode(2,LOW); 
      Serial.print("off""\t");
      dataFile.print("0""\t");
      dataFile.print("\t");
      delay(1000);
    }
  if (mySensor.dataAvailable())
  {
    //If so, have the sensor read and calculate the results.
    //Get them later
    mySensor.readAlgorithmResults();

    Serial.print("CO2[");
    //Returns calculated CO2 reading
    Serial.print(mySensor.getCO2());
    dataFile.print(mySensor.getCO2());
    dataFile.print("\t");
    Serial.print("] tVOC[");
    //Returns calculated TVOC reading
    Serial.print(mySensor.getTVOC());
    dataFile.println(mySensor.getTVOC());
    Serial.print("] millis[");
    //Simply the time since program start
    Serial.print(millis());
    Serial.print("]");
    Serial.println();
    delay(1000);
  }
dataFile.close();
  }

  else
  {
    Serial.println("error opening datalog.txt");   // if the file isn't open, pop up an error:
    err=2;
    error(err);
  } 
}


int error(int err)
{
  if (err==1) // sd card intalization
  {
    digitalWrite(LEDA,HIGH);
    digitalWrite(LEDB,HIGH);
    delay(1000);
    digitalWrite(LEDA,LOW);
    digitalWrite(LEDB,LOW);


  }
  else if (err==2) // error opening data file
  {
    digitalWrite(LEDA,HIGH);
    digitalWrite(LEDB,LOW);
    delay(1000);
    digitalWrite(LEDA,LOW);
    digitalWrite(LEDB,HIGH);
    
  }
  else if (err==3) // unexplained erorr
  {
    digitalWrite(LEDA,HIGH); 
    digitalWrite(LEDB,HIGH); 
  }


  
}
