//
//  DuctFanDetailEditView.swift
//  openFarmer
//
//  Created by Valentin Werner on 23.11.25.
//

import SwiftUI

public extension Binding {

    static func convert<TInt, TFloat>(_ intBinding: Binding<TInt>) -> Binding<TFloat>
    where TInt:   BinaryInteger,
          TFloat: BinaryFloatingPoint{

        Binding<TFloat> (
            get: { TFloat(intBinding.wrappedValue) },
            set: { intBinding.wrappedValue = TInt($0) }
        )
    }

    static func convert<TFloat, TInt>(_ floatBinding: Binding<TFloat>) -> Binding<TInt>
    where TFloat: BinaryFloatingPoint,
          TInt:   BinaryInteger {

        Binding<TInt> (
            get: { TInt(floatBinding.wrappedValue) },
            set: { floatBinding.wrappedValue = TFloat($0) }
        )
    }
}

struct DuctFanDetailEditView: View {
    let ductFanCurrent: DuctFan
    let httpClient = HTTPClient();
    
    @State var ductFanEdit: DuctFan
    
    @State var dateStartLoud : Date
    @State var dateStartQuiet : Date
    @State var dateStartDay : Date
    @State var dateStartNight : Date
    @State var dateStartDayFade : Date
    @State var dateStartNightFade : Date
    @State var fading: Bool
    
    init(ductFanCurrent: DuctFan, ductFanEdit: DuctFan) {
        print("INIT EDIT")
        self.ductFanCurrent = ductFanCurrent
        self.ductFanEdit = ductFanEdit
        self.dateStartLoud = Date(time: ductFanEdit.info.startLoudTime)
        self.dateStartQuiet = Date(time: ductFanEdit.info.startQuietTime)
        self.dateStartDay = Date(time: ductFanEdit.info.startDayTime)
        self.dateStartNight = Date(time: ductFanEdit.info.startNightTime)
        self.dateStartDayFade = Date(time: ductFanEdit.info.startFadeTimeDay)
        self.dateStartNightFade = Date(time: ductFanEdit.info.startFadeTimeNight)
        self.fading = ductFanEdit.info.startDayTime != ductFanEdit.info.startFadeTimeDay && ductFanEdit.info.startNightTime != ductFanEdit.info.startFadeTimeNight
    }
    
