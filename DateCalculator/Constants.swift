//
//  Constants.swift
//  DateCalculator
//
//  Created by Dai Tran on 5/7/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import Foundation

let isFreeVersion: Bool = true
let isLightThemeKey: String = "isLightTheme"


enum Weekday: Int {
    case Sunday = 1
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    
    func getStringValue() -> String {
        switch self {
        case .Sunday:
            return "Sunday"
        case .Monday:
            return "Monday"
        case .Tuesday:
            return "Tuesday"
        case .Wednesday:
            return "Wednesday"
        case .Thursday:
            return "Thursday"
        case .Friday:
            return "Friday"
        case .Saturday:
            return "Saturday"
        }
    }
}
