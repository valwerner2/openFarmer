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
    
    var body: some View {
        TabView{
            Tab("info", systemImage: "info") {
                Text("info")
            }
            .badge("i")
            Tab("PlantServer", systemImage: "server.rack"){
                Text("lights")
            }
            Tab("Humidifier", systemImage: "engine.emission.and.drop.2.water.wave.below"){
                Text("sensors")
            }
            Tab("settings", systemImage: "gear"){
                Text("settings")
            }
            
        }
    }
}

#Preview {
    MainView()
        .modelContainer(for: [], inMemory: true)
}
