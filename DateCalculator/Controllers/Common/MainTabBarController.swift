//
//  MainTabBarController.swift
//  DateCalculator
//
//  Created by Dai Tran on 5/3/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateDifferenceViewController = DateDifferenceViewController()
        let dateDifferenceNav = UINavigationController(rootViewController: dateDifferenceViewController)
        dateDifferenceNav.tabBarItem.title = "The Difference"
        dateDifferenceNav.tabBarItem.image = #imageLiteral(resourceName: "difference")
        
        let addSubtractDateViewController = AddSubtractDateViewController()
        let addSubtractDateNav = UINavigationController(rootViewController: addSubtractDateViewController)
        addSubtractDateNav.tabBarItem.title = "Add Or Subtract"
        addSubtractDateNav.tabBarItem.image = #imageLiteral(resourceName: "add-subtract")

        let weekdayViewController = WeekdayViewController()
        let weekdayNav = UINavigationController(rootViewController: weekdayViewController)
        weekdayNav.tabBarItem.title = "Weekday"
        weekdayNav.tabBarItem.image = #imageLiteral(resourceName: "weekday")
//
//        let leapYearViewController = LeapYearViewController()
//        let leapYearNav = UINavigationController(rootViewController: leapYearViewController)
//        leapYearNav.tabBarItem.title = NSLocalizedString("LeapYear", comment: "")
//        leapYearNav.tabBarItem.image = #imageLiteral(resourceName: "leapYear")

        viewControllers = [dateDifferenceNav, addSubtractDateNav, weekdayNav]//, leapYearNav]
    }
}
