//
//  TimeZoneCalculator.swift
//  Vegetarian-Food-Finder
//
//  Created by Abdullahi Ahmed on 7/28/22.
//

import CoreLocation
import Foundation
import UIKit

/// A class that is responsible for date manuplation so the user can get the operating hours at their desiered day
final class TimeZoneConverter {
    /// property that represents the TimeZone of the user
    private var userTimeZone = TimeZone.current

    /**
     gets the restaurants TimeZone by using reverseGeocoding for locations
     - parameter  completion handler: Gives back the TimeZone of the restaurant

     */

    func fetchRestaurantTimezone(selectedRestaurant: BusinessDetails,
                                 completion: @escaping (TimeZone?, Error?) -> Void
    ) {
        guard let selctedRestaurantLatitude = selectedRestaurant.coordinates?
            .latitude, let selectedRestaurantLongitude = selectedRestaurant.coordinates?.longitude else {
            completion(nil, nil)
            return
        }
        let location = CLLocation(
            latitude: selctedRestaurantLatitude,
            longitude: selectedRestaurantLongitude)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { placeMarks, error in
            if let timeZone = placeMarks?[0].timeZone {
                completion(timeZone, nil)
            } else if let err = error {
                completion(nil, err)
            }
        }
    }

    /**
     converts the given Time from the Api(String) to Int of hour and minute

     - parameter  timeString: Time String that is provided by Yelp

     returns a tuple of Int(representing the Hour) and Int(representing the Minutes)
     */

    func convertToTimeInt(
        timeString: String
    ) -> (hour: Int, minute: Int) {
        var intgerTime = (0, 0)
        if let OpeningHour = Int(timeString.prefix(2)),
           let OpeningMinutes = Int(timeString.suffix(2)) {
            intgerTime = (OpeningHour, OpeningMinutes)
        }
        return intgerTime
    }

    /**
     Combines the date the user picked and the operating Hour provided by the Api

     - parameter  date: the day that the user picked
     - parameter  time: a tuple of ints. representing hours and minutes
     - parameter  restaurantTimeZone: time zone of the restaurant

     returns a date object
     */

    func combineDateWithTime(date: Date, time: (hour: Int, minute: Int), restaurantTimeZone: TimeZone) -> Date? {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.timeZone = restaurantTimeZone
        components.hour = time.hour
        components.minute = time.minute
        components.second = 0
        return calendar.date(from: components)
    }

    /**
     gets the start and end time of the picked date and the hours provided by the api as a date object

     - parameter  openingTime: the restaurant opening time as string
     - parameter  closingTime: the restaurant opening time as string
     - parameter  date: the day that the user picked
     - parameter  restaurantTimeZone: time zone of the restaurant

     returns starting date and end Date
     */

    func setUpRestaurantTimeDate(givenDate: Date, openingTime: String, closingTime: String, restaurantTimeZone: TimeZone) -> (startingHour: Date, endingHour: Date)? {
        let restaurantStartHour = convertToTimeInt(timeString: openingTime)
        let restaurantEndHour = convertToTimeInt(timeString: closingTime)
        let pickedDateStartTime = combineDateWithTime(date: givenDate, time: restaurantStartHour, restaurantTimeZone: restaurantTimeZone)
        let pickedDateEndTime = combineDateWithTime(date: givenDate, time: restaurantEndHour, restaurantTimeZone: restaurantTimeZone)
        guard let pickedDateEndTime = pickedDateEndTime, let pickedDateStartTime = pickedDateStartTime else {
            return nil
        }
        return (pickedDateStartTime, pickedDateEndTime)
    }

    /**
     Converts the Operating Hours to dates based on the users TimeZone

     - parameter  selectedRestaurant: the restaurant that the user selected
     - parameter  date: the day that the user picked
     - parameter  completion handler : gets back the starting and ending time for the user timezone, and starting and ending time for restaurant timezone

     */

    func convertRestaurantTimeToUsersTime(
        selectedRestaurant: BusinessDetails,
        choosenDate: Date,
        completion: @escaping (Date.FormatStyle.FormatOutput?, Date.FormatStyle.FormatOutput?, Date.FormatStyle.FormatOutput?, Date.FormatStyle.FormatOutput?, Error?) -> Void) {
        fetchRestaurantTimezone(selectedRestaurant: selectedRestaurant) { [weak self] restaurantTimeZone, _ in
            let selectedDay = Calendar.current.component(.weekday, from: choosenDate)
            let hoursDetails = self?.getHoursFromApi(restaurant: selectedRestaurant, date: choosenDate, selectedDay: selectedDay)
            guard let openingHour = hoursDetails?.startingHour,
                  let endingHour = hoursDetails?.endingMinute else {
                completion(nil, nil, nil, nil, nil)
                return
            }
            guard let restaurantTimeZone = restaurantTimeZone else {
                completion(nil, nil, nil, nil, nil)
                return
            }
            let restaurantDate = self?.setUpRestaurantTimeDate(givenDate: choosenDate, openingTime: openingHour, closingTime: endingHour, restaurantTimeZone: restaurantTimeZone)
            guard let pickedDateStartTime = restaurantDate?.startingHour,
                  let pickedDateEndTime = restaurantDate?.endingHour else {
                completion(nil, nil, nil, nil, nil)
                return
            }
            let formattedTime = self?.convertTime(restaurantTimeZone: restaurantTimeZone, startDate: pickedDateStartTime, endDate: pickedDateEndTime)
            guard let userstaringTime = formattedTime?.userStartTime, let userendingTime = formattedTime?.userEndTime, let restaurantStartingTime = formattedTime?.restaurantStartTime, let restaurantEndingTime = formattedTime?.restaurantEndTime else {
                completion(nil, nil, nil, nil, nil)
                return
            }
            completion(userstaringTime, userendingTime, restaurantStartingTime, restaurantEndingTime, nil)
        }
    }

