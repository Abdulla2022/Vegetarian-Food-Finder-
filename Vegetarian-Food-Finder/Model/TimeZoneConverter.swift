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
    /// computed property that represents the TimeZone of the user
    private var userTimeZone: TimeZone {
        return TimeZone.current
    }
    
    /**
     gets the restaurants TimeZone by using reverseGeocoding for locations
     
     - parameter  completion handler: Gives back the TimeZone of the restaurant
     
     */
    func fetchRestaurantTimezone(selectedRestaurant: BusinessDetails,
                                 completion: @escaping
                                 (TimeZone, Error) -> Void
    ) {
        guard let selctedRestaurantLatitude = selectedRestaurant.Coordinates?.latitude, let selectedRestaurantLongitude = selectedRestaurant.Coordinates?.longitude else {
            return
        }
        let location = CLLocation(
            latitude: selctedRestaurantLatitude,
            longitude: selectedRestaurantLongitude)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { placeMarks, error in
            if let timeZone = placeMarks?[0].timeZone, let err = error {
                completion(timeZone, err)
            }
        }
    }
    
    /**
     converts the given Time from the Api(String) to Int of hour and minutes
     
     - parameter  timeString: Time String that is provided by Yelp
     
     returns dictionary of Int(represents the Hour) and Int(represents the Minutes)
     */
    func convertToTimeInt(
        timeString: String
    ) -> (Int, Int) {
        var intgerTime = (0,0)
        if let OpeningHour = Int(timeString.prefix(2)),
           let OpeningMinutes = Int(timeString.suffix(2)) {
            intgerTime = (OpeningHour,OpeningMinutes)
        }
        return intgerTime
    }
    
    /**
     Combines the day the user picked and the operating Hour
     
     - parameter  date: the day that the user picked
     - parameter  time: a tuple of ints. representing hours and minutes
     
     returns a date
     */
    func combineDateWithTime(
        date: Date,
        time: (Int,Int)
    ) -> Date? {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.hour = ((time.0)+5)
        components.minute = time.1
        components.second = 0
        return calendar.date(from: components)
    }
    
    func setUpRestaurantTimeDate(givenDate :Date,openingTime:String, closingTime:String) -> (Date?,Date?){
        let restaurantStartHour = self.convertToTimeInt(timeString: openingTime)
        let restaurantEndHour = self.convertToTimeInt(timeString: closingTime)
        let pickedDateStartTime = self.combineDateWithTime(date: givenDate, time: restaurantStartHour)
        let pickedDateEndTime = self.combineDateWithTime(date: givenDate, time: restaurantEndHour)
        return (pickedDateStartTime,pickedDateEndTime)
    }
    
    /**
     Converts the Operating Hours to dates based on the users TimeZone
     
     - parameter  date: the day that the user picked
     - parameter  completion handler : gets back the starting and ending time for the picked date and an error
     
     returns starting and ending time of the restaurant operating hours based on the user's timeZone for the picked date, and an error
     */
    func convertRestaurantTimeToUsersTime(
        selectedRestaurant: BusinessDetails,
        choosenDate: Date,
        completion: @escaping (Date?, Date?, Error?) -> Void) {
            fetchRestaurantTimezone(selectedRestaurant: selectedRestaurant) { [weak self] restaurantTimeZone, error in
                let selectedDay = Calendar.current.component(.weekday, from: choosenDate)
                let hoursDetails = self?.getRestaurantOperatingHours(restaurant: selectedRestaurant, date: choosenDate, selectedDay: selectedDay)
                guard let self = self,
                      let openingHour = hoursDetails?.0,
                      let endingHour = hoursDetails?.1
                else {
                    completion(nil,nil,nil)
                    return
                }
                let restaurantDate = self.setUpRestaurantTimeDate(givenDate: choosenDate, openingTime: openingHour, closingTime: endingHour)
                guard let pickedDateStartTime = restaurantDate.0,
                      let pickedDateEndTime = restaurantDate.1 else {
                    completion(nil,nil,nil)
                    return
                }
                let userBasedDates = self.convertTimeToUserTimeZone(restaurantTimeZone: restaurantTimeZone, startDate: pickedDateStartTime, endDate: pickedDateEndTime)
                completion(userBasedDates.0, userBasedDates.1, error)
            }
        }
    
    /**
     converts time to user's time zone
     -
     - parameter  date: the picked date with the start time
     - parameter  date: the picked date with the end time
     
     returns starting and ending time of the restaurant operating hours based on the user's timeZone
     */
    
    func convertTimeToUserTimeZone(restaurantTimeZone: TimeZone, startDate: Date, endDate: Date) -> (Date?, Date?) {
        var calender = Calendar.current
        calender.timeZone = restaurantTimeZone
        
        let userStartTimeDateComponent = calender.dateComponents(in: self.userTimeZone, from: startDate)
        let userEndTimeDateComponent = calender.dateComponents(in: self.userTimeZone, from: endDate)
        
        guard let startDate = calender.date(from: userStartTimeDateComponent), let
                endDate = calender.date(from: userEndTimeDateComponent) else {
            return (nil,nil)
        }
        return (startDate, endDate)
    }
    
    /**
     gets the operating hours of the restaurant
     -
     - parameter  restaurant: the restaurants details struct
     - parameter  date: the picked date with the end time
     
     returns starting and ending time of the restaurant operating hours
     */
    func getRestaurantOperatingHours(restaurant: BusinessDetails, date: Date, selectedDay:Int) -> (String?, String?) {
        let openDates = restaurant.hours.map { weekDetails in
            return weekDetails.open
        }
        let daysDetails = Array(openDates.joined())
        let day = daysDetails.filter { opn in
            return opn.day == selectedDay
        }.first
        return (day?.start, day?.end)
    }
    
    func getRestaurantOnItTimeZone(
    selectedRestaurant: BusinessDetails,
    choosenDate: Date) -> (Date?, Date?, Error?) {
        let selectedDay = Calendar.current.component(.weekday, from: choosenDate)
        let hoursDetails = self.getRestaurantOperatingHours(restaurant: selectedRestaurant, date: choosenDate, selectedDay: selectedDay)
        guard
              let openingHour = hoursDetails.0,
              let endingHour = hoursDetails.1
        else {
            return (nil, nil, nil)
        }
        let restaurantDate = self.setUpRestaurantTimeDate(givenDate: choosenDate, openingTime: openingHour, closingTime: endingHour)
        guard let pickedDateStartTime = restaurantDate.0,
              let pickedDateEndTime = restaurantDate.1 else {
            return(nil,nil,nil)
        }
        return (pickedDateStartTime,pickedDateEndTime, nil)
    }
        
}


