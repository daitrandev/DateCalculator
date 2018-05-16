//
//  AddSubtractDateTableViewCell.swift
//  DateCalculator
//
//  Created by Dai Tran on 5/7/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit

class AddSubtractDateDurationCell: UITableViewCell {
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Day", comment: "") + ":"
        label.textAlignment = .center
        label.textColor = .purpleLilac
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dayPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let monthLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Month", comment: "") + ":"
        label.textAlignment = .center
        label.textColor = .purpleLilac
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var monthPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let yearLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Year", comment: "") + ":"
        label.textAlignment = .center
        label.textColor = .purpleLilac
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var yearPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    lazy var operatorSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["+", "-"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.frame = CGRect(x: 0, y: 0, width: segmentedControl.frame.width, height: 25)
        segmentedControl.tintColor = .purpleLilac
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    weak var delegate: AddSubtractTableViewCellDelegate?
    
    var isLightTheme: Bool = UserDefaults.standard.bool(forKey: isLightThemeKey)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        addSubview(operatorSegmentedControl)
        //addSubview(textField)
        addSubview(dayLabel)
        addSubview(monthLabel)
        addSubview(yearLabel)
        addSubview(dayPicker)
        addSubview(monthPicker)
        addSubview(yearPicker)
        
        operatorSegmentedControl.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        operatorSegmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        operatorSegmentedControl.heightAnchor.constraint(equalToConstant: 25).isActive = true
        operatorSegmentedControl.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25).isActive = true
        
        dayLabel.constraintTo(top: operatorSegmentedControl.bottomAnchor, bottom: nil, left: leftAnchor, right: monthLabel.leftAnchor, topConstant: 16, bottomConstant: 0, leftConstant: 0, rightConstant: 0)
        dayLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        dayLabel.widthAnchor.constraint(equalTo: monthLabel.widthAnchor).isActive = true

        monthLabel.constraintTo(top: dayLabel.topAnchor, bottom: nil, left: dayLabel.rightAnchor, right: yearLabel.leftAnchor, topConstant: 0, bottomConstant: 0, leftConstant: 0, rightConstant: 0)
        monthLabel.heightAnchor.constraint(equalTo: dayLabel.heightAnchor).isActive = true
        monthLabel.widthAnchor.constraint(equalTo: yearLabel.widthAnchor).isActive = true

        yearLabel.constraintTo(top: dayLabel.topAnchor, bottom: nil, left: monthLabel.rightAnchor, right: rightAnchor, topConstant: 0, bottomConstant: 0, leftConstant: 0, rightConstant: 0)
        yearLabel.heightAnchor.constraint(equalTo: dayLabel.heightAnchor).isActive = true

        dayPicker.constraintTo(top: dayLabel.bottomAnchor, bottom: nil, left: leftAnchor, right: nil, topConstant: 0, bottomConstant: 0, leftConstant: 0, rightConstant: 0)
        dayPicker.widthAnchor.constraint(equalTo: monthPicker.widthAnchor).isActive = true
        dayPicker.heightAnchor.constraint(equalToConstant: 150).isActive = true

        monthPicker.constraintTo(top: dayLabel.bottomAnchor, bottom: nil, left: dayPicker.rightAnchor, right: yearPicker.leftAnchor, topConstant: 0, bottomConstant: 0, leftConstant: 0, rightConstant: 0)
        monthPicker.widthAnchor.constraint(equalTo: yearPicker.widthAnchor).isActive = true
        monthPicker.heightAnchor.constraint(equalTo: dayPicker.heightAnchor).isActive = true

        yearPicker.constraintTo(top: dayPicker.topAnchor, bottom: nil, left: monthPicker.rightAnchor, right: rightAnchor, topConstant: 0, bottomConstant: 0, leftConstant: 0, rightConstant: 0)
        yearPicker.heightAnchor.constraint(equalTo: dayPicker.heightAnchor).isActive = true
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let dayMonthYear = getDayMonthYear()
        
        delegate?.updateDataModel(dayMonthYear: dayMonthYear)
        delegate?.calculateAndUpdateView()
    }
    
    fileprivate func getDayMonthYear() -> [Int] {
        let sign = operatorSegmentedControl.selectedSegmentIndex == 0 ? 1 : -1
        
        let day = dayPicker.selectedRow(inComponent: 0) * sign
        let month = monthPicker.selectedRow(inComponent: 0) * sign
        let year = yearPicker.selectedRow(inComponent: 0) * sign
        
        return [day, month, year]
    }
    
    func resetDate() {
        dayPicker.selectRow(0, inComponent: 0, animated: false)
        monthPicker.selectRow(0, inComponent: 0, animated: false)
        yearPicker.selectRow(0, inComponent: 0, animated: false)
        operatorSegmentedControl.selectedSegmentIndex = 0
        delegate?.calculateAndUpdateView()
    }
    
    func loadTheme(isLightTheme: Bool) {
        self.isLightTheme = isLightTheme
        
        let themeColor: UIColor = isLightTheme ? .purpleLilac : .orange
        
        backgroundColor = isLightTheme ? .white : .black
        operatorSegmentedControl.tintColor = themeColor
        dayLabel.textColor = themeColor
        monthLabel.textColor = themeColor
        yearLabel.textColor = themeColor
        
        let pickerViews = [dayPicker, monthPicker, yearPicker]
        for pickerView in pickerViews {
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            pickerView.reloadComponent(0)
            pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        }
        
    }
    
    func disableUserInteraction(isFreeVersion: Bool) {
        dayPicker.isUserInteractionEnabled = !isFreeVersion
        monthPicker.isUserInteractionEnabled = !isFreeVersion
        yearPicker.isUserInteractionEnabled = !isFreeVersion
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddSubtractDateDurationCell: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1000
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let dayMonthYear = getDayMonthYear()
        
        delegate?.updateDataModel(dayMonthYear: dayMonthYear)        
        delegate?.calculateAndUpdateView()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var textColor: UIColor = .gray
        if !isFreeVersion {
            textColor = isLightTheme ? UIColor.black : UIColor.white
        }

        let attributedString = NSAttributedString(string: "\(row)", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: textColor])
        return attributedString
    }
}
