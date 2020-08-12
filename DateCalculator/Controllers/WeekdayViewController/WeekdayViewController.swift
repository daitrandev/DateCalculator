//
//  WeekDayViewController.swift
//  DateCalculator
//
//  Created by Dai Tran on 5/11/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit
import GoogleMobileAds

class WeekdayViewController: UIViewController {
    @IBOutlet weak var firstInputDateTextField: UITextField!
    @IBOutlet weak var secondInputDateTextField: UITextField!
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var outputContainerView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var weekdayToggleTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackView: UIStackView!
    
    private let cellId = "cellId"
    private var bannerView: GADBannerView?
    private var contentSizeObserver: NSKeyValueObservation?
    private var currentEditingTextField: UITextField?
    private var viewModel: WeekdayViewModelType
    
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
        viewModel = WeekdayViewModel()
        super.init(
            nibName: String(describing: WeekdayViewController.self),
            bundle: .main
        )
    }
    
    deinit {
        contentSizeObserver?.invalidate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.isPurchased {
            removeAds()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        if !viewModel.isPurchased {
            firstInputDateTextField.isEnabled = false
            secondInputDateTextField.isEnabled = false
            firstInputDateTextField.backgroundColor = .gray
            secondInputDateTextField.backgroundColor = .gray
            bannerView = createAndLoadBannerAds()
        }
        
        weekdayToggleTableView.register(
            UINib(
                nibName: String(describing: WeekdayToggleCell.self),
                bundle: .main
            ),
            forCellReuseIdentifier: cellId
        )
        weekdayToggleTableView.dataSource = self
        
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
        
        contentSizeObserver = weekdayToggleTableView
            .observe(\.contentSize) { [weak self] (tableView, change) in
                self?.tableViewHeightConstraint.constant = tableView.contentSize.height
            }
        
        viewModel.firstInputDate = Date()
        viewModel.secondInputDate = Date()
        
        if !viewModel.isPurchased {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: UIImage(named: "unlock"),
                style: .plain,
                target: self,
                action: #selector(didTapUnlock)
            )
        }
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont(name: "Roboto-Medium", size: 14)!
        ]
        navigationItem.title = "Weekdays Between Two Dates"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "refresh"),
            style: .plain,
            target: self,
            action: #selector(didTapRefresh)
        )
        navigationController?.navigationBar.tintColor = UIColor.purpleLilac
        tabBarController?.tabBar.tintColor = UIColor.purpleLilac
    }
    
    @objc private func datePickerValueChanged() {
        if currentEditingTextField == firstInputDateTextField {
            viewModel.firstInputDate = datePicker.date
        } else if currentEditingTextField == secondInputDateTextField {
            viewModel.secondInputDate = datePicker.date
        }
    }
    
    @objc private func didTapDone() {
        currentEditingTextField?.resignFirstResponder()
        currentEditingTextField = nil
        
        [firstInputDateTextField, secondInputDateTextField].forEach {
            $0?.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    @objc private func didTapRefresh() {
        viewModel.clear()
    }
    
    @objc private func didTapUnlock() {
        let vc = PurchasingPopupViewController()
        vc.delegate = self
        tabBarController?.present(vc, animated: true)
    }
}

extension WeekdayViewController: PurchasingPopupViewControllerDelegate {
    func removeAds() {
        firstInputDateTextField.isEnabled = true
        secondInputDateTextField.isEnabled = true
        firstInputDateTextField.backgroundColor = .white
        secondInputDateTextField.backgroundColor = .white
        
        bannerView?.removeFromSuperview()
        navigationItem.leftBarButtonItem = nil
    }
}

extension WeekdayViewController: GADBannerViewDelegate {
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
        
        stackView.insertArrangedSubview(bannerView, at: 0)
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
}

extension WeekdayViewController: WeekdayViewModelDelegate {
    func renderTotalDays() {
        totalLabel.text = String(
            format: "%@: %d", "Total days",
            viewModel.totalDays
        )
    }
    
    func renderFirstInputDate() {
        firstInputDateTextField.text = viewModel.firstInputDate.getDateString()
    }
    
    func renderSecondInputDate() {
        secondInputDateTextField.text = viewModel.secondInputDate.getDateString()
    }
    
    func reloadWeedayTableView() {
        weekdayToggleTableView.reloadData()
    }
}

extension WeekdayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        viewModel.cellLayoutItems.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? WeekdayToggleCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.cellLayoutItems[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension WeekdayViewController: WeekdayToggleCellDelegate {
    func didChangeToggle(for item: WeekdayViewModel.WeekdayToggleCellLayoutItem) {
        viewModel.didChangeToggle(for: item)
    }
}

extension WeekdayViewController: UITextFieldDelegate {
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
