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
        formatter.dateFormat = "yyyy.MM"
        return formatter
    }()

    static let keyDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }()
    static let keyMonthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMM"
        return formatter
    }()
    
    static let calendarDayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy dd"
        return formatter
    }()
    
    static let calendarHeaderDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd (EE)"
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
    
    var monthKey: String {
      return Date.keyMonthFormatter.string(from: self)
    }
    
    /// 오늘 날짜의 처음 시작 시간
    func getStartTime() -> Date {
      // 현재 날짜의 연, 월, 일 구성 요소를 가져옵니다.
      let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
      // 디바이스의 시간대 설정
      let deviceTimeZone = TimeZone.autoupdatingCurrent
      // 해당 연, 월, 일로 시작 시간을 설정합니다.
      if var startDate = Calendar.current.date(from: components) {
          startDate = Calendar.current.startOfDay(for: startDate) // 이것이 오늘 날짜의 시작 시간입니다.
          return startDate.addingTimeInterval(TimeInterval(deviceTimeZone.secondsFromGMT(for: startDate)))
      }
      
      return self
    }
    
    
    func getStartTimeForTomorrow() -> Date {
        // 내일 날짜를 가져옵니다.
        if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: self) {
            // 내일 날짜의 연, 월, 일 구성 요소를 가져옵니다.
            let components = Calendar.current.dateComponents([.year, .month, .day], from: tomorrow)
            // 디바이스의 시간대 설정
            let deviceTimeZone = TimeZone.autoupdatingCurrent
            // 내일 날짜의 시작 시간을 설정합니다.
            if var startDate = Calendar.current.date(from: components) {
                startDate = Calendar.current.startOfDay(for: startDate) // 내일 날짜의 시작 시간입니다.
                return startDate.addingTimeInterval(TimeInterval(deviceTimeZone.secondsFromGMT(for: startDate)))
            }
        }
        return self
    }
}
