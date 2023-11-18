//
//  TaskListView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/17.
//

import SwiftUI

struct TaskListView: View {
    @ObservedObject var selectedCalendar: SelectedCalendar
    @EnvironmentObject var taskList: TaskList
    @State var draftTitle: String = ""
    @Binding var isShowEditPopup: Bool
    @Binding var isShowDetailPopup: Bool
    @Binding var selectedTask: SelectedTask
//    @State private var showCalender = false

    var body: some View {
        VStack {
            List {
                Section(header: Text(selectedCalendar.selectedDate, formatter: Self.calendarHeaderDateFormatter)) {
                    VStack {
                        Button {
                            self.isShowEditPopup = true
                        } label: {
                            Image(systemName: "plus.app")
                                .foregroundColor(.yamBlue)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    ForEach(self.taskList.tasksObject.filter({ !$0.isDone })) { task in
                        // 지워지거나 수정되지 않은 옵션만 표시
                        if !task.isRemove {
                            TaskItemView(task: task, isShowEditPopup: self.$isShowEditPopup, isShowDetailPopup: self.$isShowDetailPopup, selectedTask: $selectedTask)
                        }
                    }
                    ForEach(self.taskList.tasksObject.filter({ $0.isDone })) { task in
                        // 지워지거나 수정되지 않은 옵션만 표시
                        if !task.isRemove {
                            TaskItemView(task: task, isShowEditPopup: self.$isShowEditPopup, isShowDetailPopup: self.$isShowDetailPopup, selectedTask: $selectedTask)
                        }
                    }
                }
                .padding(.bottom, 0)
            }
            .onReceive(taskList.objectWillChange) { _ in
                // taskList 변경 시 업데이트
//                print("@update \(taskList.tasksObject)")
//                self.showCalender.toggle()
            }
            
            .onReceive(selectedCalendar.$selectedDate) { _ in
                taskList.date = selectedCalendar.selectedDate
            }
            
            .onReceive(selectedTask.objectWillChange) { _ in
                print("selected Task \n\n\(selectedTask.selectedTask)\n\n")
                taskList.date = selectedCalendar.selectedDate
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
