//
//  UITraitCollection+Ext.swift
//  DateCalculator
//
//  Created by DaiTran on 8/7/20.
//  Copyright © 2020 Dai Tran. All rights reserved.
//

import UIKit

@available(iOS 12.0, *)
extension UIUserInterfaceStyle {
    var themeColor: UIColor {
        switch self {
        case .light, .unspecified:
            return .purpleLilac
            
        case .dark:
            return .orange
            
        @unknown default:
            return .purpleLilac
        }
    }
}
