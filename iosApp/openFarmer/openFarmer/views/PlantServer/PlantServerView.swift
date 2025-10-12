//
//  PlantServerView.swift
//  openFarmer
//
//  Created by Valentin Werner on 12.10.25.
//

import SwiftUI

struct PlantServerView: View {
    @Environment(\.editMode) private var editMode
    
    @State var data = PlantServerData()
    
    var body: some View {
        NavigationStack{
            List{
                Section("Lights"){
                    LightView(data: $data)
                }
                Section("Outlets"){
                }
                Section("Exhaust"){
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
            .navigationTitle("PlantServer")
        }
        
    }
}
