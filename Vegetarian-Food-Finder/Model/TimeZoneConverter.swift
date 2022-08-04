//
//  TimeZoneCalculator.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/28/22.
//

import CoreLocation
import Foundation
import UIKit

/// A class that is responsible for date manuplation so the user can make events at their desiered time
final class TimeZoneConverter {
    let selectedRestaurant: BusinessDetails
    init(
        selectedRestaurant: BusinessDetails
    ) {
        self.selectedRestaurant = selectedRestaurant
    }

    /// computed property that represents the TimeZone of the user
    private var userCurrnetTime: TimeZone {
        return TimeZone.current
    }

    /// Enum that handles the case if the restaurant is closed
    enum PickedDateError: Error {
        case invalidDate
    }

    /**
      gets the restaurants TimeZone by using reverseGeocoding for locations

     - parameter  completion handler: Gives back the TimeZone of the restaurant

     - Returns: TimeZone of the restaurant
     */
    func restaurantLocalTime(
        completion: @escaping
        (TimeZone, Error) -> Void
    ) {
        let location = CLLocation(
            latitude: selectedRestaurant.coordinates.latitude,
            longitude: selectedRestaurant.coordinates.longitude)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { placeMarks, error in
            if let placeMark = placeMarks?[0].timeZone, let err = error {
                completion(placeMark, err)
            }
        }
    }

    /**
      gets the number of days that restaurant is open

     - Returns: an array of int
     */
    func getDayNumber(
    ) -> [Int] {
        var pickedDay = [0]
        let restaurantWorkingHoursDetails = selectedRestaurant.hours.weekDetails
        for dayNumber in restaurantWorkingHoursDetails {
            pickedDay.append(dayNumber.day)
        }
        return pickedDay
    }

    /**
      Checks if the restaurant is open at the date the user picked

     - parameter  pickedDate: UIDatePicker representing the date the user picked

     returns dictionary of Bool(represents If restaurant open) and Int(day that it's open)
     */
    func checkIfOpenAt(
        pickedDate: UIDatePicker
    ) -> [Bool: Int] {
        let index = Calendar.current.component(.weekday, from: pickedDate.date)
        let weekDays = getDayNumber()
        for day in weekDays {
            if day == index {
                return [true: day]
            }
        }
        return [false: 0]
    }

    /**
      converts the given Time from the Api(String) to Int of hour and minutes

     - parameter  timeString: Time String that is provided by Yelp

     returns dictionary of Int(represents the Hour) and Int(represents the Minutes)
     */
    func convertToTimeInt(
        timeString: String
    ) -> [Int: Int] {
        var intgerTime = [0: 0]
        if let hour = Int(timeString.prefix(2)),
           let minutes = Int(timeString.suffix(2)) {
            intgerTime = [hour: minutes]
        }
        return intgerTime
    }

    /**
      Combines the day the user picked and the operating Hour

     - parameter  date: the day that the user picked
     - parameter  time: Dictionary of the key int(represents Hour) and Value int(represents Minutes)

     returns a date
     */
    func combineDateWithTime(
        date: Date,
        time: [Int: Int]
    ) -> Date? {
        let calendar = NSCalendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        var mergedComponents = DateComponents()
        mergedComponents.year = dateComponents.year
        mergedComponents.month = dateComponents.month
        mergedComponents.day = dateComponents.day
        mergedComponents.hour = time.first?.key
        mergedComponents.minute = time.first?.value
        return calendar.date(from: mergedComponents)
    }

    /**
      Converts the Operating Hours to dates based on the users TimeZone

     - parameter  date: the day that the user picked
     - parameter  completion handler : gets back the starting and ending time for the picked date and an error

     returns starting and ending time of the restaurant operating hours based on the user's timeZone for the picked date, and an error
     */
    func convertOperatingHoursToLocalDate(
        choosenDate: UIDatePicker,
        completion: @escaping (Date?,
                               Date?,
                               Error
        ) -> Void) {
        let isOpen = checkIfOpenAt(pickedDate: choosenDate)
        let daysDetails = selectedRestaurant.hours.weekDetails
        var restaurantOpeningHour: String = "0800"
        var restaurantEndingHour: String = "1800"
        var restaurantLocalTimeZone: TimeZone = TimeZone.current
        var restaurantStartDateTime: [Int: Int] = [0: 0]
        var restaurantEndDateTime: [Int: Int] = [0: 0]

        if isOpen.first?.key == false {
            let error = PickedDateError.invalidDate
            completion(Date(), Date(), error)
            return
        }
        for dayNumber in daysDetails {
            if dayNumber.day == isOpen.first?.value {
                restaurantOpeningHour = dayNumber.start
                restaurantEndingHour = dayNumber.end
            }
        }

        restaurantLocalTime { timeZone, error in
            restaurantLocalTimeZone = timeZone
            restaurantStartDateTime = self.convertToTimeInt(timeString: restaurantOpeningHour)
            restaurantEndDateTime = self.convertToTimeInt(timeString: restaurantEndingHour)
            if let pickedDateStartTime = self.combineDateWithTime(date: choosenDate.date, time: restaurantStartDateTime),
               let pickedDateEndTime = self.combineDateWithTime(date: choosenDate.date, time: restaurantEndDateTime)
            {
                var tempCalendar = Calendar.current
                tempCalendar.timeZone = restaurantLocalTimeZone
                let userStartTimeDateComponents = tempCalendar.dateComponents(in: self.userCurrnetTime, from: pickedDateStartTime)
                let userEndTimeDateComponents = tempCalendar.dateComponents(in: self.userCurrnetTime, from: pickedDateEndTime)
                let startDate = tempCalendar.date(from: userStartTimeDateComponents)
                let endDate = tempCalendar.date(from: userEndTimeDateComponents)
                completion(startDate, endDate, error)
            }
        }
    }
}
