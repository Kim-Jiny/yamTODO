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
          case .sunday: return 0
          case .monday: return 1
          case .tuesday: return 2
          case .wednesday: return 3
          case .thursday: return 4
          case .friday: return 5
          case .saturday: return 6
      }
  }
  
  static var allCases: [DayOfWeek] {
          return [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
      }

}
