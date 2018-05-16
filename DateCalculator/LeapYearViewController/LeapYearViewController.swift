//
//  LeapYearViewController.swift
//  DateCalculator
//
//  Created by Dai Tran on 5/15/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit

class LeapYearViewController: DateDifferenceViewController {
    
    let leapYearOutputCellId = "leapYearOutputCellId"
    var isLeapYear = false
    var checkingYear: Int = 2018
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("CheckLeapYear", comment: "")
        tableView.register(LeapYearOutputCell.self, forCellReuseIdentifier: leapYearOutputCellId)
        
        let currentDate = Date()
        guard let currentYear = Calendar.current.dateComponents([.year], from: currentDate).year else { return }
        isLeapYear = checkLeapYear(year: currentYear)
        checkingYear = currentYear
    }
    
    override func setupAds() {
        if (isFreeVersion) {
            bannerView = createAndLoadBannerView()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: inputCellId, for: indexPath) as! DateDifferenceInputCell
            cell.loadTheme(isLightTheme: isLightTheme)
            cell.tag = indexPath.row
            cell.disableUserInteraction(isFreeVersion: isFreeVersion)
            cell.delegate = self
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: leapYearOutputCellId, for: indexPath) as! LeapYearOutputCell
        cell.loadTheme(isLightTheme: isLightTheme)
        cell.checkingYear = checkingYear
        cell.isLeapYear = isLeapYear
        return cell
    }
    
    override func updateTableView() {
        let indexPath = IndexPath(row: 0, section: 1)
        let cell = tableView.cellForRow(at: indexPath) as? LeapYearOutputCell
        cell?.checkingYear = checkingYear
        cell?.isLeapYear = isLeapYear
    }
    
    override func updateDataModel(containingCell tag: Int, updated date: Date) {
        guard let currentYear = Calendar.current.dateComponents([.year], from: date).year else { return }
        checkingYear = currentYear
    }
    
    override func calculateAndUpdateView() {
        isLeapYear = checkLeapYear(year: checkingYear)
        updateTableView()
    }
    
    func getCurrentYear() -> Int {
        let currentDate = Date()
        guard let currentYear = Calendar.current.dateComponents([.year], from: currentDate).year else { return 0 }
        return currentYear
    }
    
    func checkLeapYear(year: Int) -> Bool {
        return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
    }
    
    override func onRefreshAction() {
        resetDate()
        checkingYear = getCurrentYear()
        isLeapYear = checkLeapYear(year: checkingYear)
        updateTableView()
    }
}
