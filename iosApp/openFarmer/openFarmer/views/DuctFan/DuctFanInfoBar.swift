//
//  DuctFanInfoBar.swift
//  openFarmer
//
//  Created by Valentin Werner on 24.11.25.
//


import SwiftUI

struct DuctFanInfoBar: View {
    let ductFanCurrent: DuctFan
    
    var body: some View {
        HStack{
            Label {
                Text(String(format: "%.02f", ductFanCurrent.info.currentTemp))
            } icon: {
                TemperatureIconView(
                    current: ductFanCurrent.info.currentTemp,
                    target: ductFanCurrent.info.currentTargetTemp
                )
            }
            Spacer()
            Label {
                Text(String(format: "%.02f", ductFanCurrent.info.currentHum))
            } icon: {
                HumidityIconView(
                    current: ductFanCurrent.info.currentTemp,
                    target: ductFanCurrent.info.currentTargetTemp
                )
            }
            Spacer()
            Label(String(ductFanCurrent.info.currentSpeed) ,systemImage: "fan")
            Spacer()
            Image(systemName: ductFanCurrent.info.isDayTime ? "sun.max" : "moon.zzz")
                .foregroundStyle(.tint)
            Spacer()
            Image(systemName: ductFanCurrent.info.isLoudTime ? "speaker.wave.2" : "speaker.slash")
                .foregroundStyle(.tint)
        }
    }
}
