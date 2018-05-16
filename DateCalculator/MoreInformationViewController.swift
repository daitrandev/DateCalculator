//
//  MoreInformationViewController.swift
//  DateCalculator
//
//  Created by Dai Tran on 5/4/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit

class MoreInformationViewController: UIViewController, DateDifferenceDelegate {
    
    let cellId = "cellId"
    
    var dateData: [(String, String)] = []
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "More information"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "close"), style: .plain, target: self, action: #selector(onCloseAction))
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.constraintTo(top: view.layoutMarginsGuide.topAnchor, bottom: view.bottomAnchor, left: view.layoutMarginsGuide.leftAnchor, right: view.layoutMarginsGuide.rightAnchor, topConstant: 0, bottomConstant: 0, leftConstant: 0, rightConstant: 0)
        tableView.register(MoreInformationTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    @objc func onCloseAction() {
        dismiss(animated: true, completion: nil)
    }
    
    func passInformation(firstDateComponents: DateComponents, secondDateComponents: DateComponents) { 
        let calendar = Calendar(identifier: .gregorian)
        
        let calendarComponents = [Calendar.Component.day, Calendar.Component.month, Calendar.Component.year, Calendar.Component.weekday,
                                  Calendar.Component.weekOfMonth, Calendar.Component.weekOfYear]
        for calenarComponent in calendarComponents {
            
            let dateComponents = calendar.dateComponents([calenarComponent], from: firstDateComponents, to: secondDateComponents)
            if let day = dateComponents.day {
                dateData.append(("Days", String(day)))
            } else if let month = dateComponents.month {
                dateData.append(("Months", String(month)))
            } else if let year = dateComponents.year {
                dateData.append(("Years", String(year)))
            } else if let weekDay = dateComponents.weekday {
                dateData.append(("Week days", String(weekDay)))
            } else if let weekOfMonth = dateComponents.weekOfMonth {
                dateData.append(("Week of month: ", String(weekOfMonth)))
            } else if let weakOfYear = dateComponents.weekOfYear {
                dateData.append(("Week of year: ", String(weakOfYear)))
            }
        }
        
        tableView.reloadData()
    }
}

extension MoreInformationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MoreInformationTableViewCell
        cell.data = dateData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

class MoreInformationTableViewCell: UITableViewCell {
    
    var data: (String, String)? {
        didSet {
            leftLabel.text = data?.0
            rightLabel.text = data?.1
        }
    }
    
    let leftLabel: UILabel = {
        let label = UILabel()
        label.text = "Years:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let rightLabel: UILabel = {
        let label = UILabel()
        label.text = "365"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(leftLabel)
        addSubview(rightLabel)
        
        leftLabel.constraintTo(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: nil, topConstant: 0, bottomConstant: 0, leftConstant: 0, rightConstant: 0)
        leftLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3).isActive = true
        
        rightLabel.constraintTo(top: topAnchor, bottom: bottomAnchor, left: leftLabel.rightAnchor, right: rightAnchor, topConstant: 0, bottomConstant: 0, leftConstant: 0, rightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

