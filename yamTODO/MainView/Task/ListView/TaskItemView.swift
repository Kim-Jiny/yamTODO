//
//  TaskItemView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/17.
//

import SwiftUI

struct TaskItemView: View {
  @EnvironmentObject var taskList: TaskList

  let task: TaskObject
  @Binding var isShowEditPopup: Bool
  @Binding var isShowDetailPopup: Bool
  @Binding var selectedTask: SelectedTask

  var body: some View {
    return HStack {
//        if task.rootId != "" {
//            Image(systemName: "repeat.circle.fill").foregroundColor(.yamBlue)
//        }
        if task.isDelay != 0 {
            ZStack {
                Circle()
                    .foregroundColor(Color.yamDarkBlue)
                    .frame(width: 20, height: 20)
                Text("+\(task.isDelay)")
                    .foregroundColor(.yamWhite)
                    .font(.system(size: 10))
                    .fontWeight(.bold)
            }
        }else {
            if task.rootId != "" {
                Image(systemName: "repeat.circle.fill").foregroundColor(.yamBlue)
            }
        }
        Text(self.task.title)
            .strikethrough(self.task.isDone)
            .foregroundColor(self.task.isDone ? .yamBlue : .yamBlack)
//            .fontWeight(self.task.isDone ? .medium : .bold)
        Spacer()
        if task.isDone {
          Image(systemName: "checkmark").foregroundColor(.yamBlue)
            .onTapGesture {
              self.toggleDone()
            }
        }else {
          Image(systemName: "checkmark").foregroundColor(.yamLightGray)
            .onTapGesture {
              self.toggleDone()
            }
        }
    }
    .onTapGesture {
      self.toggleDetail()
    }
//    .background(self.task.isDone ? Color.lightGray : .white)
  }

  private func toggleDone() {
      guard !self.isShowEditPopup else { return }
      self.taskList.updateIsDone(self.task.id)
  }
  
    private func toggleDetail() {
        guard !self.isShowDetailPopup else { return }
        guard let task = self.taskList.tasksObject.first(where: {$0.id == self.task.id }) else { return }
        self.selectedTask = SelectedTask(selectedTask: task)
        self.isShowDetailPopup.toggle()
    }

  private func delete() {
    self.taskList.tasksObject.removeAll(where: { $0.id == self.task.id })
    if self.taskList.tasksObject.isEmpty {
      self.isShowEditPopup = false
    }
  }
}
