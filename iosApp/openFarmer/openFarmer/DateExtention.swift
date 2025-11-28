//
//  DateExtention.swift
//  openFarmer
//
//  Created by Valentin Werner on 24.11.25.
//

import Foundation

extension Date {
    
    //time int to Date
    init(time: Int) {
        var components = DateComponents()
        components.hour = time / 100
        components.minute = time % 100
        
        // Use current calendar (or .gregorian if you prefer)
        if let date = Calendar.current.date(from: components) {
            self = date
        } else {
            self = Date()
        }
    }
    
    /// Returns the time component as an Int
    func toTimeInt() -> Int {
        let hour: Int = Calendar.current.component(.hour, from: self)
        let minute: Int = Calendar.current.component(.minute, from: self)
        
        return hour * 100 + minute
    }
}
