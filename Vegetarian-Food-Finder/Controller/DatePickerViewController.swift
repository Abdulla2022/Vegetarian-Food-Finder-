//
//  DatePickerViewController.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 8/4/22.
//

import UIKit

class DatePickerViewController: UIViewController, StoryboardIdentifiable {
    private let datePickerToCalendar = "fromDatePickerToCalendar"
    var restaurantDetails: BusinessDetails?
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var creatEventLabel: UIButton!
    @IBOutlet var closingHoursLabel: UILabel!
    @IBOutlet var restaurantBasedClosingHourLabel: UILabel!
    @IBOutlet var restaurantBasedOpeningHourLabel: UILabel!
    @IBOutlet var openingHoursLabel: UILabel!
    let timeZoneConverter = TimeZoneConverter()
    override func viewDidLoad() {
        super.viewDidLoad()
        setdatePicker()
        fetchFormattedTime()
        setBtns(selectedBtn: creatEventLabel)
    }

    @IBAction func btnSegPressed(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: datePicker.preferredDatePickerStyle = .inline
        case 1: datePicker.preferredDatePickerStyle = .wheels
        default: break
        }
    }

    func setdatePicker() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: .valueChanged)
        datePicker.timeZone = TimeZone(secondsFromGMT: 0)
        datePicker.minimumDate = Date()
    }

    func fetchFormattedTime() {
        guard let restaurantDetails = restaurantDetails else {
            return
        }
        DispatchQueue.main.async {
            self.timeZoneConverter.convertRestaurantTimeToUsersTime(selectedRestaurant: restaurantDetails, choosenDate: self.datePicker.date) { userstartingTime, userEndingTime, restaurantStartingTime, restaurantEndingTime, err in
                if restaurantDetails.checkIfOpenAt(self.datePicker.date) && err == nil {
                    guard let userstartingTime = userstartingTime, let userEndingTime = userEndingTime, let restaurantStartingTime = restaurantStartingTime, let restaurantEndingTime = restaurantEndingTime else {
                        return
                    }
                    self.openingHoursLabel.text = userstartingTime
                    self.closingHoursLabel.text = userEndingTime
                    self.restaurantBasedOpeningHourLabel.text = restaurantStartingTime
                    self.restaurantBasedClosingHourLabel.text = restaurantEndingTime
                    return
                }
                self.openingHoursLabel.text = "Sorry we are closed"
                self.closingHoursLabel.text = "Sorry we are closed"
                self.restaurantBasedOpeningHourLabel.text = "Sorry we are closed"
                self.restaurantBasedClosingHourLabel.text = "Sorry we are closed"
            }
        }
    }

    @objc func dateChange(datePicker: UIDatePicker) {
        fetchFormattedTime()
    }

    @IBAction func didTapCalendarIcon(_ sender: Any) {
    }

    private func showCalendar(startingHours: Date?, endingHours: Date?) {
        let calendarVC: CalendarViewController = DatePickerViewController.storyboard.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
        present(calendarVC, animated: true)
    }
}
