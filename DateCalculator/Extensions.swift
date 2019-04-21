//
//  Extensions.swift
//  DateCalculator
//
//  Created by Dai Tran on 5/3/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit

extension UIView {
    func constraintTo(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, right: NSLayoutXAxisAnchor?, topConstant: CGFloat, bottomConstant: CGFloat, leftConstant: CGFloat, rightConstant: CGFloat) {
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: topConstant).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: bottomConstant).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: leftConstant).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: rightConstant).isActive = true
        }
    }
}

extension UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}

extension UIColor {
    static let purpleLilac = UIColor(red: 91/255, green: 41/255, blue: 173/255, alpha: 1)
    static let lowFlattenPurple = UIColor(red: 90/255, green: 73/255, blue: 159/255, alpha: 1)
    static let highFlattenPurple = UIColor(red: 115/255, green: 95/255, blue: 194/255, alpha: 1)
}

extension Date {
    func isBetween(date1: Date, date2: Date) -> Bool {
        let date1Components = Calendar.current.dateComponents([.day, .month, .year], from: date1)
        let date2Components = Calendar.current.dateComponents([.day, .month, .year], from: date2)
        let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: self)
        
        if date1Components.year! <= dateComponents.year! && dateComponents.year! <= date2Components.year! {
            if date1Components.year! == dateComponents.year! {
                if date1Components.month! > dateComponents.month! {
                    return false
                }
                
                if date1Components.month! == dateComponents.month! && date1Components.day! > dateComponents.day! {
                    return false
                }
            } else if dateComponents.year! == date2Components.year! {
                if date2Components.month! < dateComponents.month! {
                    return false
                }
                
                if date1Components.month! == dateComponents.month! && date1Components.day! < dateComponents.day! {
                    return false
                }
            }
            return true
        }
        
        return false
    }
    
    func getDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}

extension UIImage {
    convenience init?(menuSection: MenuSection, theme: Theme) {
        let menuIconName = menuSection.rawValue + "-" + theme.rawValue
        self.init(named: menuIconName)
    }
}

