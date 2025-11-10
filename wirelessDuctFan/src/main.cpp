#include <Arduino.h>
#include <map>
#include "Adafruit_SHT4x.h"
#include <Preferences.h>
#include <WiFi.h>
#include <AsyncTCP.h>
#include <ESPAsyncWebServer.h>


#include "DeviceBroadcaster.h"
#include "wifiPassword.h"
#include "State.h"

const int PWM_FAN_OUTPUT = 2;

Adafruit_SHT4x sht4 = Adafruit_SHT4x();

int maxSpeed = 50;

IOT::DeviceBroadcaster broadcaster("DuctFan");
AsyncWebServer server(80);

DuctFan::State state = DuctFan::State();

void initWifi()
{
    Serial.print("Connecting to WiFi");
    WiFi.begin(ssid, password);
    char connectAnimationBuffer[] = "|/-\\";
    while (WiFi.status() != WL_CONNECTED) {
        for (int i = 0; i < strlen(connectAnimationBuffer); i++)
        {
            Serial.print(connectAnimationBuffer[i]);
            delay(100);
        }
    }
    Serial.println(" Connected!");
    Serial.println(WiFi.localIP());
}

void setFanSpeed(uint8_t speed)
{
    speed = speed > maxSpeed ? maxSpeed : speed;
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

int calcFanSpeed(float diff, bool down)
{
    const float base = 10.f;
    if (down && diff > 0.f)
    {
        return static_cast<int>(diff * base + pow(diff, 2));
    }
    if (!down && diff < 0.f)
    {
        diff = abs(diff);
        return static_cast<int>(diff * base + pow(diff, 2));
    }
    return 0;
}

void updateFanSpeed()
{
    sensors_event_t humidity, temp;
    sht4.getEvent(&humidity, &temp);// populate temp and humidity objects with fresh data

    float difTemp = state.target == 0.f ? 0.f : temp.temperature - state.targetTemp;
    float difHum = state.targetHum == 0.f ? 0.f : humidity.relative_humidity - state.targetHum;

    Serial.printf("\nTemperature: %2.2f -> %2.2f | %2.2f \n", temp.temperature, targetTemp, difTemp);
    Serial.printf("Humidity   : %2.2f -> %2.2f | %2.2f \n", humidity.relative_humidity, targetHum, difHum);


    int newSpeed = 0;
    switch (state.current_mode())
    {
        case DuctFan::MODE_HUM_DOWN:
            newSpeed = calcFanSpeed(difHum, true);
            break;
        case DuctFan::MODE_HUM_UP:
            newSpeed = calcFanSpeed(difHum, false);
            break;
        case DuctFan::MODE_TEMP_DOWN:
            newSpeed = calcFanSpeed(difTemp, true);
            break;
        case DuctFan::MODE_TEMP_UP:
            newSpeed = calcFanSpeed(difTemp, false);
            break;
        case DuctFan::MODE_SLAVE:
            newSpeed = 100;
            break;
        default:
            break;
    }
    Serial.println("New speed: "+ String(newSpeed));
    setFanSpeed(newSpeed);
}

void setup() {
    Serial.begin(115200);
    delay(1000);
    pinMode(PWM_FAN_OUTPUT, OUTPUT);
    sensorSetup();
    broadcaster.setup(server);
}

void loop() {
    updateFanSpeed();
    delay(1000);
    broadcaster.sendBroadcast(5000);
}