    /**
     gets the formatted date of the picked date

     - parameter  startingTime: the restaurant opening time
     - parameter  endingTime: the restaurant opening time
     - parameter  date: the day that the user picked

     returns formattedStartingHr and formattedEndingHr for the user timeZone
     */

    func formateForUser(timeZone: TimeZone,
                        startingTime: Date,
                        endingTime: Date
    ) -> (formattedStartingHr: Date.FormatStyle.FormatOutput, formattedEndingHr: Date.FormatStyle.FormatOutput)? {
        let tempStartDate = startingTime
        let tempEndDate = endingTime
        var format = Date.FormatStyle.dateTime
        format.timeZone = userTimeZone
        let startDate = tempStartDate.formatted(format)
        let endDate = tempEndDate.formatted(format)
        return (startDate, endDate)
    }

    /**
     gets the formatted date of the picked date

     - parameter  startingTime: the restaurant opening time
     - parameter  endingTime: the restaurant opening time
     - parameter  date: the day that the user picked
     - parameter  restaurantTimeZone: restaurannt time zone
     returns formattedStartingHr and formattedEndingHr for the restaurant timeZone
     */

    func formateForRestaurant(restaurantTimeZone: TimeZone,
                              startingTime: Date,
                              endingTime: Date
    ) -> (formattedStartingHr: Date.FormatStyle.FormatOutput, formattedEndingHr: Date.FormatStyle.FormatOutput)? {
        let tempStartDate = startingTime
        let tempEndDate = endingTime
        var format = Date.FormatStyle.dateTime
        format.timeZone = restaurantTimeZone
        let startDate = tempStartDate.formatted(format)
        let endDate = tempEndDate.formatted(format)
        return (startDate, endDate)
    }

    /**
     gets the starting and ending for user timeZone and starting and ending for restaurant TimeZone

     - parameter  restaurantTimeZone: time zone of the restaurant
     - parameter  Startdate: the picked date with the start time
     - parameter  enddate: the picked date with the end time

     returns userStartTime, userEndTime, restaurantStartTime, and restaurantEndTime
     */
    func convertTime(restaurantTimeZone: TimeZone,
                     startDate: Date,
                     endDate: Date
    ) -> (userStartTime: Date.FormatStyle.FormatOutput, userEndTime: Date.FormatStyle.FormatOutput, restaurantStartTime: Date.FormatStyle.FormatOutput, restaurantEndTime: Date.FormatStyle.FormatOutput)? {
        let userFormattedTime = formateForUser(timeZone: userTimeZone, startingTime: startDate, endingTime: endDate)
        let userStartingHrs = userFormattedTime?.formattedStartingHr
        let userEndingHrs = userFormattedTime?.formattedEndingHr

        let restaurantformatedTime = formateForRestaurant(restaurantTimeZone: restaurantTimeZone, startingTime: startDate, endingTime: endDate)
        let restaurantStartingHrs = restaurantformatedTime?.formattedStartingHr
        let restaurantEndingHrs = restaurantformatedTime?.formattedEndingHr
        guard let userStartingHrs = userStartingHrs, let userEndingHrs = userEndingHrs,
              let restaurantStartingHrs = restaurantStartingHrs, let restaurantEndingHrs = restaurantEndingHrs
        else {
            return nil
        }

        return (userStartingHrs, userEndingHrs, restaurantStartingHrs, restaurantEndingHrs)
    }

    /**
     gets the operating hours of the restaurant
     -
     - parameter  restaurant: the restaurants details struct
     - parameter  date: the picked date with the end time
     - parameter  selectedDay: the index representing the week day

     returns starting and ending time of the restaurant operating hours
     */

    func getHoursFromApi(restaurant: BusinessDetails, date: Date, selectedDay: Int) -> (startingHour: String, endingMinute: String)? {
        let day = restaurant.hours[0].open.first { details in
            details.day == selectedDay
        }
        guard let startingHour = day?.start, let endingHour = day?.end else {
            return nil
        }
        return (startingHour, endingHour)
    }
}
