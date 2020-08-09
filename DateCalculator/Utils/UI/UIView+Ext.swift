//
//  UIView+Ext.swift
//  DateCalculator
//
//  Created by DaiTran on 8/9/20.
//  Copyright © 2020 Dai Tran. All rights reserved.
//

import UIKit

extension UIView {
    func constraintTo(top: NSLayoutYAxisAnchor?,
                      bottom: NSLayoutYAxisAnchor?,
                      left: NSLayoutXAxisAnchor?,
                      right: NSLayoutXAxisAnchor?,
                      topConstant: CGFloat = 0,
                      bottomConstant: CGFloat = 0,
                      leftConstant: CGFloat = 0,
                      rightConstant: CGFloat = 0) {
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
    
    func makeDiagnosedGradient(beginColor: UIColor, endColor: UIColor) {
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.colors = [beginColor.cgColor, endColor.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 1)
        layer.endPoint = CGPoint(x: 1, y: 0)
        self.layer.insertSublayer(layer, at: 0)
    }
    
    func makeRounded(cornerRadius: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = 10
    }
}
