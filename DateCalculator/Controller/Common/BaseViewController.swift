
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
    
    let inputCellId = "inputCellId"
    let resultCellId = "resultCellId"
    
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
        setupDarkMode()
        setupAds()
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "refresh"), style: .plain, target: self, action: #selector(didTapRefresh))
        
        view.addSubview(tableView)
        tableView.constraintTo(top: view.layoutMarginsGuide.topAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, topConstant: 0, bottomConstant: 0, leftConstant: 0, rightConstant: 0)
    }
    
    private func setupAds() {
        if isFreeVersion {
            bannerView = createAndLoadBannerView()
            interstitial = createInterstitial()
        }
    }
 
    @objc func didTapRefresh() {
       
    }
    
    func setupDarkMode() {
        navigationController?.navigationBar.isTranslucent = false
        if #available(iOS 13, *) {
            navigationController?.navigationBar.backgroundColor = .systemBackground
            navigationController?.navigationBar.tintColor = traitCollection.userInterfaceStyle.themeColor
            tabBarController?.tabBar.tintColor = traitCollection.userInterfaceStyle.themeColor
            tabBarController?.tabBar.backgroundColor = .systemBackground
        } else {
            navigationController?.navigationBar.backgroundColor = .white
            navigationController?.navigationBar.tintColor = .purpleLilac
            tabBarController?.tabBar.tintColor = .purpleLilac
            tabBarController?.tabBar.backgroundColor = .white
        }
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

extension BaseViewController: GADBannerViewDelegate {
    private func createAndLoadBannerView() -> GADBannerView? {
        let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
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
    private func createInterstitial() -> GADInterstitial? {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-7005013141953077/8664100148")
        
        interstitial.delegate = self
        
        return interstitial
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        ad.present(fromRootViewController: self)
    }
}
