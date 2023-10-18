//
//  TaskMainView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/18.
//

import SwiftUI

struct TaskMainView: View {
  @State var isEditing: Bool = false
  
  var body: some View {
    NavigationView {
      TaskListView(isEditing: $isEditing).environmentObject(UserData())
//      Spacer()
      .navigationBarTitle(Text("TODO 👀"))
      .navigationBarItems(trailing: Button(action: { self.isEditing.toggle() }) {
        if !self.isEditing {
//        Text("Edit")
          Image("edit")
            .resizable()
            .frame(width: 40, height: 40)
        } else {
          Text("Done").bold()
        }
      })
      .navigationBarTitleDisplayMode(.inline)
      
      .toolbar {
        ToolbarItemGroup(placement: .navigationBarLeading) {
          NavigationLink {
            CalenderView(month: .now)
          } label: {
            Image("calender")
              .resizable()
              .frame(width: 30, height: 30)
          }
        }
      }
      
//      TaskListView(isEditing: $isEditing).environmentObject(UserData())
    }
  }
}
