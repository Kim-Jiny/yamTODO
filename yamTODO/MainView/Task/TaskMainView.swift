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
    @State var tmrTaskList = TaskList(date:Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date())
    @StateObject var selectedCalendar = SelectedCalendar()
    @State var isShowEditPopup: Bool = false
    @State var isShowDetailPopup: Bool = false
    @State var selectedTask: SelectedTask = SelectedTask(selectedTask: nil)
    
    
    @State private var viewAppearedCount = 0
  var body: some View {
    NavigationView {
      ZStack {
          TaskListView(selectedCalendar: selectedCalendar, tmrTaskList: $tmrTaskList, isShowEditPopup: $isShowEditPopup, isShowDetailPopup: $isShowDetailPopup, selectedTask: $selectedTask, isMain: true)
              .environmentObject(taskList)
          .navigationBarTitle(Text("TODO 👀"))
          .navigationBarTitleDisplayMode(.inline)
          // 네비게이션뷰에 태스크 생성 페이지 버튼 삭제
//          .navigationBarItems(trailing: Button(action: { self.isShowEditPopup = true }) {
//            Image("edit")
//              .resizable()
//              .frame(width: 40, height: 40)
//          })
          
        if isShowEditPopup {
            EditPopupView(selectedDate: selectedCalendar.selectedDate, isPresented: $isShowEditPopup).environmentObject(taskList)
        }
        if isShowDetailPopup {
            if selectedTask.selectedTask != nil {
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
