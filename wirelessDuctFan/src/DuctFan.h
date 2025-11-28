//
// Created by Valentin Werner on 10.11.25.
//

#ifndef WIRELESSDUCTFAN_DUCTFAN_H
#define WIRELESSDUCTFAN_DUCTFAN_H

#include "Adafruit_SHT4x.h"
#include "State.h"
#include <AsyncTCP.h>
#include <ESPAsyncWebServer.h>

namespace DuctFan
{
    class DuctFan
    {
    public:
        State state;
    private:
        const int PWM_FAN_OUTPUT = 2;
        Adafruit_SHT4x sht4;

    public:
        DuctFan();
        void init(AsyncWebServer& server);
        void update(int currentTime, unsigned long msInterval = 1000);
    private:
        float fadedTarget(int startTime, int endTime, float startTarget, float endTarget, int currentTime);
        template<typename T>
        void addServerEndpoint(AsyncWebServer& server, const String& docName, void (State::*setter)(T));
        void loadSensorData();
        void setSpeed();
        int getNewSpeed(int currentSpeed, float diff, bool down);
        void updateSpeed();
        void updateCurrent(int currentTime);
    };
} // DuctFan

#endif //WIRELESSDUCTFAN_DUCTFAN_H