//
//  LightView.swift
//  openFarmer
//
//  Created by Valentin Werner on 12.10.25.
//

import SwiftUI

struct LightView: View {
    @Binding var data: PlantServerData
    
    @State private var isEditing = false
    
    @Environment(\.editMode) private var editMode
    
    
    
    var body: some View {
        if editMode?.wrappedValue.isEditing == true {
            HStack{
                Text("2 Zones")
                Spacer()
                Toggle(isOn: $data.lightZones) {
                }
            }
            
            Slider(
                value: Binding(
                    get: { Double(data.lightTopBrightness) },
                    set: { data.lightTopBrightness = Int($0) }
                ),
                in: 0...100,
                step: 5.0
            ) {
                Text("")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("100")
            } onEditingChanged: { editing in
                isEditing = editing
            }
            Text("\(data.lightTopBrightness)")
                .foregroundColor(isEditing ? .red : .blue)
            
        }else{
            LightInfoView(brightness: data.lightTopBrightness, possition: "Top", zones: data.lightZones, mode: data.lightTopControlMode)
            
            
            if(data.lightZones)
            {
                LightInfoView(brightness: data.lightBottomBrightness, possition: "Bottom", zones: data.lightZones, mode: data.lightBottomControlMode)
            }
        }
    }
}
