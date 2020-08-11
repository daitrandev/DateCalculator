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
    var isPurchased: Bool { get }
    var delegate: DateDifferenceViewModelDelegate? { get set }
    func clear()
}

final class DateDifferenceViewModel: DateDifferenceViewModelType {
    var firstInputDate: Date = Date() {
        didSet {
            delegate?.renderFirstInputDate()
            
            let dateDifferenceResult = firstInputDate.calculateDifference(to: secondInputDate)
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
            
            let dateDifferenceResult = firstInputDate.calculateDifference(to: secondInputDate)
            delegate?.renderOutput(
                days: dateDifferenceResult.days,
                months: dateDifferenceResult.months,
                years: dateDifferenceResult.years
            )
        }
    }
    
    var isPurchased: Bool {
        GlobalKeychain.getBool(for: KeychainKey.isPurchased) ?? false
    }
    
    weak var delegate: DateDifferenceViewModelDelegate?
    
    func clear() {
        firstInputDate = Date()
        secondInputDate = Date()
    }
}
