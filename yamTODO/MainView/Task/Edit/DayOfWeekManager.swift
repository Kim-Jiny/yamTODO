//
//  DayOfWeekManager.swift
//  yamTODO
//
//  Created by Jiny on 2023/11/01.
//

import SwiftUI

class DayOfWeekManager: ObservableObject {
  @Published var selectedDays: Set<DayOfWeek> = []

  func toggleDay(_ day: DayOfWeek) {
    if selectedDays.contains(day) {
        selectedDays.remove(day)
    } else {
        selectedDays.insert(day)
    }
  }
  var selectedDayIndices: [Int] {
    return selectedDays.map { $0.index }
  }
}
