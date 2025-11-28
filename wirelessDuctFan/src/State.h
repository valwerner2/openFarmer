//
// Created by Valentin Werner on 08.11.25.
//

#ifndef WIRELESSDUCTFAN_STATE_H
#define WIRELESSDUCTFAN_STATE_H
#include <Preferences.h>
#include <ArduinoJson.h>

namespace DuctFan
{
    enum MODE {MODE_HUM_DOWN, MODE_HUM_UP, MODE_TEMP_DOWN, MODE_TEMP_UP, MODE_SLAVE};

    class State
    {
    public:
        float currentTemp = 0;
        float currentHum = 0;
        int currentSpeed = 0;

        float currentTargetTemp = 0;
        float currentTargetHum = 0;
        int currentMaxSpeed = 0;
        bool isDayTime = true;
        bool isLoudTime = true;
        bool isFadeDayTime = true;
        bool isFadeNightTime = true;

    private:
        MODE currentMode = MODE_SLAVE;
        float targetTempDay = 0;
        float targetTempNight = 0;
        float targetHumDay = 0;
        float targetHumNight = 0;
        int startNightTime = 0;
        int startDayTime = 0;
        int startFadeTimeNight = 0;
        int startFadeTimeDay = 0;

        int startQuietTime = 0;
        int startLoudTime = 0;
        int maxSpeedQuiet = 0;
        int maxSpeedLoud = 0;
        Preferences preferences;

    public:
        int start_fade_time_night() const
        {
            return startFadeTimeNight;
        }
        int start_fade_time_day() const
        {
            return startFadeTimeDay;
        }
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
        int start_quiet_time() const
        {
            return startQuietTime;
        }
        int start_loud_time() const
        {
            return startLoudTime;
        }
        int max_speed_loud() const
        {
            return maxSpeedLoud;
        }
        int max_speed_quiet() const
        {
            return maxSpeedQuiet;
        }
        void set_start_fade_time_night(const int start_fade_time_night)
        {
            preferences.begin("ductFanState", false);
            startFadeTimeNight = start_fade_time_night;
            preferences.putInt("startFNight", startFadeTimeNight);
            preferences.end();
        }
        void set_start_fade_time_day(const int start_fade_time_day)
        {
            preferences.begin("ductFanState", false);
            startFadeTimeDay = start_fade_time_day;
            preferences.putInt("startFDay", startFadeTimeDay);
            preferences.end();
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
            Serial.println("Setting humidity day");
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
        void set_start_quiet_time(const int start_quiet_time)
        {
            preferences.begin("ductFanState", false);
            startQuietTime = start_quiet_time;
            preferences.putInt("startQuietTime", startQuietTime);
            preferences.end();
        }
        void set_start_loud_time(const int start_loud_time)
        {
            preferences.begin("ductFanState", false);
            startLoudTime = start_loud_time;
            preferences.putInt("startLoudTime", startLoudTime);
            preferences.end();
        }
        void set_max_speed_loud(const int max_speed_loud)
        {
            preferences.begin("ductFanState", false);
            maxSpeedLoud = max_speed_loud;
            preferences.putInt("maxSpeedLoud", maxSpeedLoud);
            preferences.end();
        }
        void set_max_speed_quiet(const int max_speed_quiet)
        {
            preferences.begin("ductFanState", false);
            maxSpeedQuiet = max_speed_quiet;
            preferences.putInt("maxSpeedQuiet", maxSpeedQuiet);
            preferences.end();
        }

        JsonDocument asJson();
        void init();
    };
} // DuctFan

#endif //WIRELESSDUCTFAN_STATE_H