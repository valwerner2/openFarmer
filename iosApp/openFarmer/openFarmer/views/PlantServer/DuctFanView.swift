//
//  DuctFanView.swift
//  openFarmer
//
//  Created by Valentin Werner on 21.11.25.
//

import SwiftUI

struct DuctFanView: View {
    @StateObject private var udpListener = UDPListener()
    
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(Array(udpListener.ductFans.values)){ ductFan in
                    Section(ductFan.name){
                        VStack(alignment: .leading){
                            HStack(alignment: .top){
                                Label("Temperature" ,systemImage: "thermometer.medium")
                                Spacer()
                                VStack {
                                    HStack {
                                        Label("Current" ,systemImage: "play")
                                        Spacer ()
                                        Text(String(format: "%.02f", ductFan.info.currentTemp))
                                    }.padding(.bottom, 4)
                                    
                                    HStack {
                                        Label("Target" ,systemImage: "target")
                                        Spacer ()
                                        Text(String(format: "%.02f", ductFan.info.currentTargetTemp))
                                    }.padding(.bottom, 4)
                                    
                                    if(!ductFan.info.isDayTime)
                                    {
                                        HStack {
                                            Label("Day" ,systemImage: "sun.max")
                                            Spacer ()
                                            Text(String(format: "%.02f", ductFan.info.targetTempDay))
                                        }.padding(.bottom, 4)
                                    }else{
                                        HStack {
                                            Label("Night" ,systemImage: "moon.zzz")
                                            Spacer ()
                                            Text(String(format: "%.02f", ductFan.info.targetTempNight))
                                        }.padding(.bottom, 4)
                                    }
                                }
                                .frame(width: 187, alignment: .topLeading)
                            }.padding(.bottom, 10)
                            
                            HStack(alignment: .top){
                                Label("Humidity" ,systemImage: "humidity")
                                Spacer()
                                VStack {
                                    HStack {
                                        Label("Current" ,systemImage: "play")
                                        Spacer ()
                                        Text(String(format: "%.02f", ductFan.info.currentHum))
                                    }.padding(.bottom, 4)
                                    
                                    HStack {
                                        Label("Target" ,systemImage: "target")
                                        Spacer ()
                                        Text(String(format: "%.02f", ductFan.info.currentTargetHum))
                                    }.padding(.bottom, 4)
                                    
                                    if(!ductFan.info.isDayTime)
                                    {
                                        HStack {
                                            Label("Day" ,systemImage: "sun.max")
                                            Spacer ()
                                            Text(String(format: "%.02f", ductFan.info.targetHumDay))
                                        }.padding(.bottom, 4)
                                    }else{
                                        HStack {
                                            Label("Night" ,systemImage: "moon.zzz")
                                            Spacer ()
                                            Text(String(format: "%.02f", ductFan.info.targetHumNight))
                                        }.padding(.bottom, 4)
                                    }
                                }.frame(width: 187, alignment: .topLeading)
                            }.padding(.bottom, 10)
                            
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
                                        }.padding(.bottom, 4)
                                    }else{
                                        HStack {
                                            Label("Max Night" ,systemImage: "moon.zzz")
                                            Spacer ()
                                            Text(String(format: "%d", ductFan.info.maxSpeedQuiet))
                                        }.padding(.bottom, 4)
                                    }
                                }.frame(width: 187, alignment: .topLeading)
                            }.padding(.bottom, 10)
                        }
                    }
                }
            }
            .navigationTitle("DuctFans")
            .onAppear {
                print("onAppear")
                udpListener.startListening()
            }
            .onDisappear {
                print("onDisappear")
                udpListener.stopListening()
            }
        }
    }
}
