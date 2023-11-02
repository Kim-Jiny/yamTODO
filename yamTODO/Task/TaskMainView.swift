//
//  TaskMainView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/18.
//

import SwiftUI

struct TaskMainView: View {
  @State var isShowEditPopup: Bool = false
  var userData = userDataObject()
  
  var body: some View {
    NavigationView {
//      Text("TODO 👀")
//        .navigationTitle("Title")
//        .foregroundColor(.yamBlue)
      ZStack {
        TaskListView(isShowEditPopup: $isShowEditPopup).environmentObject(userData.userData)
          .navigationBarTitle(Text("TODO 👀"))
          .navigationBarItems(trailing: Button(action: { self.isShowEditPopup = true }) {
            Image("edit")
              .resizable()
              .frame(width: 40, height: 40)
          })
//          .sheet(isPresented: $isShowEditPopup, content: {
//            EditPopupView(isPresented: $isShowEditPopup)
//          })
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
      }
    }
  }
}
