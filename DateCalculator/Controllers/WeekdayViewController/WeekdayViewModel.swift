//
//  WeekdayViewModel.swift
//  DateCalculator
//
//  Created by DaiTran on 8/9/20.
//  Copyright © 2020 Dai Tran. All rights reserved.
//

import Foundation

protocol WeekdayViewModelDelegate: class {
    func renderFirstInputDate()
    func renderSecondInputDate()
    func renderTotalDays()
    func reloadWeedayTableView()
}

protocol WeekdayViewModelType: class {
    var isPurchased: Bool { get }
    var firstInputDate: Date { get set }
    var secondInputDate: Date { get set }
    var totalDays: Int { get }
    var cellLayoutItems: [WeekdayViewModel.WeekdayToggleCellLayoutItem] { get }
    var delegate: WeekdayViewModelDelegate? { get set }
    func didChangeToggle(for item: WeekdayViewModel.WeekdayToggleCellLayoutItem)
    func clear()
}

class WeekdayViewModel: WeekdayViewModelType {
    struct WeekdayToggleCellLayoutItem {
        let weekday: Weekday
        var count: Int = 0
        var isSelected: Bool = true
    }
    
    var totalDays: Int {
        cellLayoutItems.reduce(0, { $0 + $1.count })
    }
    
    var firstInputDate: Date {
        didSet {
            delegate?.renderFirstInputDate()
            
            calculateAllWeekdays()
            
            delegate?.renderTotalDays()
        }
    }
    var secondInputDate: Date {
        didSet {
            delegate?.renderSecondInputDate()
            
            calculateAllWeekdays()
            
            delegate?.renderTotalDays()
        }
    }
    
    var cellLayoutItems: [WeekdayToggleCellLayoutItem] {
        didSet {
            delegate?.renderTotalDays()
            delegate?.reloadWeedayTableView()
        }
    }
    
    var isPurchased: Bool {
        GlobalKeychain.getBool(for: KeychainKey.isPurchased) ?? false
    }
    
    weak var delegate: WeekdayViewModelDelegate?
    
    init() {
        cellLayoutItems = [
            .init(weekday: .sunday),
            .init(weekday: .monday),
            .init(weekday: .tuesday),
            .init(weekday: .wednesday),
            .init(weekday: .thursday),
            .init(weekday: .friday),
            .init(weekday: .saturday)
        ]
        firstInputDate = Date()
        secondInputDate = Date()
    }
    
    private func calculateAllWeekdays() {
        for item in cellLayoutItems {
            didChangeToggle(for: item)
        }
    }
    
    func clear() {
        var cellLayoutItems = self.cellLayoutItems
        for index in 0..<cellLayoutItems.count {
            cellLayoutItems[index].isSelected = true
        }
        self.cellLayoutItems = cellLayoutItems
        
        firstInputDate = Date()
        secondInputDate = Date()
    }
    
    func didChangeToggle(for item: WeekdayViewModel.WeekdayToggleCellLayoutItem) {
        var cellLayoutItems = self.cellLayoutItems
        let dayDifference = firstInputDate.calculateDifference(to: secondInputDate).days
        
        let numberOfWeeks = dayDifference / 7
        
        for index in 0..<cellLayoutItems.count {
            if cellLayoutItems[index].weekday != item.weekday {
                continue
            }
            
            if !item.isSelected {
                cellLayoutItems[index].count = 0
                cellLayoutItems[index].isSelected = false
                self.cellLayoutItems = cellLayoutItems
                return
            }
            
            cellLayoutItems[index].count = calculateWeekdays(for: item.weekday, numberOfWeeks: numberOfWeeks) ?? 0
            cellLayoutItems[index].isSelected = true
            self.cellLayoutItems = cellLayoutItems
            return
        }
    }
    
    func calculateWeekdays(for weekday: Weekday, numberOfWeeks: Int) -> Int? {
        let calendar = Calendar.current
        
        guard let weekdayValue1 = calendar.dateComponents([.weekday], from: firstInputDate).weekday else { return nil }
        guard let weekdayValue2 = calendar.dateComponents([.weekday], from: secondInputDate).weekday else { return nil }
        
        if weekdayValue2 - weekdayValue1 >= 0 {
            if !(weekdayValue1...weekdayValue2).contains(weekday.rawValue) {
                return numberOfWeeks
            }
        } else {
            if !(weekdayValue1...7).contains(weekday.rawValue) && !(1...weekdayValue2).contains(weekday.rawValue) {
                return numberOfWeeks
            }
        }
        
        guard let addingDate = calendar.date(byAdding: .day, value: numberOfWeeks * 7, to: firstInputDate) else { return nil }
        guard let addingDateWeekday = calendar.dateComponents([.weekday], from: addingDate).weekday else { return nil }
        var difference = (weekday.rawValue - addingDateWeekday)
        if difference < 0 {
            difference += 7
        }
        
        guard let dateBetween = calendar.date(byAdding: .day, value: difference, to: addingDate) else { return nil }
        if dateBetween.isBetween(date1: firstInputDate, date2: secondInputDate) {
            return numberOfWeeks + 1
        }

        return numberOfWeeks
    }
}
