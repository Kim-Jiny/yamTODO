//
//  TaskListView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/17.
//

import SwiftUI

struct TaskListView: View {
  @EnvironmentObject var userData: UserData
  @State var draftTitle: String = ""
  @State var isEditing: Bool = false
  @State private var showCalender = false

  var body: some View {
    
    NavigationView {
    List {
      TextField("Create a New Task...", text: $draftTitle, onCommit: self.createTask)
      ForEach(self.userData.tasks) { task in
        TaskItemView(task: task, isEditing: self.$isEditing)
      }
    }
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
    }
  }

  private func createTask() {
    let newTask = Task(id: UUID().uuidString, title: self.draftTitle, isDone: false)
    self.userData.tasks.insert(newTask, at: 0)
    self.draftTitle = ""
  }
}
