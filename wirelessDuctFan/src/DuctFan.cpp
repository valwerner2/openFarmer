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
        int newSpeed = !state.currentSpeed ? 0 : map(state.currentSpeed, 1, 100, 25, 255);
        analogWrite(PWM_FAN_OUTPUT, newSpeed);
    }

    int DuctFan::getNewSpeed(float diff, bool down)
    {
        if ((down && diff > 0.f) || (!down && diff < 0.f))
        {
            diff = abs(diff);
            const int newSpeed = static_cast<int>(diff * 10.f + pow(diff, 3));
            return newSpeed > state.max_speed_day() ? state.max_speed_day() : newSpeed;
        }
        return 0;
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
        const float difTemp = state.target_temp_day() == 0.f ? 0.f : state.currentTemp - state.target_temp_day();
        const float difHum = state.target_hum_day()  == 0.f ? 0.f : state.currentHum - state.target_hum_day();

        Serial.printf("\nTemperature: %2.2f -> %2.2f | %2.2f \n", state.currentTemp, state.target_temp_day(), difTemp);
        Serial.printf("Humidity   : %2.2f -> %2.2f | %2.2f \n", state.currentHum, state.target_hum_day(), difHum);
        Serial.printf("Speed: %d\n", state.currentSpeed);

        switch (state.current_mode())
        {
        case MODE_HUM_DOWN:
            state.currentSpeed = getNewSpeed(difHum, true);
            break;
        case MODE_HUM_UP:
            state.currentSpeed = getNewSpeed(difHum, false);
            break;
        case MODE_TEMP_DOWN:
            state.currentSpeed = getNewSpeed(difTemp, true);
            break;
        case MODE_TEMP_UP:
            state.currentSpeed = getNewSpeed(difTemp, false);
            break;
        case MODE_SLAVE:
            state.currentSpeed = state.max_speed_day();
            break;
        default:
            state.currentSpeed  = 0;
            break;
        }
    }

    void DuctFan::update()
    {
        loadSensorData();
        updateSpeed();
        setSpeed();
    }

} // DuctFan