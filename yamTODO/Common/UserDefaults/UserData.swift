//
//  UserData.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/17.
//

import Combine
import SwiftUI

private let defaultTasks: [Task] = [
  Task(title: "Read SwiftUI Documentation 📚"),
  Task(title: "Watch WWDC19 Keynote 🎉")
]

final class UserData: ObservableObject {
  let objectWillChange = PassthroughSubject<UserData, Never>()

  @UserDefaultValue(key: "Tasks", defaultValue: defaultTasks)
  var tasks: [Task] {
    didSet {
      objectWillChange.send(self)
    }
  }
}

