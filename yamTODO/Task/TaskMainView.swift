//
//  TaskMainView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/18.
//

import SwiftUI

class TaskData: ObservableObject {
    @Published var selectedTask: TaskObject?
}

struct TaskMainView: View {
  @StateObject var taskData = TaskData()
  
  @State var isShowEditPopup: Bool = false
  @State var isShowDetailPopup: Bool = false
  var userData = userDataObject()
  
  var body: some View {
    NavigationView {
      ZStack {
        TaskListView(isShowEditPopup: $isShowEditPopup, isShowDetailPopup: $isShowDetailPopup).environmentObject(userData.userData)
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
          EditPopupView(isPresented: $isShowEditPopup).environmentObject(userData.userData)
        }
        if isShowDetailPopup {
          DetailPopupView(isPresented: $isShowDetailPopup)
            .environmentObject(userData.userData)
            .environmentObject(taskData)
          
        }
      }
    }
  }
}
