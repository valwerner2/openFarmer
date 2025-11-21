#include <Arduino.h>
#include <WiFi.h>
#include <AsyncTCP.h>
#include <ESPAsyncWebServer.h>

#include "DeviceBroadcaster.h"
#include "DuctFan.h"
#include "wifiPassword.h"

#define MYTZ "CET-1CEST-2,M3.5.0,M10.5.0/3"
struct tm tInfo;

IOT::DeviceBroadcaster broadcaster("ductFan");
AsyncWebServer server(80);

DuctFan::DuctFan ductFan;

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

void updateTime(const uint32_t timeout) {
    uint32_t start = millis();
    do {
        time_t now = time(nullptr);
        tInfo = *localtime(&now);
        delay(1);
    } while (millis() - start < timeout  && tInfo.tm_year <= (1970 - 1900));
}

void initTime()
{
    configTzTime(MYTZ, "time.google.com", "time.windows.com", "pool.ntp.org");
    updateTime(5000);
}

int getIntTime()
{
    char buffer[5];
    sprintf(buffer, "%2d%02d", tInfo.tm_hour, tInfo.tm_min);
    return atoi(buffer);
}

void setup() {
    Serial.begin(115200);
    delay(1000);
    initWifi();
    initTime();

    ductFan.init(server);

    //ductFan.state.set_current_mode(DuctFan::MODE_TEMP_DOWN);
    //ductFan.state.set_max_speed_day(100);
    //ductFan.state.set_target_temp_day(24.f);
    broadcaster.init(server);

    server.begin();
}

void loop() {
    ductFan.update(getIntTime());
    broadcaster.sendBroadcast(5000, ductFan.state.asJson());
}