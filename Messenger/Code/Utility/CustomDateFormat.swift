//
//  CustomDateFormat.swift
//  Messenger
//
//  Created by Nico Weidmann on 29.10.17.
//  Copyright © 2017 Nico Weidmann. All rights reserved.
//

import Foundation

extension Date {
    
    func formatDateCustom() -> String {
        
        // for dates that are older than a day, return date
        var dateStyle : DateFormatter.Style = .short
        var timeStyle : DateFormatter.Style = .none
        
        if self.timeIntervalSinceNow.isLess(than: 24*60*60) {
            // for dates at the current day, return time
            dateStyle = DateFormatter.Style.none
            timeStyle = DateFormatter.Style.short
        }
        
       return DateFormatter.localizedString(from: self, dateStyle: dateStyle, timeStyle: timeStyle)
    }
}
