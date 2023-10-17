//
//  TaskItemView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/17.
//

import SwiftUI

struct TaskItemView: View {
  @EnvironmentObject var userData: UserData

  let task: Task
  @Binding var isEditing: Bool

  var body: some View {
    return HStack {
      if self.isEditing {
        Image(systemName: "minus.circle")
          .foregroundColor(.red)
          .onTapGesture(count: 1) {
            self.delete()
          }
        NavigationLink(destination: TaskEditView(task: task).environmentObject(self.userData)) {
          Text(task.title)
        }
      } else {
        Button(action: {
          // TODO: 수정하거나 자세한내용 볼수있게 ( 내일로 미루기 버튼등 생성. )
//          self.toggleDone()
        }) {
          Text(self.task.title)
        }
        Spacer()
        if task.isDone {
          Image(systemName: "checkmark").foregroundColor(.green)
            .onTapGesture {
              self.toggleDone()
            }
        }else {
          Image(systemName: "checkmark").foregroundColor(.yamLightGreen)
            .onTapGesture {
              self.toggleDone()
            }
        }
      }
    }
  }

  private func toggleDone() {
    guard !self.isEditing else { return }
    guard let index = self.userData.tasks.firstIndex(where: { $0.id == self.task.id }) else { return }
    self.userData.tasks[index].isDone.toggle()
  }

  private func delete() {
    self.userData.tasks.removeAll(where: { $0.id == self.task.id })
    if self.userData.tasks.isEmpty {
      self.isEditing = false
    }
  }
}
