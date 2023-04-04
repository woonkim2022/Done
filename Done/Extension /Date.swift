//
//  Date.swift
//  Done
//
//  Created by 안현정 on 2022/02/27.
//

import Foundation
import UIKit
import EventKit
import AFDateHelper

extension Date {
    
    enum FormatType {
        case full
        case year
        case day
        case month
        case second
        case time
        case calendar
        case calendarTime
        
        var description: String {
            switch self {
            case .full:
                return "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
            case .year:
                return "yyyy-MM-dd"
            case .day:
                return "M월 d일 EEEE"
            case .month:
                return "M월"
            case .second:
                return "HH:mm:ss"
            case .time:
                return "a h:mm"
            case .calendar:
                return "yyyy년 MM월 dd일"
            case .calendarTime:
                return "a HH:mm"
            }
        }
    }
    
    
    func adjust(_ component:DateComponentType, offset:Int) -> Date {
        var dateComp = DateComponents()
        switch component {
            case .second:
                dateComp.second = offset
            case .minute:
                dateComp.minute = offset
            case .hour:
                dateComp.hour = offset
            case .day:
                dateComp.day = offset
            case .weekday:
                dateComp.weekday = offset
            case .nthWeekday:
                dateComp.weekdayOrdinal = offset
            case .week:
                dateComp.weekOfYear = offset
            case .month:
                dateComp.month = offset
            case .year:
                dateComp.year = offset
        }
        return Calendar.current.date(byAdding: dateComp, to: self)!
    }
    
    /// Return a new Date object with the new hour, minute and seconds values.
    func adjust(hour: Int?, minute: Int?, second: Int?, day: Int? = nil, month: Int? = nil) -> Date {
        var comp = Date.components(self)
        comp.month = month ?? comp.month
        comp.day = day ?? comp.day
        comp.hour = hour ?? comp.hour
        comp.minute = minute ?? comp.minute
        comp.second = second ?? comp.second
        return Calendar.current.date(from: comp)!
    }
    
    internal static func componentFlags() -> Set<Calendar.Component> { return [Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.weekOfYear, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second, Calendar.Component.weekday, Calendar.Component.weekdayOrdinal, Calendar.Component.weekOfYear] }
    
    internal static func components(_ fromDate: Date) -> DateComponents {
        return Calendar.current.dateComponents(Date.componentFlags(), from: fromDate)
    }
  
    
    func toString(of type: FormatType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = type.description
        return dateFormatter.string(from: self)
    }
    
    static var calendar: Calendar = {
        return Calendar(identifier: .gregorian)
    }()
    
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
    
    var lastDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
    
    var todaysDate: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    func isWeekend() -> Bool {
        return Date.calendar.isDateInWeekend(self)
    }
    
    
    /**
     # dateCompare
     - Parameters:
     - fromDate: 비교 대상 Date
     - Note: 두 날짜간 비교해서 과거(Future)/현재(Same)/미래(Past) 반환
     */
    public func dateCompare(fromDate: Date) -> String {
        var strDateMessage:String = ""
        let result:ComparisonResult = self.compare(fromDate)
        switch result {
        case .orderedAscending:
            strDateMessage = "Future"
            break
        case .orderedDescending:
            strDateMessage = "Past"
            break
        case .orderedSame:
            strDateMessage = "Same"
            break
        default:
            strDateMessage = "Error"
            break
        }
        return strDateMessage
    }
    
    
    func isSameAs(as compo: Calendar.Component, from date: Date) -> Bool {
        var cal = Calendar.current
        cal.locale = Locale(identifier: "ko_KR")
        return cal.component(compo, from: date) == cal.component(compo, from: self)
    }
    
    
}



