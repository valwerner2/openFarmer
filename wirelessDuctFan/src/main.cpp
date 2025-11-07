#include <Arduino.h>
#include <map>

const int PWM_FAN_OUTPUT = 2;

void setFanSpeed(uint8_t speed)
{
    speed = speed % (101 + 1);

    speed = !speed ? 0 : map(speed, 1, 100, 25, 255);

    analogWrite(PWM_FAN_OUTPUT,speed);
}

void setup() {
    pinMode(PWM_FAN_OUTPUT, OUTPUT);
}

void loop() {

}