//
//  DuctFanDetailEditView.swift
//  openFarmer
//
//  Created by Valentin Werner on 23.11.25.
//

import SwiftUI

struct DuctFanDetailEditView: View {
    let ductFanCurrent: DuctFan
    
    @State var ductFanEdit: DuctFan
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Label(String(format: "%.02f", ductFanCurrent.info.currentTemp) ,systemImage: "thermometer.medium")
                Spacer()
                Label(String(format: "%.02f", ductFanCurrent.info.currentHum) ,systemImage: "humidity")
                Spacer()
                Label(String(ductFanCurrent.info.currentSpeed) ,systemImage: "fan")
                Spacer()
                Image(systemName: ductFanCurrent.info.isDayTime ? "sun.max" : "moon.zzz")
                    .foregroundStyle(.tint)
                Spacer()
                Image(systemName: ductFanCurrent.info.isDayTime ? "speaker.wave.2" : "speaker.slash")
                    .foregroundStyle(.tint)
            }.padding(.bottom, paddingRow)
            
            Text(String(format: "%.02f",ductFanEdit.info.currentTemp))
        }
    }
}
