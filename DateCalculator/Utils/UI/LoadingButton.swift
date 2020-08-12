//
//  LoadingButton.swift
//  DateCalculator
//
//  Created by Dai.Tran on 8/11/20.
//  Copyright © 2020 Dai Tran. All rights reserved.
//

import UIKit

class LoadingButton: UIView {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private var buttonColor: UIColor?
    
    private var isLoading: Bool = false {
        didSet {
            indicator.isHidden = !isLoading
            isLoading ? indicator.startAnimating() : indicator.stopAnimating()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func set(title: String) {
        label.text = title
    }
    
    func set(buttonColor: UIColor) {
        self.buttonColor = buttonColor
        button.backgroundColor = buttonColor
    }
    
    func set(isEnabled: Bool) {
        button.isEnabled = isEnabled
        isLoading = !isEnabled
        
        if isEnabled {
            button.backgroundColor = buttonColor
            return
        }
        
        button.backgroundColor = .gray
    }
}
