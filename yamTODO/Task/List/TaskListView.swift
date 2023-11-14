//
//  TaskListView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/17.
//

import SwiftUI

struct TaskListView: View {
  @EnvironmentObject var taskList: TaskList
  @State var draftTitle: String = ""
  @Binding var isShowEditPopup: Bool
  @Binding var isShowDetailPopup: Bool
  @Binding var selectedTask: SelectedTask?
  @State private var showCalender = false

  var body: some View {
    VStack {
      List {
        Section(header: Text(Date(), formatter: Self.calendarHeaderDateFormatter)) {
          VStack {
            Button {
              self.isShowEditPopup = true
            } label: {
              Image(systemName: "plus.app")
                .foregroundColor(.yamBlue)
            }
          }
          .frame(maxWidth: .infinity)
          ForEach(self.taskList.tasksObject) { task in
            TaskItemView(task: task, isShowEditPopup: self.$isShowEditPopup, isShowDetailPopup: self.$isShowDetailPopup, selectedTask: $selectedTask)
          }
        }
        .padding(.bottom, 0)
      }
    }
  }
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
