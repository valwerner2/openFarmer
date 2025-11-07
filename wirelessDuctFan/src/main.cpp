#include <Arduino.h>
#include <map>
#include "Adafruit_SHT4x.h"

const int PWM_FAN_OUTPUT = 2;

Adafruit_SHT4x sht4 = Adafruit_SHT4x();

void setFanSpeed(uint8_t speed)
{
    speed = speed % (101 + 1);

    speed = !speed ? 0 : map(speed, 1, 100, 25, 255);

    analogWrite(PWM_FAN_OUTPUT,speed);
}

void sensorSetup()
{
    if (! sht4.begin(&Wire)) {
        Serial.println("Couldn't find SHT4x");
        while (1) delay(1);
    }
    Serial.println("Found SHT4x sensor");
    Serial.print("Serial number 0x");
    Serial.println(sht4.readSerial(), HEX);

    sht4.setPrecision(SHT4X_HIGH_PRECISION);
    sht4.setHeater(SHT4X_NO_HEATER);

    delay(1000);
}

void setup() {
    Serial.begin(115200);
    delay(1000);
    pinMode(PWM_FAN_OUTPUT, OUTPUT);
    sensorSetup();
}

void loop() {
    sensors_event_t humidity, temp;
    sht4.getEvent(&humidity, &temp);// populate temp and humidity objects with fresh data

    Serial.print("Temperature: "); Serial.print(temp.temperature); Serial.println(" degrees C");
    Serial.print("Humidity: "); Serial.print(humidity.relative_humidity); Serial.println("% rH");
}