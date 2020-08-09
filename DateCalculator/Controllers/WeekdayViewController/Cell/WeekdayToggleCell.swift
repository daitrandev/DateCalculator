//
//  WeekdayToggleCell.swift
//  DateCalculator
//
//  Created by DaiTran on 8/9/20.
//  Copyright © 2020 Dai Tran. All rights reserved.
//

import UIKit

protocol WeekdayToggleCellDelegate: class {
    func didChangeToggle(for item: WeekdayViewModel.WeekdayToggleCellLayoutItem)
}

class WeekdayToggleCell: UITableViewCell {
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var countNumberLabel: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    
    private var item: WeekdayViewModel.WeekdayToggleCellLayoutItem? {
        didSet {
            guard let item = item else { return }
            weekdayLabel.text = item.weekday.rawValue + ":"
            switcher.isOn = item.isSelected
            countNumberLabel.text = String(item.count)
        }
    }
    weak var delegate: WeekdayToggleCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        switcher.addTarget(self, action: #selector(switcherValueDidChange), for: .valueChanged)
    }
    
    func configure(with item: WeekdayViewModel.WeekdayToggleCellLayoutItem) {
        self.item = item
    }
    
    @objc private func switcherValueDidChange() {
        guard var item = item else { return }
        item.isSelected = switcher.isOn
        delegate?.didChangeToggle(for: item)
    }
}
