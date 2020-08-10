//
//  Weekday.swift
//  DateCalculator
//
//  Created by DaiTran on 8/9/20.
//  Copyright © 2020 Dai Tran. All rights reserved.
//

enum Weekday: Int {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    func toString() -> String {
        switch self {
        case .sunday:
            return "Sunday"
            
        case .monday:
            return "Monday"
            
        case .tuesday:
            return "Tuesday"
            
        case .wednesday:
            return "Wednesday"
            
        case .thursday:
            return "Thurday"
            
        case .friday:
            return "Friday"
            
        case .saturday:
            return "Saturday"
        }
    }
}
