//
//  Repeats.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/30.
//

enum DayOfWeek: String, CaseIterable {
  case sunday
  case monday
  case tuesday
  case wednesday
  case thursday
  case friday
  case saturday
  
  var displayName: String {
      switch self {
          case .sunday: return "일"
          case .monday: return "월"
          case .tuesday: return "화"
          case .wednesday: return "수"
          case .thursday: return "목"
          case .friday: return "금"
          case .saturday: return "토"
      }
  }
  
  var index: Int {
      switch self {
          case .sunday: return 100
          case .monday: return 101
          case .tuesday: return 102
          case .wednesday: return 103
          case .thursday: return 104
          case .friday: return 105
          case .saturday: return 106
      }
  }
  
  static var allCases: [DayOfWeek] {
          return [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
      }

}
