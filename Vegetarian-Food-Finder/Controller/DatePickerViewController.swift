//
//  DatePickerViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 8/4/22.
//

import UIKit

class DatePickerViewController: UIViewController {
    var restaurantDetails: BusinessDetails?
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        setdatePicker()
    }

    @IBAction func btnSegPressed(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: datePicker.preferredDatePickerStyle = .compact
        case 1: datePicker.preferredDatePickerStyle = .inline
        case 2: datePicker.preferredDatePickerStyle = .wheels
        default: break
        }
    }

    func setdatePicker() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: .valueChanged)
        datePicker.minimumDate = Date()
    }

    @objc func dateChange(datePicker: UIDatePicker){
        let date = fomateDate()
        dateLabel.text = date
    }
    
    func fomateDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let date = dateFormatter.string(from: datePicker.date)
        return date
    }
    
    @IBAction func userTimeZoneBtn(_ sender: Any) {
    }

    @IBAction func restaurantTimeZoneBtn(_ sender: Any) {
    }
}
