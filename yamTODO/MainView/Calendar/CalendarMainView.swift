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
    @StateObject var monthDataList = TasksByMonthListModel(date: Date())
    @StateObject var taskList = TaskList(date: Date())
    @StateObject var selectedCalendar = SelectedCalendar()
    @State var isShowEditPopup: Bool = false
    @State var isShowDetailPopup: Bool = false
    @State var selectedTask: SelectedTask = SelectedTask(selectedTask: nil)

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    CalendarView(monthDataList: monthDataList, selectedMonth: $selectedCalendar.selectedMonth, selectedDate: $selectedCalendar.selectedDate)
//                        .environmentObject(monthDataList)
//                        .navigationBarTitle(Text("Calendar 📆"))
                        .navigationBarTitleDisplayMode(.inline)
                        
                    
                    TaskListView(selectedCalendar: selectedCalendar, isShowEditPopup: $isShowEditPopup, isShowDetailPopup: $isShowDetailPopup, selectedTask: $selectedTask)
                        .environmentObject(taskList)
                }
                .padding(.top, 30)
                
                if isShowEditPopup {
                    // EditPopupView(isPresented: $isShowEditPopup).environmentObject(taskList)
                    EditPopupView(selectedDate: selectedCalendar.selectedDate, isPresented: $isShowEditPopup)
                        .environmentObject(taskList)
                }

                if isShowDetailPopup {
                    DetailPopupView(selectedTask: $selectedTask, isPresented: $isShowDetailPopup)
                        .environmentObject(taskList)
                }
            }
        }
        .onAppear {
            // selectedDate가 변경될 때마다 taskList를 업데이트
            taskList.date = selectedCalendar.selectedDate
//            monthDataList.date = selectedCalendar.selectedMonth
            print(selectedCalendar.selectedMonth.monthKey)
        }
    }
}

