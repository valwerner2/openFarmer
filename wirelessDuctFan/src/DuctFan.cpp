//
// Created by Valentin Werner on 10.11.25.
//
#include "DuctFan.h"
#include <map>
#include "Adafruit_SHT4x.h"

namespace DuctFan
{
    DuctFan::DuctFan()
    {
        sht4 = Adafruit_SHT4x();
    }

    void DuctFan::init()
    {
        //sensor setup
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

        //pwm ouput setup
        pinMode(PWM_FAN_OUTPUT, OUTPUT);
    }

    void DuctFan::setSpeed()
    {
        state.currentSpeed = state.currentSpeed > state.currentMaxSpeed ? state.currentMaxSpeed : state.currentSpeed;
        int newSpeed = !state.currentSpeed ? 0 : map(state.currentSpeed, 1, 100, 25, 255);
        analogWrite(PWM_FAN_OUTPUT, newSpeed);
    }

    int DuctFan::getNewSpeed(int currentSpeed, float diff, bool down)
    {
        static float oldDiff = diff;
        float diffDiff = diff - oldDiff;
        oldDiff = diff;

        const bool reached = (down && diff < 0.0f) || (!down && diff > 0.0f);
        const bool desiredDir = (diffDiff < 0.0f && down) || (diffDiff > 0.0f && !down);

        Serial.printf("R%d D%d\n", reached, desiredDir);
        if      (reached){currentSpeed -= 10;}
        else if (desiredDir){currentSpeed --;}
        else    {currentSpeed += 2;}

        if (currentSpeed < 0) currentSpeed = 0;

        return currentSpeed;
    }

    void DuctFan::loadSensorData()
    {
        sensors_event_t humidity, temp;
        sht4.getEvent(&humidity, &temp);

        state.currentHum = humidity.relative_humidity;
        state.currentTemp = temp.temperature;
    }
    void DuctFan::updateSpeed()
    {
        const float difTemp = state.currentTargetTemp == 0.f ? 0.f : state.currentTemp - state.currentTargetTemp;
        const float difHum = state.currentTargetHum  == 0.f ? 0.f : state.currentHum - state.currentTargetHum;

        Serial.printf("\nTemperature: %2.2f -> %2.2f | %2.2f \n", state.currentTemp, state.currentTargetTemp, difTemp);
        Serial.printf("Humidity   : %2.2f -> %2.2f | %2.2f \n", state.currentHum, state.currentTargetHum, difHum);
        Serial.printf("Speed: %d\n", state.currentSpeed);

        switch (state.current_mode())
        {
        case MODE_HUM_DOWN:
            state.currentSpeed = getNewSpeed(state.currentSpeed, difHum, true);
            break;
        case MODE_HUM_UP:
            state.currentSpeed = getNewSpeed(state.currentSpeed, difHum, false);
            break;
        case MODE_TEMP_DOWN:
            state.currentSpeed = getNewSpeed(state.currentSpeed, difTemp, true);
            break;
        case MODE_TEMP_UP:
            state.currentSpeed = getNewSpeed(state.currentSpeed, difTemp, false);
            break;
        case MODE_SLAVE:
            state.currentSpeed = state.currentMaxSpeed;
            break;
        default:
            state.currentSpeed  = 0;
            break;
        }
    }
    void DuctFan::updateCurrent()
    {
        state.currentMaxSpeed = state.max_speed_day();
        state.currentTargetTemp = state.target_temp_day();
    }

    void DuctFan::update()
    {
        updateCurrent();
        loadSensorData();
        updateSpeed();
        setSpeed();
    }

} // DuctFan