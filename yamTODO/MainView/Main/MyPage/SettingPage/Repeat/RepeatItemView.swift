//
//  RepeatItemView.swift
//  yamTODO
//
//  Created by Jiny on 11/17/23.
//

import Foundation
import SwiftUI

struct RepeatItemView: View {
  @EnvironmentObject var taskList: OptionTaskList

  let task: TaskObject
  @Binding var isShowEditPopup: Bool
  @Binding var isShowDetailPopup: Bool
  @Binding var selectedTask: SelectedTask

  var body: some View {
    return HStack {
        //TODO 월화수목반복에대한 리스트 표시
        if task.rootId != "" {
            Image(systemName: "repeat.circle.fill").foregroundColor(.yamBlue)
        }
        Text(self.task.title)
            .onTapGesture {
              self.toggleDetail()
            }
        Spacer()
    }
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
