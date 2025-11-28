//
//  DuctFanInfoBar.swift
//  openFarmer
//
//  Created by Valentin Werner on 24.11.25.
//


import SwiftUI

struct DuctFanInfoBar: View {
    let ductFanCurrent: DuctFan
    let displayName: Bool = false
    
    @Environment(\.editMode) private var editMode
    
    var body: some View {
        VStack(alignment: .leading,){
            if(displayName)
            {
                HStack{
                    Text(ductFanCurrent.name).bold()
                    Spacer()
                    Text(ductFanCurrent.purpose)
                }.padding(.bottom, paddingSection)
            }
            HStack{
                Label {
                    if(ductFanCurrent.info.currentMode == DuctFanMode.tempDown || ductFanCurrent.info.currentMode == DuctFanMode.tempUp){
                        Text(String(format: "%.02f / %.0f", ductFanCurrent.info.currentTemp, ductFanCurrent.info.currentTargetTemp))
                    }else{
                        Text(String(format: "%.02f", ductFanCurrent.info.currentTemp))
                    }
                } icon: {
                    TemperatureIconView(
                        current: ductFanCurrent.info.currentTemp,
                        target: ductFanCurrent.info.currentTargetTemp
                    )
                }
                Spacer()
                Label {
                    if(ductFanCurrent.info.currentMode == DuctFanMode.humDown || ductFanCurrent.info.currentMode == DuctFanMode.humUp){
                        Text(String(format: "%.02f / %.0f", ductFanCurrent.info.currentHum, ductFanCurrent.info.currentTargetHum))
                    }else{
                        Text(String(format: "%.0f", ductFanCurrent.info.currentHum))
                    }
                } icon: {
                    HumidityIconView(
                        current: ductFanCurrent.info.currentHum,
                        target: ductFanCurrent.info.currentTargetHum
                    )
                }
                Spacer()
                Label(String(ductFanCurrent.info.currentSpeed) ,systemImage: "fan")
                Spacer()
                Image(systemName: ductFanCurrent.info.isDayTime ? ductFanCurrent.info.isFadeNightTime ? "moon.haze" : "sun.max" : ductFanCurrent.info.isFadeDayTime ? "sun.haze" : "moon.zzz")
                    .foregroundStyle(.tint)
                Spacer()
                Image(systemName: ductFanCurrent.info.isLoudTime ? "speaker.wave.2" : "speaker.slash")
                    .foregroundStyle(.tint)
            }.padding(.bottom, paddingSection)
            if editMode?.wrappedValue.isEditing != true {
                HStack()
                {
                    Label("Mode", systemImage: "gear")
                    Spacer()
                    Text(ductFanCurrent.info.currentMode.label)
                }
            }
        }
    }
}
