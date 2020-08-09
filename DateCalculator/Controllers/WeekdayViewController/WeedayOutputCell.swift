//
//  WeekdayTableViewCell.swift
//  DateCalculator
//
//  Created by Dai Tran on 5/11/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit

class WeedayOutputCell: UITableViewCell {
    
    var weekdayObj: WeekdayObj? {
        didSet {
            guard let weekdayObj = weekdayObj else { return }
            weekdaySwitchControl.setOn(weekdayObj.isSelected, animated: true)
            let weekdayString = weekdayObj.weekday.getStringValue()
            let weekdayLocalizedString = NSLocalizedString(weekdayString, comment: "")
            weekdayTextView.text = "\(weekdayLocalizedString): \(weekdayObj.numOfDays)"
        }
    }
    
    weak var delegate: WeekdaySwitchDelegate?
    
    lazy var weekdaySwitchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = true
        switchControl.onTintColor = .purpleLilac
        switchControl.addTarget(self, action: #selector(switchControlValueChanged), for: .valueChanged)
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }()
    
    let weekdayTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Monday: 0"
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textAlignment = .right
        textView.textColor = .gray
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    @objc func switchControlValueChanged(_ sender: UISwitch) {
        let isLightTheme = UserDefaults.standard.bool(forKey: isLightThemeKey)
        let onStateTextColor: UIColor = isLightTheme ? .black : .white
        weekdayTextView.textColor = sender.isOn ? onStateTextColor : .gray
        
        guard let weekdayObj = weekdayObj else { return }
        let updatedObj = WeekdayObj(weekday: weekdayObj.weekday, isSelected: sender.isOn, numOfDays: weekdayObj.numOfDays)
        delegate?.updateDataModel(containingCell: self.tag, old: updatedObj)        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
