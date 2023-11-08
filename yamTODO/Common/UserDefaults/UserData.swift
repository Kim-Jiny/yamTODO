//
//  UserData.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/17.
//

import Combine
import SwiftUI

private let defaultTasks: [Task] = [
//  Task(title: "나만의 Calendar 채워넣기 📎"),
//  Task(title: "새로운 Task 만들기 📌")
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

final class userDataObject: ObservableObject {
    @Published var userData = UserData()
}
