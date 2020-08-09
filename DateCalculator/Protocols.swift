//
//  Protocols.swift
//  DateCalculator
//
//  Created by Dai Tran on 5/8/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit
import GoogleMobileAds

protocol DateDifferenceInputCellDelegate: class {
    func updateShowingDifferenceDate(dateDifferenceResult: DateDifferenceResult)
}

protocol AddSubtractTableViewCellDelegate: class {
    func calculateAndUpdateView()
    func updateDataModel(dayMonthYear: [Int])
}

protocol WeekdaySwitchDelegate: class {
//    func updateDataModel(containingCell tag: Int, old weekdayObj: WeekdayObj)
}
