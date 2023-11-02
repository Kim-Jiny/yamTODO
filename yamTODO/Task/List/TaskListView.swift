//
//  TaskListView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/17.
//

import SwiftUI

struct TaskListView: View {
  @EnvironmentObject var userData: UserData
  @State var draftTitle: String = ""
  @Binding var isShowEditPopup: Bool
  @State private var showCalender = false

  var body: some View {
    VStack {
      List {
        Section(header: Text(Date(), formatter: Self.calendarHeaderDateFormatter)) {
//          TextField("Create a New Task...", text: $draftTitle, onCommit: self.createTask)
          ForEach(self.userData.tasks) { task in
            TaskItemView(task: task, isShowEditPopup: self.$isShowEditPopup)
          }
        }
        .padding(.bottom, 0)
      }
    }
  }

//  private func createTask() {
//    let newTask = Task(title: self.draftTitle)
//    self.userData.tasks.insert(newTask, at: 0)
//    self.draftTitle = ""
//  }
}

private extension TaskListView {
  var today: Date {
    let now = Date()
    let components = Calendar.current.dateComponents([.year, .month, .day], from: now)
    return Calendar.current.date(from: components)!
  }
  
  static let calendarHeaderDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM월 dd일"
    return formatter
  }()
  
  static let weekdaySymbols: [String] = Calendar.current.shortWeekdaySymbols
  
  func firstWeekdayOfMonth(in date: Date) -> Int {
    let components = Calendar.current.dateComponents([.year, .month], from: date)
    let firstDayOfMonth = Calendar.current.date(from: components)!
    
    return Calendar.current.component(.weekday, from: firstDayOfMonth)
  }
}
