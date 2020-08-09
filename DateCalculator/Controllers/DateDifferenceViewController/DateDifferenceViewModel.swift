//
//  DateDifferenceViewModel.swift
//  DateCalculator
//
//  Created by DaiTran on 8/9/20.
//  Copyright © 2020 Dai Tran. All rights reserved.
//

import Foundation

protocol DateDifferenceViewModelDelegate: class {
    func renderFirstInputDate()
    func renderSecondInputDate()
    func renderOutput(days: Int, months: Int, years: Int)
}

protocol DateDifferenceViewModelType: class {
    var firstInputDate: Date { get set }
    var secondInputDate: Date { get set }
    var delegate: DateDifferenceViewModelDelegate? { get set}
    func clear()
}

final class DateDifferenceViewModel: DateDifferenceViewModelType {
    var firstInputDate: Date = Date() {
        didSet {
            delegate?.renderFirstInputDate()
            
            let dateDifferenceResult = calculateDateDifference(from: firstInputDate, and: secondInputDate)
            delegate?.renderOutput(
                days: dateDifferenceResult.days,
                months: dateDifferenceResult.months,
                years: dateDifferenceResult.years
            )
        }
    }
    var secondInputDate: Date = Date() {
        didSet {
            delegate?.renderSecondInputDate()
            
            let dateDifferenceResult = calculateDateDifference(from: firstInputDate, and: secondInputDate)
            delegate?.renderOutput(
                days: dateDifferenceResult.days,
                months: dateDifferenceResult.months,
                years: dateDifferenceResult.years
            )
        }
    }
    
    weak var delegate: DateDifferenceViewModelDelegate?
    
    func clear() {
        firstInputDate = Date()
        secondInputDate = Date()
    }
    
    private func calculateDateDifference(from date1: Date, and date2: Date) -> DateDifferenceResult {
        let calendarComponents = [Calendar.Component.day, Calendar.Component.month, Calendar.Component.year]
        let calendar = Calendar.current
        
        let firstDateComponents: DateComponents = calendar.dateComponents([.day, .month, .year], from: date1)
        let secondDateComponents: DateComponents = calendar.dateComponents([.day, .month, .year], from: date2)
        
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
}
