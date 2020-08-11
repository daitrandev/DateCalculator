//
//  LeapYearViewController.swift
//  DateCalculator
//
//  Created by Dai Tran on 5/15/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit

class LeapYearViewController: UIViewController {
    @IBOutlet weak var inputDateTextField: UITextField!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var outputContainerView: UIView!
    
    private var viewModel: LeapYearViewModelType
    
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
        viewModel = LeapYearViewModel()
        super.init(
            nibName: String(describing: LeapYearViewController.self),
            bundle: .main
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.inputDate = Date()
        
        [inputContainerView, outputContainerView].forEach {
            $0?.backgroundColor = UIColor.purpleLilac
            $0?.makeRounded(cornerRadius: 10)
        }
        
        inputDateTextField.inputView = datePicker
        inputDateTextField.inputAccessoryView = toolbar
        inputDateTextField.layer.borderWidth = 2
        inputDateTextField.layer.borderColor = UIColor.clear.cgColor
        
        navigationItem.title = "Check Leap Year"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "refresh"),
            style: .plain,
            target: self,
            action: #selector(didTapRefresh)
        )
        navigationController?.navigationBar.tintColor = UIColor.purpleLilac
        tabBarController?.tabBar.tintColor = UIColor.purpleLilac
    }
    
    @objc private func didTapRefresh() {
        viewModel.inputDate = Date()
    }
    
    @objc private func didTapDone() {
        inputDateTextField.resignFirstResponder()
    }
    
    @objc private func datePickerValueChanged() {
        viewModel.inputDate = datePicker.date
    }
}

extension LeapYearViewController: LeapYearViewModelDelegate {
    func render(inputDate: Date) {
        inputDateTextField.text = inputDate.getDateString()
    }
    
    func renderOutput(year: Int, isLeapYear: Bool) {
        if isLeapYear {
            outputLabel.text = "\(year) is a leap year."
            return
        }
        outputLabel.text = "\(year) isn't a leap year."
    }
}
