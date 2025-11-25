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
    
    @State private var color: Color
    @State private var level: Double
    
    init(current: Double, target: Double) {
        self.current = current
        self.target = target
        
        let calculated = colorLevelCalc(current: current, target: target)
        _color = State(initialValue: calculated.0)
        _level = State(initialValue: calculated.1)
    }
    
    var body: some View {
        Image(systemName: "thermometer.high", variableValue: level)
            .symbolRenderingMode(.palette)
            .foregroundStyle(color, .gray)
            .symbolVariableValueMode(.draw)
            .animation(.easeInOut(duration: 0.5), value: level)
    }
}
