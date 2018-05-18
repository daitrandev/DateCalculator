//
//  HomeViewController.swift
//  BaseConverter
//
//  Created by Dai Tran on 4/23/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit
import MessageUI
import GoogleMobileAds

class HomeViewController: UIViewController {
    
    weak var delegate: HomeViewControllerDelegate?
    
    var isLightTheme = UserDefaults.standard.bool(forKey: isLightThemeKey)
    
    var bannerView: GADBannerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews() {
        guard let homeView = HomeView.instanceFromNib() as? HomeView else { return }
        homeView.updateLabelText()
        homeView.delegate = self
        
        view = homeView
        
        navigationItem.title = NSLocalizedString("Home", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close"), style: .done, target: self, action: #selector(closedButtonAction))
        
        bannerView = createAndLoadBannerView()
    }
    
    @objc func closedButtonAction() {
        delegate?.loadThemeAndUpdateFormat(isLightTheme: isLightTheme)
        dismiss(animated: true) {
            if isFreeVersion {
                self.delegate?.loadInterstitial()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTheme(isLightTheme: isLightTheme)
        (view as? HomeView)?.loadTheme()
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
}

extension HomeViewController: HomeViewDelegate {
    
    func loadTheme(isLightTheme: Bool) {
        self.isLightTheme = isLightTheme
        navigationController?.navigationBar.tintColor = isLightTheme ? UIColor.purpleLilac : UIColor.orange
        
        navigationController?.navigationBar.barTintColor = isLightTheme ? UIColor.white : UIColor.black
        
        UIApplication.shared.statusBarStyle = isLightTheme ? .default : .lightContent
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: isLightTheme ? UIColor.black : UIColor.white]
    }

    func presentMailComposeViewController() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        }
    }
    
    func presentShareAction() {
        let appId = isFreeVersion ? "id1381419764" : "id1381419314"
        let message: String = "https://itunes.apple.com/app/\(appId)"
        let vc = UIActivityViewController(activityItems: [message], applicationActivities: [])
        vc.popoverPresentationController?.sourceView = self.view
        present(vc, animated: true)
    }
    
    func presentRatingAction() {
        let appId = isFreeVersion ? "id1381419764" : "id1381419314"
        rateApp(appId: appId) { success in
            print("RateApp \(success)")
        }
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

extension HomeViewController:  MFMailComposeViewControllerDelegate {
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["universappteam@gmail.com"])
        mailComposerVC.setSubject("[Date-Calculator++ Feedback]")
        
        return mailComposerVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension HomeViewController: GADBannerViewDelegate {
    
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
