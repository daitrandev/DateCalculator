//
//  HomeView.swift
//  BaseConverter
//
//  Created by Dai Tran on 4/23/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit
import MessageUI

class HomeView: UIView, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var themeButton: UIButton!
    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    
    weak var delegate: HomeViewController?
    
    var isLightTheme = UserDefaults.standard.bool(forKey: isLightThemeKey)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func onThemeAction(_ sender: UIButton) {
        isLightTheme = !isLightTheme
        loadTheme()
        delegate?.loadTheme(isLightTheme: isLightTheme)
        UserDefaults.standard.set(isLightTheme, forKey: isLightThemeKey)
    }
    
    @IBAction func onFeedBackAction(_ sender: UIButton) {
        delegate?.presentMailComposeViewController()
    }
    
    @IBAction func onRatingAction(_ sender: UIButton) {
        delegate?.presentRatingAction()
    }
    
    @IBAction func onSharingAction(_ sender: UIButton) {
        delegate?.presentShareAction()
    }
    
    func updateLabelText() {
        themeLabel.adjustsFontSizeToFitWidth = true
        feedbackLabel.adjustsFontSizeToFitWidth = true
        rateLabel.adjustsFontSizeToFitWidth = true
        shareLabel.adjustsFontSizeToFitWidth = true
        
        themeLabel.text = NSLocalizedString("Theme", comment: "")
        feedbackLabel.text = NSLocalizedString("Feedback", comment: "")
        rateLabel.text = NSLocalizedString("Rate", comment: "")
        shareLabel.text = NSLocalizedString("Share", comment: "")
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "Home", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}

extension HomeView {
    func loadTheme() {
        backgroundColor = isLightTheme ? UIColor.white : UIColor.black
        let labelArray = [themeLabel, feedbackLabel, rateLabel, shareLabel]
        
        if isLightTheme {
            themeButton.setImage(#imageLiteral(resourceName: "theme-purpleLilac"), for: .normal)
            feedbackButton.setImage(#imageLiteral(resourceName: "feedback-purpleLilac"), for: .normal)
            rateButton.setImage(#imageLiteral(resourceName: "rate-purpleLilac"), for: .normal)
            shareButton.setImage(#imageLiteral(resourceName: "share-purpleLilac"), for: .normal)
            
        } else {            
            themeButton.setImage(#imageLiteral(resourceName: "theme-orange"), for: .normal)
            feedbackButton.setImage(#imageLiteral(resourceName: "feedback-orange"), for: .normal)
            rateButton.setImage(#imageLiteral(resourceName: "rate-orange"), for: .normal)
            shareButton.setImage(#imageLiteral(resourceName: "share-orange"), for: .normal)
            
        }
        
        for i in 0..<labelArray.count {
            labelArray[i]?.textColor = isLightTheme ? UIColor.black : UIColor.white
        }
        
    }
}
