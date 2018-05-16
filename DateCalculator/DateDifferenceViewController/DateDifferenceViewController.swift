//
//  ViewController.swift
//  DateCalculator
//
//  Created by Dai Tran on 5/2/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit
import GoogleMobileAds

class DateDifferenceViewController: UIViewController, DateDifferenceInputCellDelegate {
    
    let inputCellId = "inputCellId"
    let resultCellId = "resultCellId"
    
    var resultData: [(String, String)] = [("Day", "0"), ("Month", "0"), ("Year","0")]
    var inputDates: [Date] = [Date(), Date()]
    
    var isLightTheme = UserDefaults.standard.bool(forKey: isLightThemeKey)
    
    var bannerView: GADBannerView?
    
    var interstitial: GADInterstitial?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(DateDifferenceInputCell.self, forCellReuseIdentifier: inputCellId)
        tableView.register(DateDifferenceOutputCell.self, forCellReuseIdentifier: resultCellId)
        setupLayout()
        setupAds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isLightTheme = UserDefaults.standard.bool(forKey: isLightThemeKey)
        loadThemeAndUpdateFormat(isLightTheme: isLightTheme)
    }
    
    func setupAds() {
        if (isFreeVersion) {
            bannerView = createAndLoadBannerView()
            interstitial = createAndLoadInterstitial()
        }
    }
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        navigationItem.title = NSLocalizedString("TheDifferenceBetweenTwoDates", comment: "") 
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "refresh"), style: .plain, target: self, action: #selector(onRefreshAction))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "home"), style: .plain, target: self, action: #selector(onGoHomeAction))
        navigationController?.navigationBar.barTintColor = .white
        tabBarController?.tabBar.barTintColor = .white
        
        view.addSubview(tableView)
        tableView.constraintTo(top: view.layoutMarginsGuide.topAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, topConstant: 0, bottomConstant: 0, leftConstant: 0, rightConstant: 0)
    }
    
    
    fileprivate func getDateComponents(from firstDate: Date, to secondDate: Date) -> DateComponents {
        let calendar = Calendar.current
        let firstDateComponents = calendar.dateComponents([.day], from: firstDate)
        let secondDateComponents = calendar.dateComponents([.day], from: secondDate)
        let dateComponents = calendar.dateComponents([.day], from: firstDateComponents, to: secondDateComponents)
        return dateComponents
    }
    
    func updateTableView() {
        for row in 0..<tableView.numberOfRows(inSection: 1) {
            let indexPath = IndexPath(row: row, section: 1)
            let cell = tableView.cellForRow(at: indexPath) as! DateDifferenceOutputCell
            cell.resultData = resultData[row]
        }
    }
    
    func resetDate() {
        let section = 0
        for row in 0..<tableView.numberOfRows(inSection: section) {
            let indexPath = IndexPath(row: row, section: section)
            let cell = tableView.cellForRow(at: indexPath) as? DateDifferenceInputCell
            cell?.resetDate()
        }
        inputDates = [Date(), Date()]
    }
    
    func calculateDateDifference(from date1: Date, and date2: Date) -> [(String, String)] {
        let calendarComponents = [Calendar.Component.day, Calendar.Component.month, Calendar.Component.year]
        let calendar = Calendar.current
        
        let firstDateComponents: DateComponents = calendar.dateComponents([.day, .month, .year], from: date1)
        let secondDateComponents: DateComponents = calendar.dateComponents([.day, .month, .year], from: date2)
        
        var dayMonthYear = [("Day", ""), ("Month", ""), ("Year","")]
        
        for i in 0..<calendarComponents.count {
            let calendarComponent = calendarComponents[i]
            let dateComponents = calendar.dateComponents([calendarComponent], from: firstDateComponents, to: secondDateComponents)
            
            var componentValue = dateComponents.day ?? dateComponents.month ?? dateComponents.year ?? 0
            
            componentValue = componentValue > 0 ? componentValue : componentValue * -1
            dayMonthYear[i].1 = String(componentValue)
        }
        
        return dayMonthYear
    }
    
    func calculateAndUpdateView() {
        resultData = calculateDateDifference(from: inputDates[0], and: inputDates[1])
        updateTableView()
    }
    
    func updateDataModel(containingCell tag: Int, updated date: Date) {
        inputDates[tag] = date
    }
}

