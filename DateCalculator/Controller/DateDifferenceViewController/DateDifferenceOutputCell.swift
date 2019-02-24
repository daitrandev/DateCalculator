//
//  ResultTableViewCell.swift
//  DateCalculator
//
//  Created by Dai Tran on 5/6/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit

class DateDifferenceOutputCell: UITableViewCell {
    
    var resultData: (String, String)? {
        didSet {
            guard let resultKey = resultData?.0 else { return }
            guard let resultValue = resultData?.1 else { return }
            resultKeyTextView.text = NSLocalizedString(resultKey, comment: "") + ":"
            resultValueTextView.text = resultValue
        }
    }
    
    let resultKeyTextView: UITextView = {
        let textView = UITextView()
        //textView.textColor = .purpleLilac
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textAlignment = .right
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    lazy var resultValueTextView: UITextView = {
        let textView = UITextView()
        //textView.textColor = .purpleLilac
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textAlignment = .left
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(resultKeyTextView)
        addSubview(resultValueTextView)
        
        resultKeyTextView.constraintTo(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: centerXAnchor, topConstant: 0, bottomConstant: 0, leftConstant: 0, rightConstant: -16)
        
        resultValueTextView.constraintTo(top: topAnchor, bottom: bottomAnchor, left: centerXAnchor, right: rightAnchor, topConstant: 0, bottomConstant: 0, leftConstant: 16, rightConstant: 0)        
    }
    
    func loadTheme(isLightTheme: Bool) {
        let mainBackgroundColor: UIColor = isLightTheme ? .white : .black
        let textColor: UIColor = isLightTheme ? .black : .white
        
        backgroundColor = mainBackgroundColor
        resultKeyTextView.backgroundColor = mainBackgroundColor
        resultKeyTextView.textColor = textColor
        resultValueTextView.backgroundColor = mainBackgroundColor
        resultValueTextView.textColor = textColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DateDifferenceOutputCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}
