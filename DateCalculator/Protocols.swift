//
//  Protocols.swift
//  DateCalculator
//
//  Created by Dai Tran on 5/8/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit
import GoogleMobileAds

protocol HomeViewDelegate: class {
    func loadTheme(isLightTheme: Bool)
    func presentMailComposeViewController()
    func presentRatingAction()
    func presentShareAction()
}

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
