//
//  colorLevelCalc.swift
//  openFarmer
//
//  Created by Valentin Werner on 25.11.25.
//

import SwiftUI

func colorLevelCalc(current: Double, target: Double) -> (Color, Double) {
    
    let diff = current - target
    var level: Double  = 0.5
    var color: Color = colorPerfect
    
    if(diff > perfectTargetDiff){
        if diff > mediumTargetDiff {
            level = 1
            color =  colorExtremeHigh
        }else{
            level = 0.75
            color = colorMediumHigh
        }
    }
    else if(diff < (-perfectTargetDiff)){
        if abs(diff) > mediumTargetDiff {
            level = 0.1
            color =  colorExtremeLow
        }else{
            level = 0.25
            color = colorMediumLow
        }
    }
    
    return (color, level)
}
