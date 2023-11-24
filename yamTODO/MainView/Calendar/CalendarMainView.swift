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
    //Binding
    @ObservedObject var userColor: UserColorObject
    @Binding var selectedTab: Tabs
    
    @ObservedObject var monthDataList = TasksByMonthListModel(date: Date())
    @StateObject var taskList = TaskList(date: Date())
    @State var tmrTaskList = TaskList(date:Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date())
    @StateObject var selectedCalendar = SelectedCalendar()
    @State var isShowEditPopup: Bool = false
    @State var isShowDetailPopup: Bool = false
    @State var selectedTask: SelectedTask = SelectedTask(selectedTask: nil)

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    CalendarView(userColor: userColor, monthDataList: monthDataList, taskList: taskList, selectedMonth: $selectedCalendar.selectedMonth, selectedDate: $selectedCalendar.selectedDate)
                        .navigationBarTitleDisplayMode(.inline)
                    VStack {
                        TaskListView(userColor: userColor, selectedCalendar: selectedCalendar, taskList: taskList, tmrTaskList: $tmrTaskList, isShowEditPopup: $isShowEditPopup, isShowTmrEditPopup: $isShowEditPopup, isShowDetailPopup: $isShowDetailPopup, selectedTask: $selectedTask)
                        .environmentObject(taskList)
                    }
                }
                .padding(.top, 30)
                
                if isShowEditPopup {
                    EditPopupView(userColor: userColor, selectedDate: selectedCalendar.selectedDate, isPresented: $isShowEditPopup)
                        .environmentObject(taskList)
                }

                if isShowDetailPopup {
                    DetailPopupView(userColor: userColor, selectedTask: $selectedTask, isPresented: $isShowDetailPopup)
                        .environmentObject(taskList)
                }
            }
        }
        
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            // selectedDate가 변경될 때마다 taskList를 업데이트
            taskList.date = selectedCalendar.selectedDate
            print(taskList.tasksObject)
        }
        .onChange(of: selectedTab) { newSelectedTab in
            // selectedTab이 변경될 때마다 호출됩니다.
            // isShowEditPopup을 false로 설정합니다.
            if newSelectedTab != .home {
                isShowEditPopup = false
                isShowDetailPopup = false
            }
        }
    }
}

