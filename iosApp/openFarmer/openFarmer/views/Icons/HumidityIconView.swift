//
//  HumidityIconView 2.swift
//  openFarmer
//
//  Created by Valentin Werner on 25.11.25.
//


import SwiftUI

struct HumidityIconView: View {
    let current: Double
    let target: Double
    
    let color: Color
    let level: Double
    
    init(current: Double, target: Double) {
        self.current = current
        self.target = target
        
        let calculated = colorLevelCalc(current: current, target: target)
        color = calculated.0
        level = calculated.1 - 0.15
    }
    
    var body: some View {
        Image(systemName: "humidity", variableValue: level)
            .symbolRenderingMode(.palette)
            .foregroundStyle(.blue, color)
            .symbolVariableValueMode(.color)
            .animation(.easeInOut(duration: 0.5), value: level)
    }
}
