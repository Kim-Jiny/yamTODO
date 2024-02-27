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
    @Published var selectedDate: Date = Date().getStartTime()
    @Published var selectedMonth: Date = Date().getStartTime()
}

struct CalendarMainView: View {
    // 가로모드인지 확인하는 코드
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    // scene의 생명주기를 확인하는 코드
    @Environment(\.scenePhase) private var scenePhase
    // 커스컴 컬러를 위한 구독
    @ObservedObject var userColor: UserColorObject
    // 탭을 변경했을때 열린 페이지를 닫아주기 위함
    @Binding var selectedTab: Tabs
    
    @StateObject var today = TaskList(date: Date().getStartTime())
    
    @ObservedObject var monthDataList = TasksByMonthListModel(date: Date().getStartTime())
    @StateObject var taskList = TaskList(date: Date().getStartTime())
    @StateObject var tmrTaskList = TaskList(date: Date().getStartTimeForTomorrow())
    @StateObject var selectedCalendar = SelectedCalendar()
    @State var isShowEditPopup: Bool = false
    @State var isShowDetailPopup: Bool = false
    @State var selectedTask: SelectedTask = SelectedTask(selectedTask: nil)

    var body: some View {
        NavigationView {
            if horizontalSizeClass == .compact && verticalSizeClass == .regular {
                // 세로모드 UI
                portraitCalendarView
            }else {
                // 가로모드 UI
                landscapeCalendarView
            }
        }
        // IPad에서 네비게이션이 사이드바로 출력되는 문제 수정
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            // selectedDate가 변경될 때마다 taskList를 업데이트
            taskList.date = selectedCalendar.selectedDate
        }
        .onChange(of: selectedTab) { newSelectedTab in
            // selectedTab이 변경될 때마다 호출됩니다.
            // isShowEditPopup을 false로 설정합니다.
            if newSelectedTab != .home {
                isShowEditPopup = false
                isShowDetailPopup = false
            }
        }
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .active:
                // 앱이 활성화될 때 수행할 작업
                print("앱이 활성화되었습니다.")
                if Date().getStartTime() != today.date {
                    // 앱이 활성화 되었는데 오늘 날짜가 달라졌으면 캘린더를 새로 부르자
                    
                }
            case .inactive:
                // 앱이 비활성화될 때 수행할 작업
                print("앱이 비활성화되었습니다.")
            case .background:
                // 앱이 백그라운드로 이동될 때 수행할 작업
                print("앱이 백그라운드로 이동되었습니다.")
            @unknown default:
                break
            }
        }
    }
    
    @ViewBuilder
    var portraitCalendarView: some View {
        ZStack {
            VStack {
                CalendarView(userColor: userColor, monthDataList: monthDataList, taskList: taskList, selectedMonth: $selectedCalendar.selectedMonth, selectedDate: $selectedCalendar.selectedDate)
                    .navigationBarTitleDisplayMode(.inline)
                VStack {
                    TaskListView(userColor: userColor, selectedCalendar: selectedCalendar, taskList: taskList, tmrTaskList: tmrTaskList, isShowEditPopup: $isShowEditPopup, isShowTmrEditPopup: $isShowEditPopup, isShowDetailPopup: $isShowDetailPopup, selectedTask: $selectedTask)
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
    
    @ViewBuilder
    var landscapeCalendarView: some View {
        ZStack {
            HStack {
                ScrollView {
                    CalendarView(userColor: userColor, monthDataList: monthDataList, taskList: taskList, selectedMonth: $selectedCalendar.selectedMonth, selectedDate: $selectedCalendar.selectedDate)
                }
                VStack {
                    TaskListView(userColor: userColor, selectedCalendar: selectedCalendar, taskList: taskList, tmrTaskList: tmrTaskList, isShowEditPopup: $isShowEditPopup, isShowTmrEditPopup: $isShowEditPopup, isShowDetailPopup: $isShowDetailPopup, selectedTask: $selectedTask)
                    .environmentObject(taskList)
                }
            }
            .padding(.top, 30)
            .navigationBarTitleDisplayMode(.inline)
            
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

}
