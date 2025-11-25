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
    
    @State private var color: Color
    @State private var level: Double
    
    init(current: Double, target: Double) {
        self.current = current
        self.target = target
        
        let calculated = colorLevelCalc(current: current, target: target)
        _color = State(initialValue: calculated.0)
        _level = State(initialValue: calculated.1 - 0.15)
    }
    
    var body: some View {
        Image(systemName: "humidity", variableValue: level)
            .symbolRenderingMode(.palette)
            .foregroundStyle(.blue, color)
            .symbolVariableValueMode(.color)
            .animation(.easeInOut(duration: 0.5), value: level)
    }
}
