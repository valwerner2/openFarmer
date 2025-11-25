//
//  TemperatureIconView.swift
//  openFarmer
//
//  Created by Valentin Werner on 25.11.25.
//

import SwiftUI

struct TemperatureIconView: View {
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
        Image(systemName: "thermometer.high", variableValue: level)
            .symbolRenderingMode(.palette)
            .foregroundStyle(.pink, color)
            .symbolVariableValueMode(.draw)
            .animation(.easeInOut(duration: 0.5), value: level)
    }
}
