
//
//  BaseViewController.swift
//  DateCalculator
//
//  Created by Macbook on 4/20/19.
//  Copyright © 2019 Dai Tran. All rights reserved.
//

import UIKit
import MessageUI
import GoogleMobileAds

class BaseViewController: UIViewController {
    private var bannerView: GADBannerView?
    private var interstitial: GADInterstitial?
    var isLightTheme = UserDefaults.standard.bool(forKey: isLightThemeKey)
    
    let inputCellId = "inputCellId"
    let resultCellId = "resultCellId"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isLightTheme ? .default : .lightContent
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupAds()
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "refresh"), style: .plain, target: self, action: #selector(onRefreshAction))
        navigationController?.navigationBar.barTintColor = .white
        tabBarController?.tabBar.barTintColor = .white
        
        view.addSubview(tableView)
        tableView.constraintTo(top: view.layoutMarginsGuide.topAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, topConstant: 0, bottomConstant: 0, leftConstant: 0, rightConstant: 0)
    }
    
    private func setupAds() {
        if isFreeVersion {
            bannerView = createAndLoadBannerView()
            interstitial = createInterstitial()
        }
    }
 
    @objc func onRefreshAction() {
       
    }
    
    func loadTheme(isLightTheme: Bool) {
        
    }
}

//MARK: Conform UITextFieldDelegate
extension BaseViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

extension BaseViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension BaseViewController:  MFMailComposeViewControllerDelegate {
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["universappteam@gmail.com"])
        mailComposerVC.setSubject("[Date-Converter++ Feedback]")
        
        return mailComposerVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension BaseViewController: GADBannerViewDelegate {
    func createAndLoadBannerView() -> GADBannerView? {
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        guard let bannerView = bannerView else {
            return nil
        }
        bannerView.adUnitID = "ca-app-pub-7005013141953077/8716071035"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        return bannerView
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        addBannerViewToView(bannerView)
        
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
}

extension BaseViewController: GADInterstitialDelegate {
    fileprivate func createInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-7005013141953077/8664100148")
        
        guard let interstitial = interstitial else {
            return nil
        }
        
        interstitial.delegate = self
        
        return interstitial
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        ad.present(fromRootViewController: self)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
