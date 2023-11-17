//
//  TaskMainView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/18.
//

import Combine
import SwiftUI

struct TaskMainView: View {
    @StateObject var taskList = TaskList(date: Date())
    @StateObject var selectedCalendar = SelectedCalendar()
    @State var isShowEditPopup: Bool = false
    @State var isShowDetailPopup: Bool = false
    @State var selectedTask: SelectedTask?
    
    
    @State private var viewAppearedCount = 0
  var body: some View {
    NavigationView {
      ZStack {
          TaskListView(selectedCalendar: selectedCalendar, isShowEditPopup: $isShowEditPopup, isShowDetailPopup: $isShowDetailPopup, selectedTask: $selectedTask)
          .environmentObject(taskList)
          .navigationBarTitle(Text("TODO 👀"))
          .navigationBarItems(trailing: Button(action: { self.isShowEditPopup = true }) {
            Image("edit")
              .resizable()
              .frame(width: 40, height: 40)
          })
          .navigationBarTitleDisplayMode(.inline)
          //navigation 에서 캘린더 가는 기능 삭제
//          .toolbar {
//            ToolbarItemGroup(placement: .navigationBarLeading) {
//              NavigationLink {
//                CalendarView(month: .now)
//              } label: {
//                Image("calender")
//                  .resizable()
//                  .frame(width: 30, height: 30)
//              }
//            }
//          }
        if isShowEditPopup {
          EditPopupView(isPresented: $isShowEditPopup).environmentObject(taskList)
        }
        if isShowDetailPopup {
            if selectedTask != nil {
            DetailPopupView(selectedTask: $selectedTask, isPresented: $isShowDetailPopup)
              .environmentObject(taskList)
          }
        }
      }
    }
    .onAppear {
        // 뷰가 나타날 때마다 호출됩니다.
        viewAppearedCount += 1
        print("View appeared \(viewAppearedCount) times")
        taskList.date = Date()
    }
  }
}
