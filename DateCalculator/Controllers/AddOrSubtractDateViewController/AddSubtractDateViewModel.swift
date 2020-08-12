//
//  AddSubtractDateViewModel.swift
//  DateCalculator
//
//  Created by DaiTran on 8/9/20.
//  Copyright © 2020 Dai Tran. All rights reserved.
//

import Foundation

protocol AddSubtractDateViewModelDelegate: class {
    func render(inputDate: Date)
    func render(outputDate: Date)
    func render(duration: AddSubtractDateViewModel.Duration)
}

protocol AddSubtractDateViewModelType: class {
    var isPurchased: Bool { get }
    var inputDate: Date { get set }
    var inputDuration: AddSubtractDateViewModel.Duration { get set }
    var maximumDurationNumber: Int { get }
    var delegate: AddSubtractDateViewModelDelegate? { get set }
}

class AddSubtractDateViewModel: AddSubtractDateViewModelType {
    typealias Duration = (days: Int, months: Int, years: Int)
    
    var inputDate: Date {
        didSet {
            delegate?.render(inputDate: inputDate)
            
            let outputDate = calculateDateFromDuration(inputDate: inputDate, duration: inputDuration) ?? Date()
            delegate?.render(outputDate: outputDate)
        }
    }
    
    var inputDuration: Duration {
        didSet {
            delegate?.render(duration: inputDuration)
            
            let outputDate = calculateDateFromDuration(inputDate: inputDate, duration: inputDuration) ?? Date()
            delegate?.render(outputDate: outputDate)
        }
    }
    
    var isPurchased: Bool {
        GlobalKeychain.getBool(for: KeychainKey.isPurchased) ?? false
    }
    
    var maximumDurationNumber: Int = 1000
    
    weak var delegate: AddSubtractDateViewModelDelegate?
    
    init() {
        inputDate = Date()
        inputDuration = (days: 0, months: 0, years: 0)
    }
    
    private func calculateDateFromDuration(inputDate: Date, duration: Duration) -> Date? {
        guard let dateAfterAddingDays = Calendar.current.date(byAdding: Calendar.Component.day, value: duration.days, to: inputDate) else {
            return nil
        }
        guard let dateAfterAddingMonths = Calendar.current.date(byAdding: Calendar.Component.month, value: duration.months, to: dateAfterAddingDays) else {
            return nil
        }
        guard let dateAfterAddingYears = Calendar.current.date(byAdding: Calendar.Component.year, value: duration.years, to: dateAfterAddingMonths) else {
            return nil
        }
        
        return dateAfterAddingYears
    }
}
