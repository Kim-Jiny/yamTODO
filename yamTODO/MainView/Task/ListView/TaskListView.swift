//
//  TaskListView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/17.
//

import SwiftUI

struct TaskListView: View {
    @ObservedObject var selectedCalendar: SelectedCalendar
    @ObservedObject var taskList: TaskList
    @Binding var tmrTaskList: TaskList
    @Binding var isShowEditPopup: Bool
    @Binding var isShowTmrEditPopup: Bool
    @Binding var isShowDetailPopup: Bool
    @State var isDeleteActionVisible: Bool = false
    @Binding var selectedTask: SelectedTask
    
    
    @State var isShowTomorrow: Bool = false
//    @State private var showCalender = false

    var body: some View {
        VStack {
            List {
                Section(header: Text(selectedCalendar.selectedDate, formatter: Date.calendarHeaderDateFormatter)) {
                    Button {
                        self.isShowEditPopup = true
                    } label: {
                        Image(systemName: "plus.app")
                            .foregroundColor(.yamBlue)
                    }
                    .frame(maxWidth: .infinity)
                    // 완료되지 않은 태스크 우선 표시
                    ForEach(self.taskList.tasksObject.filter({ !$0.isDone })) { task in
                        // 지워지거나 수정되지 않은 옵션만 표시
                        if !task.isRemove {
                            TaskItemView(taskList: taskList, task: task, isShowDetailPopup: self.$isShowDetailPopup, selectedTask: $selectedTask)
                                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                    Button {
                                        // 왼쪽으로 스와이프하여 삭제버튼을 볼 수 있다.
                                        selectedTask.selectedTask = task
                                        isDeleteActionVisible.toggle()
                                    } label: {
                                        Label("Delete", systemImage: "trash.circle")
                                    }
                                    .tint(.yamBlue)
                                }
                        }
                    }
                    // 이미 완료된 테스크 표시
                    ForEach(self.taskList.tasksObject.filter({ $0.isDone })) { task in
                        // 지워지거나 수정되지 않은 옵션만 표시
                        if !task.isRemove {
                            TaskItemView(taskList: taskList, task: task, isShowDetailPopup: self.$isShowDetailPopup, selectedTask: $selectedTask)
                                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                    Button {
                                        // 왼쪽으로 스와이프하여 삭제버튼을 볼 수 있다.
                                        selectedTask.selectedTask = task
                                        isDeleteActionVisible.toggle()
                                    } label: {
                                        Label("Delete", systemImage: "trash.circle")
                                    }
                                    .tint(.yamBlue)
                                }
                            
                        }
                    }
                }
                .padding(.bottom, 0)
               // 내일
                if self.isShowTomorrow {
                    
                    Section(header: Text(tmrTaskList.date, formatter: Date.calendarHeaderDateFormatter)) {
                            Button {
                                self.isShowTmrEditPopup = true
                            } label: {
                                Image(systemName: "plus.app")
                                    .foregroundColor(.yamBlue)
                            }
                        .frame(maxWidth: .infinity)
                        
                        ForEach(self.tmrTaskList.tasksObject.filter({ !$0.isDone })) { task in
                            // 지워지거나 수정되지 않은 옵션만 표시
                            if !task.isRemove {
                                TaskItemView(taskList: tmrTaskList, task: task, isShowDetailPopup: self.$isShowDetailPopup, selectedTask: $selectedTask)
                                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                        Button {
                                            // 왼쪽으로 스와이프하여 삭제버튼을 볼 수 있다.
                                            selectedTask.selectedTask = task
                                            isDeleteActionVisible.toggle()
                                        } label: {
                                            Label("Delete", systemImage: "trash.circle")
                                        }
                                        .tint(.yamBlue)
                                    }
                            }
                        }
                        ForEach(self.tmrTaskList.tasksObject.filter({ $0.isDone })) { task in
                            // 지워지거나 수정되지 않은 옵션만 표시
                            if !task.isRemove {
                                TaskItemView(taskList: tmrTaskList, task: task, isShowDetailPopup: self.$isShowDetailPopup, selectedTask: $selectedTask)
                                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                        Button {
                                            // 왼쪽으로 스와이프하여 삭제버튼을 볼 수 있다.
                                            selectedTask.selectedTask = task
                                            isDeleteActionVisible.toggle()
                                        } label: {
                                            Label("Delete", systemImage: "trash.circle")
                                        }
                                        .tint(.yamBlue)
                                    }
                            }
                        }
                    }
                    .padding(.bottom, 0)
                    .alert(isPresented: $isDeleteActionVisible) {
                        Alert(title: Text(""), message: Text("Are you sure you want to delete?"), primaryButton: .destructive(Text("Delete")) {
                            // "Delete" 버튼을 눌렀을 때의 동작
                            self.selectedTask.deleteSelectTask()
                        }, secondaryButton: .cancel())
                    }
                }
            }
            .listStyle(SidebarListStyle())
            
            .onReceive(selectedCalendar.$selectedDate) { _ in
                // 해당 날짜를 선택했을때 리스트를 초기화시켜줌.
                taskList.date = selectedCalendar.selectedDate
            }
            
            .onReceive(selectedTask.objectWillChange) { _ in
                // 해당 태스크에대한 변경이 일어날때 리스트를 초기화 시켜줌
                taskList.date = selectedCalendar.selectedDate
                tmrTaskList.date = tmrTaskList.date
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
    
    static let weekdaySymbols: [String] = Calendar.current.shortWeekdaySymbols
  
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
    
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
}
