//
//  TaskMainView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/18.
//

import Combine
import SwiftUI
import GoogleMobileAds

struct TaskMainView: View {
    @ObservedObject var userColor: UserColorObject
    @Binding var selectedTab: Tabs
    
    @StateObject var taskList = TaskList(date: Date())
    @StateObject var tmrTaskList = TaskList(date:Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date())
    @StateObject var selectedCalendar = SelectedCalendar()
    @State var isShowEditPopup: Bool = false
    @State var isShowDetailPopup: Bool = false
    
    @State var isShowTmrEditPopup: Bool = false
    @State var selectedTask: SelectedTask = SelectedTask(selectedTask: nil)
    
    // Admob 광고 배너
    @ViewBuilder func admob() -> some View {
        AdmobBannerView(adType: .mainBN).frame(width: GADAdSizeBanner.size.width, height: GADAdSizeBanner.size.height)
    }
  var body: some View {
    NavigationView {
      ZStack {
          VStack {
              TaskListView(userColor: userColor, selectedCalendar: selectedCalendar, taskList: taskList, tmrTaskList: tmrTaskList, isShowEditPopup: $isShowEditPopup, isShowTmrEditPopup: $isShowTmrEditPopup, isShowDetailPopup: $isShowDetailPopup, selectedTask: $selectedTask, isShowTomorrow: true)
                .frame(maxWidth: .infinity)
              .navigationBarTitle(Text("TODO 👀"))
              .navigationBarTitleDisplayMode(.inline)
              Spacer()
              admob()
          }
        if isShowEditPopup {
            EditPopupView(userColor: userColor, selectedDate: selectedCalendar.selectedDate, isPresented: $isShowEditPopup).environmentObject(taskList)
        }
        if isShowTmrEditPopup {
            EditPopupView(userColor: userColor, selectedDate: tmrTaskList.date, isPresented: $isShowTmrEditPopup).environmentObject(tmrTaskList)
        }
        if isShowDetailPopup {
            if selectedTask.selectedTask != nil {
            DetailPopupView(userColor: userColor, selectedTask: $selectedTask, isPresented: $isShowDetailPopup)
//              .environmentObject(taskList)
            }
        }
      }
    }
    .navigationViewStyle(StackNavigationViewStyle())
    .onAppear {
        // 뷰가 나타날 때마다 호출됩니다.
        taskList.date = Date()
        tmrTaskList.date = tmrTaskList.date
    }
    .onChange(of: selectedTab) { newSelectedTab in
        // selectedTab이 변경될 때마다 호출됩니다.
        // isShowEditPopup을 false로 설정합니다.
        if newSelectedTab != .home {
            isShowEditPopup = false
            isShowTmrEditPopup = false
            isShowDetailPopup = false
        }
    }
  }
}
