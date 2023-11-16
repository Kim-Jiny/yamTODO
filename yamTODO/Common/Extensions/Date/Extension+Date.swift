//
//  Extension+Date.swift
//  yamTODO
//
//  Created by Jiny on 11/9/23.
//

import Foundation

extension Date {
    static let calendarDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM"
        return formatter
    }()

    static let keyDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMdd"
        return formatter
    }()
    
    static let calendarDayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy dd"
        return formatter
    }()
    
    var formattedCalendarDayDate: String {
      return Date.calendarDayDateFormatter.string(from: self)
    }
    
    static let today: Date = {
        let now = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: now)
        return Calendar.current.date(from: components)!
    }()
    
    var dateKey: String {
      return Date.keyDateFormatter.string(from: self)
    }
}
