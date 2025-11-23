//
//  MainView.swift
//  openFarmer
//
//  Created by Valentin Werner on 04.10.25.
//

import SwiftUI
import SwiftData

struct MainView: View {
    //@StateObject private var udpListener = UDPListener(port: 4210)
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Info", systemImage: "info", value: 0) {
                Label("Calendar", systemImage: "calendar")
            }
            .badge("i")
            
            Tab("DuctFans", systemImage: "fan", value: 1){
                DuctFanView()
            }
            
            Tab("Humidifier", systemImage: "engine.emission.and.drop.2.water.wave.below", value: 2){
                Text("sensors")
            }
            
            Tab("settings", systemImage: "gear", value: 3){
                Text("settings")
            }
            
            
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: [], inMemory: true)
}
