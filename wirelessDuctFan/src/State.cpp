//
// Created by Valentin Werner on 08.11.25.
//

#include "State.h"

namespace DuctFan
{
    void State::init()
    {
        currentTemp = 0;
        currentHum = 0;
        currentSpeed = 0;
        currentTargetTemp = 0;
        currentTargetHum = 0;
        currentMaxSpeed = 0;

        preferences.begin("ductFanState", true);

        currentMode = static_cast<MODE>(preferences.getInt("currentMode", MODE_SLAVE));

        targetTempDay = preferences.getFloat("targetTempDay", 24.f);
        targetHumDay = preferences.getFloat("targetHumDay", 40.f);
        targetTempNight = preferences.getFloat("targetTempNight", 20.f);
        targetHumNight = preferences.getFloat("targetHumNight", 50.f);

        startNightTime = preferences.getInt("startNightTime", 2300);
        startDayTime = preferences.getInt("startDayTime", 600);

        startQuietTime = preferences.getInt("startQuietTime", 2300);
        startLoudTime = preferences.getInt("startLoudTime", 600);

        maxSpeedLoud = preferences.getInt("maxSpeedLoud", 100);
        maxSpeedQuiet = preferences.getInt("maxSpeedQuiet", 50);

        startFadeTimeDay = preferences.getInt("startFDay", 500);
        startFadeTimeNight = preferences.getInt("startFNight", 2200);

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
        jsonDoc["currentMaxSpeed"] = currentMaxSpeed;
        jsonDoc["currentMode"] = current_mode();
        jsonDoc["targetTempDay"] = target_temp_day();
        jsonDoc["targetHumDay"] = target_hum_day();
        jsonDoc["targetTempNight"] = target_temp_night();
        jsonDoc["targetHumNight"] = target_hum_night();
        jsonDoc["startNightTime"] = start_night_time();
        jsonDoc["startDayTime"] = start_day_time();
        jsonDoc["startQuietTime"] = start_quiet_time();
        jsonDoc["startLoudTime"] = start_loud_time();
        jsonDoc["maxSpeedLoud"] = max_speed_loud();
        jsonDoc["maxSpeedQuiet"] = max_speed_quiet();
        jsonDoc["startFadeTimeNight"] = start_fade_time_night();
        jsonDoc["startFadeTimeDay"] = start_fade_time_day();
        jsonDoc["isDayTime"] = isDayTime;
        jsonDoc["isLoudTime"] = isLoudTime;
        jsonDoc["isFadeDayTime"] = isFadeDayTime;
        jsonDoc["isFadeNightTime"] = isFadeNightTime;

        return jsonDoc;
    }


} // DuctFan