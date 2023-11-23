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
    @StateObject var taskList = TaskList(date: Date())
    @State var tmrTaskList = TaskList(date:Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date())
    @StateObject var selectedCalendar = SelectedCalendar()
    @State var isShowEditPopup: Bool = false
    @State var isShowDetailPopup: Bool = false
    
    @State var isShowTmrEditPopup: Bool = false
    @State var selectedTask: SelectedTask = SelectedTask(selectedTask: nil)
    
    @State private var viewAppearedCount = 0
    // Admob 광고 배너
    @ViewBuilder func admob() -> some View {
        AdmobBannerView().frame(width: GADAdSizeBanner.size.width, height: GADAdSizeBanner.size.height)
    }
  var body: some View {
    NavigationView {
      ZStack {
          VStack {
              TaskListView(selectedCalendar: selectedCalendar, taskList: taskList, tmrTaskList: $tmrTaskList, isShowEditPopup: $isShowEditPopup, isShowTmrEditPopup: $isShowTmrEditPopup, isShowDetailPopup: $isShowDetailPopup, selectedTask: $selectedTask, isShowTomorrow: true)
                .frame(maxWidth: .infinity)
              .navigationBarTitle(Text("TODO 👀"))
              .navigationBarTitleDisplayMode(.inline)
              Spacer()
              admob()
          }
          // 네비게이션뷰에 태스크 생성 페이지 버튼 삭제
//          .navigationBarItems(trailing: Button(action: { self.isShowEditPopup = true }) {
//            Image("edit")
//              .resizable()
//              .frame(width: 40, height: 40)
//          })
          
        if isShowEditPopup {
            EditPopupView(selectedDate: selectedCalendar.selectedDate, isPresented: $isShowEditPopup).environmentObject(taskList)
        }
        if isShowTmrEditPopup {
            EditPopupView(selectedDate: tmrTaskList.date, isPresented: $isShowTmrEditPopup).environmentObject(tmrTaskList)
        }
        if isShowDetailPopup {
            if selectedTask.selectedTask != nil {
            DetailPopupView(selectedTask: $selectedTask, isPresented: $isShowDetailPopup)
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
  }
}
