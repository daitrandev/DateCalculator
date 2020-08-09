//
//  Date+Utils.swift
//  DateCalculator
//
//  Created by DaiTran on 8/9/20.
//  Copyright © 2020 Dai Tran. All rights reserved.
//

import UIKit

extension Date {
    func isBetween(date1: Date, date2: Date) -> Bool {
        let date1Components = Calendar.current.dateComponents([.day, .month, .year], from: date1)
        let date2Components = Calendar.current.dateComponents([.day, .month, .year], from: date2)
        let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: self)
        
        if date1Components.year! <= dateComponents.year! && dateComponents.year! <= date2Components.year! {
            if date1Components.year! == dateComponents.year! {
                if date1Components.month! > dateComponents.month! {
                    return false
                }
                
                if date1Components.month! == dateComponents.month! && date1Components.day! > dateComponents.day! {
                    return false
                }
            } else if dateComponents.year! == date2Components.year! {
                if date2Components.month! < dateComponents.month! {
                    return false
                }
                
                if date1Components.month! == dateComponents.month! && date1Components.day! < dateComponents.day! {
                    return false
                }
            }
            return true
        }
        
        return false
    }
    
    func getDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}
