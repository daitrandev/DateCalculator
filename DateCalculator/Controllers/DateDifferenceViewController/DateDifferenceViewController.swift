//
//  ViewController.swift
//  DateCalculator
//
//  Created by Dai Tran on 5/2/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit
import MessageUI
import GoogleMobileAds

class DateDifferenceViewController: UIViewController {
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var firstInputDateTextField: UITextField!
    @IBOutlet weak var secondInputDateTextField: UITextField!
    @IBOutlet weak var outputContainerView: UIView!
    @IBOutlet weak var dayDifferenceLabel: UILabel!
    @IBOutlet weak var monthDifferenceLabel: UILabel!
    @IBOutlet weak var yearDifferenceLabel: UILabel!
    
    private var currentEditingTextField: UITextField?
    private let viewModel: DateDifferenceViewModelType
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.minimumDate = Calendar.current.date(byAdding: Calendar.Component.year, value: -1000, to: Date())
        picker.maximumDate = Calendar.current.date(byAdding: Calendar.Component.year, value: 1000, to: Date())
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        return picker
    }()
    
    private lazy var toolbar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.isTranslucent = true
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        toolBar.setItems([flexibleSpace, doneBarButton], animated: true)
        return toolBar
    }()
    
    init() {
        viewModel = DateDifferenceViewModel()
        super.init(
            nibName: String(describing: DateDifferenceViewController.self),
            bundle: .main
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        [inputContainerView, outputContainerView].forEach {
            $0?.backgroundColor = UIColor.purpleLilac
            $0?.makeRounded(cornerRadius: 10)
        }
        
        [firstInputDateTextField, secondInputDateTextField].forEach {
            $0?.inputView = datePicker
            $0?.inputAccessoryView = toolbar
            $0?.layer.borderWidth = 2
            $0?.layer.borderColor = UIColor.clear.cgColor
            $0?.delegate = self
        }
        
        firstInputDateTextField.text = viewModel.firstInputDate.getDateString()
        secondInputDateTextField.text = viewModel.secondInputDate.getDateString()
        
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont(name: "Roboto-Medium", size: 14)!
        ]
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "refresh"),
            style: .plain,
            target: self,
            action: #selector(didTapRefresh)
        )
        navigationController?.navigationBar.tintColor = UIColor.purpleLilac
        tabBarController?.tabBar.tintColor = UIColor.purpleLilac
        
        navigationItem.title = "The Difference Between Two Dates"
    }
    
    @objc func didTapRefresh() {
        viewModel.clear()
    }
    
    @objc private func datePickerValueChanged() {
        if currentEditingTextField == firstInputDateTextField {
            viewModel.firstInputDate = datePicker.date
        } else if currentEditingTextField == secondInputDateTextField {
            viewModel.secondInputDate = datePicker.date
        }
    }
    
    @objc func didTapDone() {
        currentEditingTextField?.resignFirstResponder()
        currentEditingTextField = nil
        
        [firstInputDateTextField, secondInputDateTextField].forEach {
            $0?.layer.borderColor = UIColor.clear.cgColor
        }
    }
}

extension DateDifferenceViewController: DateDifferenceViewModelDelegate {
    func renderFirstInputDate() {
        firstInputDateTextField.text = viewModel.firstInputDate.getDateString()
    }
    
    func renderSecondInputDate() {
        secondInputDateTextField.text = viewModel.secondInputDate.getDateString()
    }
    
    func renderOutput(days: Int, months: Int, years: Int) {
        dayDifferenceLabel.text = String(days)
        monthDifferenceLabel.text = String(months)
        yearDifferenceLabel.text = String(years)
    }
}

extension DateDifferenceViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentEditingTextField?.layer.borderColor = UIColor.clear.cgColor
        
        if textField == firstInputDateTextField {
            datePicker.date = viewModel.firstInputDate
            firstInputDateTextField.layer.borderColor = UIColor.black.cgColor
            currentEditingTextField = firstInputDateTextField
            return true
        }
        
        if textField == secondInputDateTextField {
            datePicker.date = viewModel.secondInputDate
            secondInputDateTextField.layer.borderColor = UIColor.black.cgColor
            currentEditingTextField = secondInputDateTextField
            return true
        }
        return true
    }
}
