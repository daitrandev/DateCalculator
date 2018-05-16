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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    func setupViews() {
        addSubview(weekdaySwitchControl)
        addSubview(weekdayTextView)

        weekdayTextView.constraintTo(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: centerXAnchor, topConstant: 0, bottomConstant: 0, leftConstant: 0, rightConstant: -16)

        weekdaySwitchControl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        weekdaySwitchControl.leftAnchor.constraint(equalTo: centerXAnchor, constant: 16).isActive = true
    }
    
    @objc func switchControlValueChanged(_ sender: UISwitch) {
        let isLightTheme = UserDefaults.standard.bool(forKey: isLightThemeKey)
        let onStateTextColor: UIColor = isLightTheme ? .black : .white
        weekdayTextView.textColor = sender.isOn ? onStateTextColor : .gray
        
        guard let weekdayObj = weekdayObj else { return }
        let updatedObj = WeekdayObj(weekday: weekdayObj.weekday, isSelected: sender.isOn, numOfDays: weekdayObj.numOfDays)
        delegate?.updateDataModel(containingCell: self.tag, old: updatedObj)        
    }
    
    func loadTheme(isLightTheme: Bool) {
        let mainBackgroundColor: UIColor = isLightTheme ? .white : .black
        let textColor: UIColor = isLightTheme ? .black : .white
        let themeColor: UIColor = isLightTheme ? .purpleLilac : .orange

        backgroundColor = mainBackgroundColor
        weekdayTextView.textColor = textColor
        weekdayTextView.backgroundColor = mainBackgroundColor
        weekdaySwitchControl.onTintColor = themeColor
    }
    
    func resetOutput() {
        weekdaySwitchControl.isOn = true
        
        //delegate?.calculateAndUpdateView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
