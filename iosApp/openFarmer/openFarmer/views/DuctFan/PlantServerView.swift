//
//  PlantServerView.swift
//  openFarmer
//
//  Created by Valentin Werner on 12.10.25.
//

import SwiftUI

struct PlantServerView: View {
    @Environment(\.editMode) private var editMode
    var body: some View {
        NavigationStack{
            List{
                Section("DuctFans"){
                    DuctFanView()
                }
            }
            .navigationTitle("PlantServer")
            /*
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }*/
            
        }
        
    }
}
