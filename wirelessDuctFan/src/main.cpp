#include <Arduino.h>
#include <WiFi.h>
#include <AsyncTCP.h>
#include <ESPAsyncWebServer.h>

#include "DeviceBroadcaster.h"
#include "DuctFan.h"
#include "wifiPassword.h"

IOT::DeviceBroadcaster broadcaster("ductFan", "DuctFan");
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

void setup() {
    Serial.begin(115200);
    delay(1000);
    initWifi();

    ductFan.init(server);

    ductFan.state.set_current_mode(DuctFan::MODE_TEMP_DOWN);
    ductFan.state.set_max_speed_day(100);
    ductFan.state.set_target_temp_day(24.f);
    broadcaster.setup(server);

    server.begin();
}

void loop() {
    ductFan.update();
    broadcaster.sendBroadcast(5000, ductFan.state.asJson());
}