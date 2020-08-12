//
//  LeapYearViewModel.swift
//  DateCalculator
//
//  Created by Dai.Tran on 8/11/20.
//  Copyright © 2020 Dai Tran. All rights reserved.
//

import Foundation

protocol LeapYearViewModelDelegate: class {
    func render(inputDate: Date)
    func renderOutput(year: Int, isLeapYear: Bool)
}

protocol LeapYearViewModelType: class {
    var isPurchased: Bool { get }
    var inputDate: Date { get set }
    var delegate: LeapYearViewModelDelegate? { get set }
    func clear()
}

class LeapYearViewModel: LeapYearViewModelType {
    private var inputYear: Int {
        get {
            return Calendar.current.dateComponents([.year], from: inputDate).year!
        }
    }
    
    var inputDate: Date {
        didSet {
            delegate?.render(inputDate: inputDate)
            
            let isLeapYear = checkLeapYear(for: inputYear)
            delegate?.renderOutput(year: inputYear, isLeapYear: isLeapYear)
        }
    }
    
    var isPurchased: Bool {
        GlobalKeychain.getBool(for: KeychainKey.isPurchased) ?? false
    }
    
    weak var delegate: LeapYearViewModelDelegate?
    
    init() {
        inputDate = Date()
    }
    
    func clear() {
        inputDate = Date()
    }
    
    private func checkLeapYear(for year: Int) -> Bool {
        return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
    }
}
