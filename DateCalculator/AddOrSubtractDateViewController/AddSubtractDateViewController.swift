//
//  AddSubtractDateViewController.swift
//  DateCalculator
//
//  Created by Dai Tran on 5/3/18.
//  Copyright © 2018 Dai Tran. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AddSubtractDateViewController: DateDifferenceViewController {
    
    let addSubtractDateCellId = "addSubtractCellId"
    
    var dayMonthYear: [Int] = [0, 0, 0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("AddOrSubtractADuration", comment: "") 
        tableView.register(AddSubtractDateDurationCell.self, forCellReuseIdentifier: addSubtractDateCellId)
        
        let currentDate = Date()
        let dateString = currentDate.getDateString()
        resultData = [("Date", dateString)]
    }
    
    override func setupAds() {
        if (isFreeVersion) {
            bannerView = createAndLoadBannerView()
        }
    }
    
    override func resetDate() {
        let section = 0
        for row in 0..<tableView.numberOfRows(inSection: section) {
            let indexPath = IndexPath(row: row, section: section)
            if let cell = tableView.cellForRow(at: indexPath) as? AddSubtractDateDurationCell {
                cell.resetDate()
                continue
            }
            let cell = tableView.cellForRow(at: indexPath) as? DateDifferenceInputCell
            cell?.resetDate()
        }
        
        inputDates = [Date()]
        dayMonthYear = [0, 0, 0]

    }
        
    override func onRefreshAction() {
        resetDate()
        calculateAndUpdateView()
    }
    
    override func calculateAndUpdateView() {
        resultData = calculateDateFromDuration(from: dayMonthYear)
        updateTableView()
    }
    
    func calculateDateFromDuration(from dayMonthYear: [Int]) -> [(String, String)] {
        
        var inputDate: Date = inputDates[0]
        
        let calendarComponents = [Calendar.Component.day, Calendar.Component.month, Calendar.Component.year]
        for i in 0..<calendarComponents.count {
            let value = dayMonthYear[i]
            if let newDate = Calendar.current.date(byAdding: calendarComponents[i], value: value, to: inputDate) {
                inputDate = newDate
            }
        }
        
        var result = [("Day", "")]
        
        let dateString = inputDate.getDateString()
        result[0].1 = dateString
        
        return result
    }
    
    override func updateTableView() {
        for row in 0..<tableView.numberOfRows(inSection: 1) {
            let indexPath = IndexPath(row: row, section: 1)
            let cell = tableView.cellForRow(at: indexPath) as! DateDifferenceOutputCell
            cell.resultData = resultData[row]
        }
    }
    
}

extension AddSubtractDateViewController: AddSubtractTableViewCellDelegate {
    func updateDataModel(dayMonthYear: [Int]) {
        self.dayMonthYear = dayMonthYear
    }
}

extension AddSubtractDateViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return indexPath.row == 0 ? 85 : 225
        }
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: inputCellId, for: indexPath) as! DateDifferenceInputCell
                cell.delegate = self
                cell.loadTheme(isLightTheme: isLightTheme)
                cell.disableUserInteraction(isFreeVersion: isFreeVersion)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: addSubtractDateCellId, for: indexPath) as! AddSubtractDateDurationCell
            cell.delegate = self
            cell.loadTheme(isLightTheme: isLightTheme)
            cell.disableUserInteraction(isFreeVersion: isFreeVersion)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: resultCellId, for: indexPath) as! DateDifferenceOutputCell
        cell.resultData = resultData[indexPath.row]
        cell.loadTheme(isLightTheme: isLightTheme)
        return cell
    }
}








