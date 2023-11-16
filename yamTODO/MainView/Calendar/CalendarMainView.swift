//
//  CalenderMainView.swift
//  yamTODO
//
//  Created by Jiny on 11/16/23.
//

import Foundation
import Combine
import SwiftUI

class SelectedCalendar: ObservableObject {
    @Published var selectedDate: Date = Date()
    @Published var selectedMonth: Date = Date()
}

struct CalendarMainView: View {
    @StateObject var taskList = TaskList(key: Date().dateKey)
    @StateObject var selectedCalendar = SelectedCalendar()
    @State var isShowEditPopup: Bool = false
    @State var isShowDetailPopup: Bool = false
    @State var selectedTask: SelectedTask?

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    CalendarView(selectedMonth: $selectedCalendar.selectedMonth, selectedDate: $selectedCalendar.selectedDate)
                        .navigationBarTitle(Text("Calendar 📆"))
                        .navigationBarTitleDisplayMode(.inline)
                    
                    TaskListView(selectedCalendar: selectedCalendar, isShowEditPopup: $isShowEditPopup, isShowDetailPopup: $isShowDetailPopup, selectedTask: $selectedTask)
                        .environmentObject(taskList)
                }
                
                if isShowEditPopup {
                    // EditPopupView(isPresented: $isShowEditPopup).environmentObject(taskList)
                    EditPopupView(isPresented: $isShowEditPopup)
                        .environmentObject(taskList)
                }

                if isShowDetailPopup {
                    if let selectedTask = selectedTask {
                        DetailPopupView(selectedTask: $selectedTask, isPresented: $isShowDetailPopup)
                            .environmentObject(taskList)
                    }
                }
            }
        }
        .onAppear {
            // selectedDate가 변경될 때마다 taskList를 업데이트
            taskList.date = selectedCalendar.selectedDate.dateKey
        }
    }
}

