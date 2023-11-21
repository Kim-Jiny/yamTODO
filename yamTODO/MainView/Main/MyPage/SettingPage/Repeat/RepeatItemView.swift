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
  @Binding var isShowDetailPopup: Bool
  @Binding var selectedTask: SelectedTask

  var body: some View {
    return VStack {
        HStack {
            ForEach(task.optionType.sorted(), id: \.self) { repeatType in
                ZStack {
                    Circle()
                        .foregroundColor(Color.yamRealDarkPoint)
                        .frame(width: 30, height: 30)
                    repeatType.getRepeatType().displayText
                        .foregroundColor(.realWhite)
                }
            }
            Spacer()
        }
        HStack {
            Text(self.task.title)
            Spacer()
        }
        .onTapGesture {
          self.toggleDetail()
        }
    }
  }
  
  private func toggleDetail() {
    guard !self.isShowDetailPopup else { return }
    guard let task = self.taskList.tasksObject.first(where: {$0.id == self.task.id }) else { return }
    self.selectedTask = SelectedTask(selectedTask: task)
    self.isShowDetailPopup = true
  }

  private func delete() {
    self.taskList.tasksObject.removeAll(where: { $0.id == self.task.id })
    if self.taskList.tasksObject.isEmpty {
      self.isShowDetailPopup = false
    }
  }
}
