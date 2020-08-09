//
//  WeekdayViewModel.swift
//  DateCalculator
//
//  Created by DaiTran on 8/9/20.
//  Copyright © 2020 Dai Tran. All rights reserved.
//

protocol WeekdayViewModelDelegate: class {
    
}

protocol WeekdayViewModelType: class {
    var cellLayoutItems: [WeekdayViewModel.WeekdayToggleCellLayoutItem] { get }
    var delegate: WeekdayViewModelDelegate? { get set }
}

class WeekdayViewModel: WeekdayViewModelType {
    struct WeekdayToggleCellLayoutItem {
        let weekday: Weekday
        var count: Int = 0
        var isSelected: Bool = true
    }
    
    var cellLayoutItems: [WeekdayToggleCellLayoutItem]
    
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
    }
}