//MARK: Conform UITableView Protocols
extension DateDifferenceViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = isLightTheme ? .purpleLilac : .orange
        
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.text = section == 0 ? NSLocalizedString("INPUT", comment: "") : NSLocalizedString("OUTPUT", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
        headerView.addSubview(label)
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : resultData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: inputCellId, for: indexPath) as! DateDifferenceInputCell
            cell.loadTheme(isLightTheme: isLightTheme)
            cell.tag = indexPath.row
            cell.delegate = self
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: resultCellId, for: indexPath) as! DateDifferenceOutputCell
        cell.resultData = resultData[indexPath.row]
        cell.loadTheme(isLightTheme: isLightTheme)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }
        return 40
    }
}

//MARK: Conform UITextFieldDelegate
extension DateDifferenceViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

//MARK: Conform HomeViewControllerDelegate
extension DateDifferenceViewController: HomeViewControllerDelegate {
    func loadThemeAndUpdateFormat(isLightTheme: Bool) {
        self.isLightTheme = isLightTheme
        self.tableView.backgroundColor = isLightTheme ? UIColor.white : UIColor.black
            
        navigationController?.navigationBar.barTintColor = isLightTheme ? UIColor.white : UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: isLightTheme ? UIColor.black : UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12)]
        navigationController?.navigationBar.tintColor = isLightTheme ? UIColor.purpleLilac : UIColor.orange
            
        tabBarController?.tabBar.tintColor = isLightTheme ? UIColor.purpleLilac : UIColor.orange
        tabBarController?.tabBar.barTintColor = isLightTheme ? UIColor.white : UIColor.black
            
        UIApplication.shared.statusBarStyle = isLightTheme ? .default : .lightContent
            
        view.backgroundColor = isLightTheme ? UIColor.white : UIColor.black
        
        tableView.reloadData()
    }
    
    func showUpgradeAlert() {
        self.presentAlert(title: NSLocalizedString("Appname", comment: ""), message: NSLocalizedString("UpgradeMessage", comment: ""), isUpgradeMessage: true)
    }
    
}

// MARK: Button event
extension DateDifferenceViewController {
    
    @objc func onRefreshAction() {
        resetDate()
        resultData = calculateDateDifference(from: inputDates[0], and: inputDates[1])
        updateTableView()
    }
    
    @objc func onGoHomeAction() {
        let homeViewController = HomeViewController()
        let nav = UINavigationController(rootViewController: homeViewController)
        homeViewController.delegate = self
        present(nav, animated: true)
    }
    
    func presentAlert(title: String, message: String, isUpgradeMessage: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Done", comment: ""), style: .cancel, handler: nil))
        if (isUpgradeMessage) {
            alert.addAction(UIAlertAction(title: NSLocalizedString("Upgrade", comment: ""), style: .default, handler: { (action) in
                self.rateApp(appId: "id1381419314") { success in
                    print("RateApp \(success)")
                }
            }))
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
}

extension DateDifferenceViewController : GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
        
        // Reposition the banner ad to create a slide down effect
        let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
        bannerView.transform = translateTransform
        
        UIView.animate(withDuration: 0.5) {
            self.tableView.tableHeaderView?.frame = bannerView.frame
            bannerView.transform = CGAffineTransform.identity
            self.tableView.tableHeaderView = bannerView
        }
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to receive ads")
        print(error)
    }
}

extension DateDifferenceViewController : GADInterstitialDelegate {
    fileprivate func createAndLoadInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-7005013141953077/5926785468")
        
        guard let interstitial = interstitial else {
            return nil
        }
        
        let request = GADRequest()
        // Remove the following line before you upload the app
        request.testDevices = [ kGADSimulatorID ]
        interstitial.load(request)
        interstitial.delegate = self
        
        return interstitial
    }
    
    func createAndLoadBannerView() -> GADBannerView? {
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        guard let bannerView = bannerView else {
            return nil
        }
        bannerView.adUnitID = "ca-app-pub-7005013141953077/4204266995"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        return bannerView
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        presentAlert(title: NSLocalizedString("Appname", comment: ""), message: NSLocalizedString("UpgradeMessage", comment: ""), isUpgradeMessage: true)
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        presentAlert(title: NSLocalizedString("Appname", comment: ""), message: NSLocalizedString("UpgradeMessage", comment: ""), isUpgradeMessage: true)
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        ad.present(fromRootViewController: self)
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        presentAlert(title: NSLocalizedString("Appname", comment: ""), message: NSLocalizedString("UpgradeMessage", comment: ""), isUpgradeMessage: true)
    }
}


