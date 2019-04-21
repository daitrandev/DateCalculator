//
//  TwoDateInputCell.swift
//  DateCalculator
//
//  Created by Macbook on 4/20/19.
//  Copyright © 2019 Dai Tran. All rights reserved.
//

import UIKit

class TwoDateInputCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var inputTitleLabel: UILabel!
    @IBOutlet var inputTextField: [UITextField]!
    @IBOutlet var selectDateTitleLabel: [UILabel]!
    
    private var currentEditingIndex: Int?
    private var inputDate: [Date] = [Date(), Date()] {
        didSet {
            for i in 0..<inputDate.count {
                inputTextField[i].text = inputDate[i].getDateString()
            }
            
            let dateDifferenceResult = calculateDateDifference(from: inputDate[0], and: inputDate[1])
            delegate?.updateShowingDifferenceDate(dateDifferenceResult: dateDifferenceResult)
        }
    }
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.minimumDate = Calendar.current.date(byAdding: Calendar.Component.year, value: -1000, to: Date())
        picker.maximumDate = Calendar.current.date(byAdding: Calendar.Component.year, value: 1000, to: Date())
        picker.datePickerMode = .date
        return picker
    }()
    
    lazy var toolbar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.isTranslucent = true
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDoneAction))
        toolBar.setItems([flexibleSpace, doneBarButton], animated: true)
        return toolBar
    }()
    
    weak var delegate: DateDifferenceInputCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLocalization()
        setupTextField()
        
        let layer = CAGradientLayer()
        layer.frame = containerView.bounds
        layer.colors = [UIColor.lowFlattenPurple.cgColor, UIColor.highFlattenPurple.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 1)
        layer.endPoint = CGPoint(x: 1, y: 0)
        containerView.layer.insertSublayer(layer, at: 0)
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 10
        
        inputDate = [Date(), Date()]
    }
    
    private func setupTextField() {
        for i in 0..<inputTextField.count {
            inputTextField[i].tag = i
            inputTextField[i].layer.borderWidth = 1.5
            inputTextField[i].layer.borderColor = UIColor.white.cgColor
            inputTextField[i].layer.cornerRadius = 4
            inputTextField[i].layer.masksToBounds = true
            inputTextField[i].inputView = datePicker
            inputTextField[i].inputAccessoryView = toolbar
            inputTextField[i].text = datePicker.date.getDateString()
            inputTextField[i].delegate = self
        }
    }
    
    private func setupLocalization() {
        selectDateTitleLabel.forEach {
            $0.text = NSLocalizedString("SelectTheDate", comment: "")
        }
    }
    
    private func calculateDateDifference(from date1: Date, and date2: Date) -> DateDifferenceResult {
        let calendarComponents = [Calendar.Component.day, Calendar.Component.month, Calendar.Component.year]
        let calendar = Calendar.current
        
        let firstDateComponents: DateComponents = calendar.dateComponents([.day, .month, .year], from: date1)
        let secondDateComponents: DateComponents = calendar.dateComponents([.day, .month, .year], from: date2)
        
        var dayMonthYear = [("Day", 0), ("Month", 0), ("Year", 0)]
        
        for i in 0..<calendarComponents.count {
            let calendarComponent = calendarComponents[i]
            let dateComponents = calendar.dateComponents([calendarComponent], from: firstDateComponents, to: secondDateComponents)
            
            var componentValue = dateComponents.day ?? dateComponents.month ?? dateComponents.year ?? 0
            
            componentValue = componentValue > 0 ? componentValue : componentValue * -1
            dayMonthYear[i].1 = componentValue
        }
        return DateDifferenceResult(days: dayMonthYear[0].1, months: dayMonthYear[1].1, years: dayMonthYear[2].1)
    }
    
    @objc private func onDoneAction() {
        endEditing(true)

        let selectedDate = datePicker.date
        let dateString = selectedDate.getDateString()
        guard let currentEditingIndex = currentEditingIndex else { return }
        inputTextField[currentEditingIndex].text = dateString
        inputTextField[currentEditingIndex].layer.borderColor = UIColor.white.cgColor
        inputDate[currentEditingIndex] = selectedDate
        
        let dateDifferenceResult = calculateDateDifference(from: inputDate[0], and: inputDate[1])
        delegate?.updateShowingDifferenceDate(dateDifferenceResult: dateDifferenceResult)
    }
    
    private func loadTheme(isLightTheme: Bool) {
//        let themeColor: UIColor = isLightTheme ? .purpleLilac : .orange
//        let mainBackgroundColor: UIColor = isLightTheme ? .white : .black
//        inputTextField.layer.borderColor = themeColor.cgColor
//        inputLabel.textColor = themeColor
//        backgroundColor = mainBackgroundColor
//        datePicker.backgroundColor = mainBackgroundColor
//        let datePickerTextColor: UIColor = isLightTheme ? .black : .white
//        datePicker.setValue(datePickerTextColor, forKey: "textColor")
//        datePicker.setValue(false, forKeyPath: "highlightsToday")
//        toolbar.tintColor = themeColor
//        toolbar.barTintColor = mainBackgroundColor
    }
    
    func refreshDate() {
        inputDate = [Date(), Date()]
    }
}

extension TwoDateInputCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let currentEditingIndex = currentEditingIndex {
            inputTextField[currentEditingIndex].layer.borderColor = UIColor.white.cgColor
        }
        currentEditingIndex = textField.tag
        if let currentEditingIndex = currentEditingIndex {
            datePicker.date = inputDate[currentEditingIndex]
            textField.layer.borderColor = UIColor.purpleLilac.cgColor
        }
        return true
    }
}
