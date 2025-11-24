//
//  DuctFanDetailView.swift
//  openFarmer
//
//  Created by Valentin Werner on 23.11.25.
//

import SwiftUI

struct DuctFanDetailView: View {
    let ductFan: DuctFan 
    
    @State var ductFanCopy: DuctFan?
    
    @Environment(\.editMode) private var editMode
    
    var body: some View {
        VStack(alignment: .leading){
            if editMode?.wrappedValue.isEditing == true {
                if let ductFanToEdit = ductFanCopy{
                    DuctFanDetailEditView(ductFanCurrent: ductFan, ductFanEdit: ductFanToEdit)
                }
                
            }
            else{
                HStack(alignment: .top){
                    Label("Temperature" ,systemImage: "thermometer.medium")
                    Spacer()
                    VStack {
                        HStack {
                            Label("Current" ,systemImage: "play")
                            Spacer ()
                            Text(String(format: "%.02f", ductFan.info.currentTemp))
                        }.padding(.bottom, paddingRow)
                        
                        HStack {
                            Label("Target" ,systemImage: "target")
                            Spacer ()
                            Text(String(format: "%.02f", ductFan.info.currentTargetTemp))
                        }.padding(.bottom, paddingRow)
                        
                        if(!ductFan.info.isDayTime)
                        {
                            HStack {
                                Label("Day" ,systemImage: "sun.max")
                                Spacer ()
                                Text(String(format: "%.02f", ductFan.info.targetTempDay))
                            }.padding(.bottom, paddingRow)
                        }else{
                            HStack {
                                Label("Night" ,systemImage: "moon.zzz")
                                Spacer ()
                                Text(String(format: "%.02f", ductFan.info.targetTempNight))
                            }.padding(.bottom, paddingRow)
                        }
                    }
                    .frame(width: 187, alignment: .topLeading)
                }.padding(.bottom, paddingSection)
                
                HStack(alignment: .top){
                    Label("Humidity" ,systemImage: "humidity")
                    Spacer()
                    VStack {
                        HStack {
                            Label("Current" ,systemImage: "play")
                            Spacer ()
                            Text(String(format: "%.02f", ductFan.info.currentHum))
                        }.padding(.bottom, paddingRow)
                        
                        HStack {
                            Label("Target" ,systemImage: "target")
                            Spacer ()
                            Text(String(format: "%.02f", ductFan.info.currentTargetHum))
                        }.padding(.bottom, paddingRow)
                        
                        if(!ductFan.info.isDayTime)
                        {
                            HStack {
                                Label("Day" ,systemImage: "sun.max")
                                Spacer ()
                                Text(String(format: "%.02f", ductFan.info.targetHumDay))
                            }.padding(.bottom, paddingRow)
                        }else{
                            HStack {
                                Label("Night" ,systemImage: "moon.zzz")
                                Spacer ()
                                Text(String(format: "%.02f", ductFan.info.targetHumNight))
                            }.padding(.bottom, paddingRow)
                        }
                    }.frame(width: 187, alignment: .topLeading)
                }.padding(.bottom, paddingSection)
                
                HStack{
                    Label("Speed" ,systemImage: "fan")
                    Spacer()
                    
                    VStack{
                        HStack{
                            Text(String(format: "%d", ductFan.info.currentSpeed))
                            Text("/")
                            Text(String(format: "%d",ductFan.info.isDayTime ? ductFan.info.maxSpeedLoud : ductFan.info.maxSpeedQuiet))
                        }
                        if(!ductFan.info.isDayTime)
                        {
                            HStack {
                                Label("Max Day" ,systemImage: "sun.max")
                                Spacer ()
                                Text(String(format: "%d", ductFan.info.maxSpeedLoud))
                            }.padding(.bottom, paddingRow)
                        }else{
                            HStack {
                                Label("Max Night" ,systemImage: "moon.zzz")
                                Spacer ()
                                Text(String(format: "%d", ductFan.info.maxSpeedQuiet))
                            }.padding(.bottom, paddingRow)
                        }
                    }.frame(width: 187, alignment: .topLeading)
                }.padding(.bottom, paddingSection)
            }
        }
        .onChange(of: editMode?.wrappedValue.isEditing) { _, isEditing in
            self.ductFanCopy = ductFan
        }
    }
}
