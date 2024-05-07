//
//  DateExtension.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 05/10/21.
//

import Foundation

extension Date {
    static var yesterday:           Date { return Date().dayBefore }
    static var tomorrow:            Date { return Date().dayAfter }
    static var sevenDayPrevious:    Date { return Date().sevenDayBefore }
    static var oneMonthPrevious:    Date { return Date().oneMonthBefore}
    static var oneYearPrevious:    Date { return Date().oneYearBefore}
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    var sevenDayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -6, to: noon)!
    }
    var oneMonthBefore: Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: noon)!
    }
    var oneYearBefore: Date {
        return Calendar.current.date(byAdding: .year, value: -1, to: noon)!
    }
    
    func dateCompare(date: String) -> Bool {        
       let oldDate1 = UTCFormatter(date: date)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.timeZone = TimeZone.current
        dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//        guard let oldDate = oldDate1 else { return false }
        let dateToString = dateFormatter2.string(from: oldDate1)
        
        guard let oldDate = dateFormatter2.date(from: dateToString)!.removeTimeStamp else { return false }
        
        guard let currentDate = Date().removeTimeStamp else { return false }
        let dateFormatter3 = DateFormatter()
        dateFormatter3.timeZone = TimeZone.current
        dateFormatter3.dateFormat = "yyyy-MM-dd"
        let formatDate = dateFormatter3.string(from: currentDate)
        let currentDateFromString = dateFormatter3.date(from: formatDate)
        
        //If seen date from json response is lower from the current date, then return true otherwise return false
        guard let currentDate = currentDateFromString else { return false }
        print("DateCompare---->\(currentDate) \(oldDate)")
        if oldDate < currentDate {
            return true
        } else {
            return false
        }
    }
}

extension Date {
    public var removeTimeStamp : Date? {
       guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
        return nil
       }
       return date
   }
}

//MARK: -----Get GMT Timezone
extension Date {
    func GMToffsetInHours() -> String {
        let currentTimezone = Calendar.current.timeZone.secondsFromGMT()
        let hours = currentTimezone/3600
        let minutes = abs(currentTimezone/60) % 60
        let tz_hr = String(format: "%+.2d:%.2d", hours, minutes) // "+hh:mm"
        return tz_hr
    }
}

//MARK: -----Format Date
extension Date {
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formatDate = dateFormatter.string(from: date)
        debugPrint("Date Extension Format Date--->",formatDate)
        return formatDate
    }
}

extension Date {
    func UTCFormatter(date: String) -> Date {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let dateFromString = dateFormatter1.date(from: date)
        debugPrint("Date Extension UTC Format Date--->",dateFromString!)
        return dateFromString!
    }
}

//MARK: ----Time Difference
extension Date {
    func timeDifference(startTime: Date, endTime: Date) -> String {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.second], from: startTime, to: endTime)
        let seconds = dateComponents.second
        guard let second = seconds else { return "0" }
        print("Time Track Seconds-------: \(second)")
        return "\(second)"
        
////        let time1 = "10:30AM"
////        let time2 = "1:30PM"
//
//        let formatter = DateFormatter()
//        formatter.timeZone = TimeZone.current
//        formatter.dateFormat = "h:mma"
//        let time1 = formatter.string(from: startTime)
//        let time2 = formatter.string(from: endTime)
//
//        let time1StringToDate = formatter.date(from: time1)
//        let time2StringToDate = formatter.date(from: time2)
//
//        let elapsedTimeInSeconds = time2StringToDate!.timeIntervalSince(time1StringToDate!)
//
//        print("Elapsed time in second----->\(elapsedTimeInSeconds)")
//
//        return "\(elapsedTimeInSeconds)"
//
////        // convert from seconds to hours, rounding down to the nearest hour
////        let hours = floor(elapsedTimeInSeconds / 60 / 60)
////
////        // we have to subtract the number of seconds in hours from minutes to get
////        // the remaining minutes, rounding down to the nearest minute (in case you
////        // want to get seconds down the road)
////        let minutes = floor((elapsedTime - (hours * 60 * 60)) / 60)
//
////        print("\(Int(hours)) hr and \(Int(minutes)) min")
    }
}

//MARK: ----- Media Playback Time Duration Formatter. E.g - 04:02:33
extension Date {
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

//MARK: ----- Convert Second(Int) to H:m:s
extension Date {
    func convertSecondsToHourMinutesSecond(_ second: Int) -> (Int, Int, Int) {
        //(Hour : Minutes : Seconds)
        return (second / 3600, (second % 3600) / 60, (second % 3600) % 60)
    }
}
