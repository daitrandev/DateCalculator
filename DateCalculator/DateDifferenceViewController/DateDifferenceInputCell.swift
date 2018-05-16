//
//  InputTableViewCell.swift
//  DateCalculator
//
//  Created by Dai Tran on 5/6/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit

class DateDifferenceInputCell: UITableViewCell {
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.minimumDate = Calendar.current.date(byAdding: Calendar.Component.year, value: -1000, to: Date())
        picker.maximumDate = Calendar.current.date(byAdding: Calendar.Component.year, value: 1000, to: Date())
        picker.datePickerMode = .date
        return picker
    }()
    
    let inputLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("SelectTheDate", comment: "") + ":"
        label.textColor = .purpleLilac
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 5
        textField.textAlignment = .center
        textField.layer.masksToBounds = true
        textField.delegate = self
        textField.inputAccessoryView = toolbar
        textField.layer.borderColor = UIColor.purpleLilac.cgColor
        textField.backgroundColor = .white
        textField.inputView = datePicker
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    weak var delegate: DateDifferenceInputCellDelegate?
    
    fileprivate func setupLayout() {
        addSubview(inputTextField)
        addSubview(inputLabel)
        
        inputLabel.constraintTo(top: topAnchor, bottom: nil, left: leftAnchor, right: nil, topConstant: 8, bottomConstant: 0, leftConstant: 16, rightConstant: 0)
        inputLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        inputTextField.constraintTo(top: inputLabel.bottomAnchor, bottom: nil, left: inputLabel.leftAnchor, right: rightAnchor, topConstant: 0, bottomConstant: 0, leftConstant: 0, rightConstant: -16)
        inputTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let dateString = datePicker.date.getDateString()
        inputTextField.text = dateString
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    @objc func onDoneAction() {
        let selectedDate = datePicker.date
        let dateString = selectedDate.getDateString()
        inputTextField.text = dateString
        
        delegate?.updateDataModel(containingCell: self.tag, updated: datePicker.date)
        delegate?.calculateAndUpdateView()
        
        inputTextField.resignFirstResponder()
    }
        
    func resetDate() {
        datePicker.date = Date()
        let dateString = datePicker.date.getDateString()
        inputTextField.text = dateString
    }
    
    func loadTheme(isLightTheme: Bool) {
        let themeColor: UIColor = isLightTheme ? .purpleLilac : .orange
        let mainBackgroundColor: UIColor = isLightTheme ? .white : .black
        inputTextField.layer.borderColor = themeColor.cgColor
        inputLabel.textColor = themeColor
        backgroundColor = mainBackgroundColor
        datePicker.backgroundColor = mainBackgroundColor
        let datePickerTextColor: UIColor = isLightTheme ? .black : .white
        datePicker.setValue(datePickerTextColor, forKey: "textColor")
        datePicker.setValue(false, forKeyPath: "highlightsToday")
        toolbar.tintColor = themeColor
        toolbar.barTintColor = mainBackgroundColor
    }
    
    func disableUserInteraction(isFreeVersion: Bool) {
        inputTextField.isUserInteractionEnabled = !isFreeVersion
        inputTextField.backgroundColor = !isFreeVersion ? .white : .gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DateDifferenceInputCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
