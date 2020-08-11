//
//  AddSubtractDateViewController.swift
//  DateCalculator
//
//  Created by Dai Tran on 5/3/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AddSubtractDateViewController: UIViewController {
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var outputContainerView: UIView!
    @IBOutlet weak var inputDateTextField: UITextField!
    @IBOutlet weak var dayPickerView: UIPickerView!
    @IBOutlet weak var monthPickerView: UIPickerView!
    @IBOutlet weak var yearPickerView: UIPickerView!
    @IBOutlet weak var outputDateLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    private var bannerView: GADBannerView?
    private var viewModel: AddSubtractDateViewModelType
    
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
        viewModel = AddSubtractDateViewModel()
        super.init(
            nibName: String(describing: AddSubtractDateViewController.self),
            bundle: .main
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView = createAndLoadBannerAds()
        
        viewModel.delegate = self
        
        navigationItem.title = "Add Or Subtract A Duration"
        
        [inputContainerView, outputContainerView].forEach {
            $0?.backgroundColor = UIColor.purpleLilac
            $0?.makeRounded(cornerRadius: 10)
        }
        
        [dayPickerView, monthPickerView, yearPickerView].forEach {
            $0?.delegate = self
            $0?.dataSource = self
            $0?.selectRow(viewModel.maximumDurationNumber, inComponent: 0, animated: true)
        }
        
        viewModel.inputDuration = (days: 0, months: 0, years: 0)
        viewModel.inputDate = Date()
        
        inputDateTextField.inputView = datePicker
        inputDateTextField.inputAccessoryView = toolbar
        inputDateTextField.layer.borderWidth = 2
        inputDateTextField.layer.borderColor = UIColor.clear.cgColor
        
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
    }
    
    @objc private func didTapRefresh() {
        viewModel.inputDuration = (days: 0, months: 0, years: 0)
        viewModel.inputDate = Date()
    }
    
    @objc private func didTapDone() {
        inputDateTextField.resignFirstResponder()
    }
    
    @objc private func datePickerValueChanged() {
        viewModel.inputDate = datePicker.date
    }
}

extension AddSubtractDateViewController: GADBannerViewDelegate {
    private func createAndLoadBannerAds() -> GADBannerView {
        let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        let adUnitId = bannerAdsUnitID
        bannerView.adUnitID = adUnitId
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        return bannerView
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        self.stackView.insertArrangedSubview(bannerView, at: 0)
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
}

extension AddSubtractDateViewController: AddSubtractDateViewModelDelegate {
    func render(inputDate: Date) {
        inputDateTextField.text = inputDate.getDateString()
    }
    
    func render(outputDate: Date) {
        outputDateLabel.text = outputDate.getDateString()
    }
    
    func render(duration: AddSubtractDateViewModel.Duration) {
        dayPickerView.selectRow(
            duration.days + viewModel.maximumDurationNumber,
            inComponent: 0,
            animated: true
        )
        
        monthPickerView.selectRow(
            duration.months + viewModel.maximumDurationNumber,
            inComponent: 0,
            animated: true
        )
        
        yearPickerView.selectRow(
            duration.years + viewModel.maximumDurationNumber,
            inComponent: 0,
            animated: true
        )
    }
}

extension AddSubtractDateViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (viewModel.maximumDurationNumber * 2) + 1
    }
}

extension AddSubtractDateViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        if pickerView == dayPickerView {
            viewModel.inputDuration.days = row - viewModel.maximumDurationNumber
            return
        }
        
        if pickerView == monthPickerView {
            viewModel.inputDuration.months = row - viewModel.maximumDurationNumber
            return
        }
        
        if pickerView == yearPickerView {
            viewModel.inputDuration.years = row - viewModel.maximumDurationNumber
            return
        }
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    attributedTitleForRow row: Int,
                    forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(
            string: "\(row - viewModel.maximumDurationNumber)",
            attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
        )
        return attributedString
    }
}
