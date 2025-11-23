//
//  MainView.swift
//  openFarmer
//
//  Created by Valentin Werner on 04.10.25.
//

import SwiftUI
import SwiftData

let paddingRow = 4.0
let paddingSection = 10.0

struct MainView: View {
    //@StateObject private var udpListener = UDPListener(port: 4210)
    @State private var selectedTab = 2
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Info", systemImage: "info", value: 0) {
                Label("Calendar", systemImage: "calendar")
            }
            .badge("i")
            
            Tab("Lights", systemImage: "lightbulb.max", value: 1){
                Text("sensors")
            }
            
            Tab("DuctFans", systemImage: "fan", value: 2){
                DuctFanView()
            }
            
            Tab("Humidity", systemImage: "humidity", value: 3){
                Text("sensors")
            }
            
            Tab("settings", systemImage: "gear", value: 4){
                Text("settings")
            }
            
            
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: [], inMemory: true)
}
