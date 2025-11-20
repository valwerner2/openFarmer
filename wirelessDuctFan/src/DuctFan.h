//
// Created by Valentin Werner on 10.11.25.
//

#ifndef WIRELESSDUCTFAN_DUCTFAN_H
#define WIRELESSDUCTFAN_DUCTFAN_H

#include "Adafruit_SHT4x.h"
#include "State.h"

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
        void init();
        void update();
    private:
        void loadSensorData();
        void setSpeed();
        int getNewSpeed(int currentSpeed, float diff, bool down);
        void updateSpeed();
    };
} // DuctFan

#endif //WIRELESSDUCTFAN_DUCTFAN_H