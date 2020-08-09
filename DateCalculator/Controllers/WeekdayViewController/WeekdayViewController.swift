//
//  WeekDayViewController.swift
//  DateCalculator
//
//  Created by Dai Tran on 5/11/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit

class WeekdayViewController: UIViewController {
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var outputContainerView: UIView!
    @IBOutlet weak var weekdayToggleTableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    private let cellId = "cellId"
    private var contentSizeObserver: NSKeyValueObservation?
    private var viewModel: WeekdayViewModelType
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        contentSizeObserver = weekdayToggleTableView
            .observe(\.contentSize) { [weak self] (tableView, change) in
                self?.tableViewHeightConstraint.constant = tableView.contentSize.height
            }
        
        navigationItem.title = "Weekdays Between Two Dates"
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
        
    }
}
