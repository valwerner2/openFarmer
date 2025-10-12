//
//  LightInfoView.swift
//  openFarmer
//
//  Created by Valentin Werner on 12.10.25.
//

import SwiftUI

struct LightInfoView: View {
    let brightness: Int
    let possition: String
    let zones: Bool
    let mode: String
    
    var body: some View {
        VStack{
            if zones{
                HStack{
                    Text(possition).bold()
                    Spacer()
                }
            }
            HStack{
                Text("Brightness")
                Spacer()
                Text(String(brightness) + "%")
            }
            HStack{
                Text("Mode")
                Spacer()
                Text(mode)
            }
        }
    }
}
