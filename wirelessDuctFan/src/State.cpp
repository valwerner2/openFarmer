//
// Created by Valentin Werner on 08.11.25.
//

#include "State.h"

namespace DuctFan
{
    State::State()
    {
        preferences.begin("ductFanState", true);

        currentMode = static_cast<MODE>(preferences.getInt("currentMode", MODE_SLAVE));

        targetTempDay = preferences.getFloat("targetTempDay", 0.f);
        targetHumDay = preferences.getFloat("targetHumDay", 0.f);
        targetTempNight = preferences.getFloat("targetTempNight", 0.f);
        targetHumNight = preferences.getFloat("targetHumNight", 0.f);

        startNightTime = preferences.getInt("startNightTime", 0);
        startDayTime = preferences.getInt("startDayTime", 0);

        maxSpeedDay = preferences.getInt("maxSpeedDay", 100);
        maxSpeedNight = preferences.getInt("maxSpeedNight", 50);

        currentTemp = 0.f;
        currentHum = 0.f;

        preferences.end();
    }
    JsonDocument State::asJson()
    {
        JsonDocument jsonDoc;

        jsonDoc["currentTemp"] = currentTemp;
        jsonDoc["currentHum"] = currentHum;
        jsonDoc["currentSpeed"] = currentSpeed;
        jsonDoc["currentTargetTemp"] = currentTargetTemp;
        jsonDoc["currentTargetHum"] = currentTargetHum;
        jsonDoc["currentMode"] = current_mode();
        jsonDoc["targetTempDay"] = target_temp_day();
        jsonDoc["targetHumDay"] = target_hum_day();
        jsonDoc["tagetTempNight"] = target_temp_night();
        jsonDoc["targetHumNight"] = target_hum_night();
        jsonDoc["startNightTime"] = start_night_time();
        jsonDoc["startDayTime"] = start_day_time();
        jsonDoc["maxSpeedDay"] = max_speed_day();
        jsonDoc["maxSpeedNight"] = max_speed_night();

        return jsonDoc;
    }


} // DuctFan