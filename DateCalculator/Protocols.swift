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

protocol HomeViewControllerDelegate: class {
    func loadThemeAndUpdateFormat(isLightTheme: Bool)
    func loadInterstitial()
}

protocol DateDifferenceInputCellDelegate: class {
    func calculateAndUpdateView()
    func updateDataModel(containingCell tag: Int, updated date: Date)
}

protocol AddSubtractTableViewCellDelegate: class {
    func calculateAndUpdateView()
    func updateDataModel(dayMonthYear: [Int])
}

protocol WeekdaySwitchDelegate: class {
    func updateDataModel(containingCell tag: Int, old weekdayObj: WeekdayObj)
}
