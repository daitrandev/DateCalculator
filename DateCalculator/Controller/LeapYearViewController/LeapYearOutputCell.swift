//
//  LeapYearOutputCell.swift
//  DateCalculator
//
//  Created by Dai Tran on 5/15/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit

class LeapYearOutputCell: UITableViewCell {
    
    var checkingYear: Int? {
        didSet {
            guard let checkingYear = checkingYear else { return }
            textView.text = String(checkingYear)
        }
    }
    
    var isLeapYear: Bool? {
        didSet {
            guard let isLeapYear = isLeapYear else { return }
            let leapYearKey = isLeapYear ? "IsALeapYear" : "IsNotALeapYear";
            let isLeapYearString = NSLocalizedString(leapYearKey, comment: "")
            textView.text! += isLeapYearString
        }
    }
    
    let textView: UITextView = {
        let textView = UITextView()
        //textView.textColor = .purpleLilac
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    func loadTheme(isLightTheme: Bool) {
        let textColor: UIColor = isLightTheme ? .black : .white
        let mainBackgroundColor: UIColor = isLightTheme ? .white : .black
       
        textView.backgroundColor = mainBackgroundColor
        textView.textColor = textColor
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(textView)
        textView.constraintTo(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, topConstant: 0, bottomConstant: 0, leftConstant: 0, rightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
