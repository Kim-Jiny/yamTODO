//
//  TaskMainView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/18.
//

import Combine
import SwiftUI


struct TaskMainView: View {
    @StateObject var taskList = TaskList(key: Date().dateKey)
    @State var isShowEditPopup: Bool = false
    @State var isShowDetailPopup: Bool = false
    @State var selectedTask: SelectedTask?
  var body: some View {
    NavigationView {
      ZStack {
        TaskListView(isShowEditPopup: $isShowEditPopup, isShowDetailPopup: $isShowDetailPopup, selectedTask: $selectedTask)
          .environmentObject(taskList)
          .navigationBarTitle(Text("TODO 👀"))
          .navigationBarItems(trailing: Button(action: { self.isShowEditPopup = true }) {
            Image("edit")
              .resizable()
              .frame(width: 40, height: 40)
          })
          .navigationBarTitleDisplayMode(.inline)
          .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
              NavigationLink {
                CalendarView(month: .now)
              } label: {
                Image("calender")
                  .resizable()
                  .frame(width: 30, height: 30)
              }
            }
          }
        if isShowEditPopup {
          EditPopupView(isPresented: $isShowEditPopup).environmentObject(taskList)
        }
        if isShowDetailPopup {
          if let selectedTask = selectedTask {
            DetailPopupView(selectedTask: $selectedTask, isPresented: $isShowDetailPopup)
              .environmentObject(taskList)
          }
        }
      }
    }
  }
}
