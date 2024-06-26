//
//  Repeats.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/30.
//

import SwiftUI

enum DayOfWeek: String, CaseIterable {
  case sunday
  case monday
  case tuesday
  case wednesday
  case thursday
  case friday
  case saturday
  
  var displayText: Text {
      switch self {
          case .sunday: return Text(Calendar.current.shortWeekdaySymbols[0])
          case .monday: return Text(Calendar.current.shortWeekdaySymbols[1])
          case .tuesday: return Text(Calendar.current.shortWeekdaySymbols[2])
          case .wednesday: return Text(Calendar.current.shortWeekdaySymbols[3])
          case .thursday: return Text(Calendar.current.shortWeekdaySymbols[4])
          case .friday: return Text(Calendar.current.shortWeekdaySymbols[5])
          case .saturday: return Text(Calendar.current.shortWeekdaySymbols[6])
      }
  }
  
  var index: Int {
      switch self {
          case .sunday: return 101
          case .monday: return 102
          case .tuesday: return 103
          case .wednesday: return 104
          case .thursday: return 105
          case .friday: return 106
          case .saturday: return 107
      }
  }
  
    static var allCases: [DayOfWeek] {
        return [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
    }

}

extension Int {
    func getRepeatType() -> DayOfWeek {
        switch self {
        case DayOfWeek.sunday.index:
            return DayOfWeek.sunday
        case DayOfWeek.monday.index:
            return DayOfWeek.monday
        case DayOfWeek.tuesday.index:
            return DayOfWeek.tuesday
        case DayOfWeek.wednesday.index:
            return DayOfWeek.wednesday
        case DayOfWeek.thursday.index:
            return DayOfWeek.thursday
        case DayOfWeek.friday.index:
            return DayOfWeek.friday
        case DayOfWeek.saturday.index:
            return DayOfWeek.saturday
        default:
            return DayOfWeek.sunday
        }
    }
}