    var body: some View {
        VStack(alignment: .leading){
            VStack(alignment: .leading){
                Text("Name")
                TextField("Name", text: $ductFanEdit.name)
                    .textFieldStyle(.roundedBorder)
            }.padding(.bottom, paddingSection)
            
            Picker("Mode", selection: $ductFanEdit.info.currentMode) {
               ForEach(DuctFanMode.allCases) { mode in
                   Text(mode.label).tag(mode)
               }
           }
           .pickerStyle(MenuPickerStyle())
           .padding(.bottom, paddingSection)
            
            if(ductFanEdit.info.currentMode == DuctFanMode.tempDown ||
               ductFanEdit.info.currentMode == DuctFanMode.tempUp)
            {
                DuctFanDayNightVStack(title: "Temperature", dayvar: $ductFanEdit.info.targetTempDay, nightVar: $ductFanEdit.info.targetTempNight)
                    .padding(.bottom, paddingSection)
                
            }
            if(ductFanEdit.info.currentMode == DuctFanMode.humDown ||
               ductFanEdit.info.currentMode == DuctFanMode.humUp)
            {
                DuctFanDayNightVStack(title: "Humidity", dayvar: $ductFanEdit.info.targetHumDay, nightVar: $ductFanEdit.info.targetHumNight)
                    .padding(.bottom, paddingSection)
            }
            if(ductFanEdit.info.currentMode != DuctFanMode.slave){
                VStack(alignment: .leading){
                    Text("Speed")
                    HStack{
                        Image(systemName: "speaker.wave.2")
                            .foregroundStyle(.tint)
                        TextField("Loud", value: $ductFanEdit.info.maxSpeedLoud, format:
                                .number)
                        .textFieldStyle(.roundedBorder)
                        
                        Image(systemName: "speaker.slash")
                            .foregroundStyle(.tint)
                        TextField("Quiet", value: $ductFanEdit.info.maxSpeedQuiet, format:
                                .number)
                        .textFieldStyle(.roundedBorder)
                    }
                }.padding(.bottom, paddingSection)
                
                VStack(alignment: .leading){
                    Text("Lound Time")
                    HStack{
                        Image(systemName: "speaker.wave.2")
                            .foregroundStyle(.tint)
                        DatePicker("Start",
                                   selection: $dateStartLoud,
                                   displayedComponents: [.hourAndMinute]
                        )
                        
                        Image(systemName: "speaker.slash")
                            .foregroundStyle(.tint)
                        DatePicker("End",
                                   selection: $dateStartQuiet,
                                   displayedComponents: [.hourAndMinute]
                        )
                    }
                }.padding(.bottom, paddingSection)
                
                VStack(alignment: .leading){
                    Toggle(
                        "Fade Day/Night",
                        systemImage: "sun.haze",
                        isOn: $fading
                    ).padding(.bottom, paddingSection)
                    
                    if(!fading)
                    {
                        VStack(alignment: .leading){
                            Text("Day Time")
                            HStack{
                                Image(systemName: "sun.max")
                                    .foregroundStyle(.tint)
                                DatePicker("Start",
                                           selection: $dateStartDay,
                                           displayedComponents: [.hourAndMinute]
                                )
                                
                                Image(systemName: "moon.zzz")
                                    .foregroundStyle(.tint)
                                DatePicker("End",
                                           selection: $dateStartNight,
                                           displayedComponents: [.hourAndMinute]
                                )
                            }
                        }
                    }
                    else{
                        VStack(alignment: .leading){
                            Text("Day")
                            HStack{
                                Image(systemName: "sun.haze")
                                    .foregroundStyle(.tint)
                                DatePicker("Rise",
                                           selection: $dateStartDayFade,
                                           displayedComponents: [.hourAndMinute]
                                )
                                Image(systemName: "sun.max")
                                    .foregroundStyle(.tint)
                                DatePicker("Day",
                                           selection: $dateStartDay,
                                           displayedComponents: [.hourAndMinute]
                                )
                            }
                        }.padding(.bottom, paddingSection)
                        VStack(alignment: .leading){
                            Text("Night")
                            HStack{
                                Image(systemName: "moon.haze")
                                    .foregroundStyle(.tint)
                                DatePicker("Rise",
                                           selection: $dateStartNightFade,
                                           displayedComponents: [.hourAndMinute]
                                )
                                Spacer()
                                Image(systemName: "moon.zzz")
                                    .foregroundStyle(.tint)
                                DatePicker("Night",
                                           selection: $dateStartNight,
                                           displayedComponents: [.hourAndMinute]
                                )
                            }
                        }
                    }
                }
            }else{
                VStack(alignment: .leading){
                    Text("Speed")
                    Slider(
                        value: .convert($ductFanEdit.info.maxSpeedLoud),
                        in: 0...100,
                        step: 1
                    ) {
                        Text("Speed")
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("100")
                    }
                    Text("\(ductFanEdit.info.maxSpeedLoud)")
                }
            }
            
        }
        .onChange(of: fading){_ , newValue in
            if (newValue)
            {
                self.dateStartDayFade = Calendar.current.date(byAdding: .hour, value: -1, to: self.dateStartDay)!
                self.dateStartNightFade = Calendar.current.date(byAdding: .hour, value: -1, to: self.dateStartNight)!
            }else{
                self.dateStartDayFade = Calendar.current.date(byAdding: .hour, value: 0, to: self.dateStartDay)!
                self.dateStartNightFade = Calendar.current.date(byAdding: .hour, value: 0, to: self.dateStartNight)!
            }
                
        }
        .onAppear{
            ductFanEdit = ductFanCurrent
            self.dateStartLoud = Date(time: ductFanEdit.info.startLoudTime)
            self.dateStartQuiet = Date(time: ductFanEdit.info.startQuietTime)
            self.dateStartDay = Date(time: ductFanEdit.info.startDayTime)
            self.dateStartNight = Date(time: ductFanEdit.info.startNightTime)
        }
        .onDisappear {
            if ductFanCurrent.name != ductFanEdit.name{
                httpClient.send(url: "http://" +  ductFanEdit.ip + "/deviceBroadcaster/name", key: "name", value: ductFanEdit.name)
            }
            if ductFanCurrent.info.currentMode != ductFanEdit.info.currentMode{
                httpClient.send(url: "http://" +  ductFanEdit.ip + "/ductFan/currentMode", key: "currentMode", value: String(ductFanEdit.info.currentMode.rawValue))
            }
            
            if ductFanCurrent.info.targetTempDay != ductFanEdit.info.targetTempDay{
                httpClient.send(url: "http://" +  ductFanEdit.ip + "/ductFan/targetTempDay", key: "targetTempDay", value: String(ductFanEdit.info.targetTempDay))
            }
            
            if ductFanCurrent.info.targetTempNight != ductFanEdit.info.targetTempNight{
                httpClient.send(url: "http://" +  ductFanEdit.ip + "/ductFan/targetTempNight", key: "targetTempNight", value: String(ductFanEdit.info.targetTempNight))
            }
            
            if ductFanCurrent.info.targetHumDay != ductFanEdit.info.targetHumDay{
                httpClient.send(url: "http://" +  ductFanEdit.ip + "/ductFan/targetHumDay", key: "targetHumDay", value: String(ductFanEdit.info.targetHumDay))
            }
            
            if ductFanCurrent.info.targetHumNight != ductFanEdit.info.targetHumNight{
                httpClient.send(url: "http://" +  ductFanEdit.ip + "/ductFan/targetHumNight", key: "targetHumNight", value: String(ductFanEdit.info.targetHumNight))
            }
            
            if ductFanCurrent.info.maxSpeedLoud != ductFanEdit.info.maxSpeedLoud{
                httpClient.send(url: "http://" +  ductFanEdit.ip + "/ductFan/maxSpeedLoud", key: "maxSpeedLoud", value: String(ductFanEdit.info.maxSpeedLoud))
            }
            if ductFanCurrent.info.maxSpeedQuiet != ductFanEdit.info.maxSpeedQuiet{
                httpClient.send(url: "http://" +  ductFanEdit.ip + "/ductFan/maxSpeedQuiet", key: "maxSpeedQuiet", value: String(ductFanEdit.info.maxSpeedQuiet))
            }
            
            if ductFanCurrent.info.startDayTime != dateStartDay.toTimeInt(){
                httpClient.send(url: "http://" +  ductFanEdit.ip + "/ductFan/startDayTime", key: "startDayTime", value: String(dateStartDay.toTimeInt()))
            }
            if ductFanCurrent.info.startNightTime != dateStartNight.toTimeInt(){
                httpClient.send(url: "http://" +  ductFanEdit.ip + "/ductFan/startNightTime", key: "startNightTime", value: String(dateStartNight.toTimeInt()))
            }
            if ductFanCurrent.info.startLoudTime != dateStartLoud.toTimeInt(){
                httpClient.send(url: "http://" +  ductFanEdit.ip + "/ductFan/startLoudTime", key: "startLoudTime", value: String(dateStartLoud.toTimeInt()))
            }
            if ductFanCurrent.info.startQuietTime != dateStartQuiet.toTimeInt(){
                httpClient.send(url: "http://" +  ductFanEdit.ip + "/ductFan/startQuietTime", key: "startQuietTime", value: String(dateStartQuiet.toTimeInt()))
            }
            if ductFanCurrent.info.startFadeTimeDay != dateStartDayFade.toTimeInt(){
                httpClient.send(url: "http://" +  ductFanEdit.ip + "/ductFan/startFadeTimeDay", key: "startFadeTimeDay", value: String(dateStartDayFade.toTimeInt()))
            }
            if ductFanCurrent.info.startFadeTimeNight != dateStartNightFade.toTimeInt(){
                httpClient.send(url: "http://" +  ductFanEdit.ip + "/ductFan/startFadeTimeNight", key: "startFadeTimeNight", value: String(dateStartNightFade.toTimeInt()))
            }
        }
    }
}

struct DuctFanDayNightVStack: View {
    let title: String
    @Binding var dayvar: Double
    @Binding var nightVar: Double
    
    var body: some View {
        VStack(alignment: .leading){
            Text(title)
            HStack{
                Image(systemName: "sun.max")
                    .foregroundStyle(.tint)
                TextField("Day", value: $dayvar, format:
                        .number)
                .textFieldStyle(.roundedBorder)
                
                Image(systemName: "moon.zzz")
                    .foregroundStyle(.tint)
                TextField("Night", value: $nightVar, format:
                        .number)
                .textFieldStyle(.roundedBorder)
            }
        }
    }
}
