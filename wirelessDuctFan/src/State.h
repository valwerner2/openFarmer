//
// Created by Valentin Werner on 08.11.25.
//

#ifndef WIRELESSDUCTFAN_STATE_H
#define WIRELESSDUCTFAN_STATE_H
#include <Preferences.h>

namespace DuctFan
{
    enum MODE {MODE_HUM_DOWN, MODE_HUM_UP, MODE_TEMP_DOWN, MODE_TEMP_UP, MODE_SLAVE};

    class State
    {
    public:
        float currentTemp;
        float currentHum;
        int currentSpeed;

    private:
        MODE currentMode;

    private:
        float targetTempDay;

    private:
        float targetTempNight;
        float targetHumDay;
        float targetHumNight;
        int startNightTime;
        int startDayTime;

        int maxSpeedDay;
        int maxSpeedNight;
        Preferences preferences;

    public:
        MODE current_mode() const
        {
            return currentMode;
        }
        float target_temp_day() const
        {
            return targetTempDay;
        }
        float target_temp_night() const
        {
            return targetTempNight;
        }
        float target_hum_day() const
        {
            return targetHumDay;
        }
        float target_hum_night() const
        {
            return targetHumNight;
        }
        int start_night_time() const
        {
            return startNightTime;
        }
        int start_day_time() const
        {
            return startDayTime;
        }
        int max_speed_day() const
        {
            return maxSpeedDay;
        }
        int max_speed_night() const
        {
            return maxSpeedNight;
        }

        void set_current_mode(const MODE current_mode)
        {
            preferences.begin("ductFanState", false);
            currentMode = current_mode;
            preferences.putInt("currentMode", currentMode);
            preferences.end();
        }
        void set_target_temp_day(const float target_temp_day)
        {
            preferences.begin("ductFanState", false);
            targetTempDay = target_temp_day;
            preferences.putFloat("targetTempDay", targetTempDay);
            preferences.end();
        }
        void set_target_temp_night(const float target_temp_night)
        {
            preferences.begin("ductFanState", false);
            targetTempNight = target_temp_night;
            preferences.putFloat("targetTempNight", targetTempNight);
            preferences.end();
        }
        void set_target_hum_day(const float target_hum_day)
        {
            preferences.begin("ductFanState", false);
            targetHumDay = target_hum_day;
            preferences.putFloat("targetHumDay", targetHumDay);
            preferences.end();
        }
        void set_target_hum_night(const float target_hum_night)
        {
            preferences.begin("ductFanState", false);
            targetHumNight = target_hum_night;
            preferences.putFloat("targetHumNight", targetHumNight);
            preferences.end();
        }
        void set_start_night_time(const int start_night_time)
        {
            preferences.begin("ductFanState", false);
            startNightTime = start_night_time;
            preferences.putInt("startNightTime", startNightTime);
            preferences.end();
        }
        void set_start_day_time(const int start_day_time)
        {
            preferences.begin("ductFanState", false);
            startDayTime = start_day_time;
            preferences.putInt("startDayTime", startDayTime);
            preferences.end();
        }
        void set_max_speed_day(const int max_speed_day)
        {
            preferences.begin("ductFanState", false);
            maxSpeedDay = max_speed_day;
            preferences.putInt("maxSpeedDay", maxSpeedDay);
            preferences.end();
        }
        void set_max_speed_night(const int max_speed_night)
        {
            preferences.begin("ductFanState", false);
            maxSpeedNight = max_speed_night;
            preferences.putInt("maxSpeedNight", maxSpeedNight);
            preferences.end();
        }

        State();
    };
} // DuctFan

#endif //WIRELESSDUCTFAN_STATE_H