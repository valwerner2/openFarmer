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
                        DuctFanDetailView(ductFan: ductFan)
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
            .toolbar {
                EditButton()
            }
        }
    }
}
