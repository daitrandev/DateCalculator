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
    
    func calculateDifference(to date: Date) -> DateDifferenceResult {
        let calendarComponents = [Calendar.Component.day, Calendar.Component.month, Calendar.Component.year]
        let calendar = Calendar.current
        
        let firstDateComponents: DateComponents = calendar.dateComponents([.day, .month, .year], from: self)
        let secondDateComponents: DateComponents = calendar.dateComponents([.day, .month, .year], from: date)
        
        var dayMonthYear = [("Day", 0), ("Month", 0), ("Year", 0)]
        
        for i in 0..<calendarComponents.count {
            let calendarComponent = calendarComponents[i]
            let dateComponents = calendar.dateComponents([calendarComponent], from: firstDateComponents, to: secondDateComponents)
            
            var componentValue = dateComponents.day ?? dateComponents.month ?? dateComponents.year ?? 0
            
            componentValue = componentValue > 0 ? componentValue : componentValue * -1
            dayMonthYear[i].1 = componentValue
        }
        
        return DateDifferenceResult(
            days: dayMonthYear[0].1,
            months: dayMonthYear[1].1,
            years: dayMonthYear[2].1
        )
    }
    
    func getDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}
