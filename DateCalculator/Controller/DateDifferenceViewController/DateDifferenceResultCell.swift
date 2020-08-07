//
//  DateDifferenceResultCell.swift
//  DateCalculator
//
//  Created by Macbook on 4/20/19.
//  Copyright © 2019 Dai Tran. All rights reserved.
//

import UIKit

class DateDifferenceResultCell: UITableViewCell {
    @IBOutlet weak var outputTitleLabel: UILabel!
    @IBOutlet weak var dayTitleLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthTitleLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearTitleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var dateDifferenceResult: DateDifferenceResult? {
        didSet {
            guard let dateDifferenceResult = dateDifferenceResult else { return }
            dayLabel.text = String(dateDifferenceResult.days)
            monthLabel.text = String(dateDifferenceResult.months)
            yearLabel.text = String(dateDifferenceResult.years)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layer = CAGradientLayer()
        layer.frame = containerView.bounds
        layer.colors = [UIColor.lowFlattenPurple.cgColor, UIColor.highFlattenPurple.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 1)
        layer.endPoint = CGPoint(x: 1, y: 0)
        containerView.layer.insertSublayer(layer, at: 0)
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 10
    }
}
