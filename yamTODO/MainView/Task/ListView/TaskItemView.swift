//
//  TaskItemView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/17.
//

import SwiftUI

struct TaskItemView: View {
    @ObservedObject var userColor: UserColorObject
  @ObservedObject var taskList: TaskList

  let task: TaskObject
  @Binding var isShowDetailPopup: Bool
  @Binding var selectedTask: SelectedTask

  var body: some View {
    return HStack {
        if task.isDelay != 0 {
            ZStack {
                Circle()
                    .foregroundColor(userColor.userColorData.selectedColor.darkColor.toColor())
                    .frame(width: 20, height: 20)
                Text("+\(task.isDelay)")
                    .foregroundColor(.realWhite)
                    .font(.system(size: 10))
                    .fontWeight(.bold)
            }
        }else {
            if task.rootId != "" {
                HStack (spacing: 0) {
                    // list 의 언더라인이 끊기는 문제를 해결하기위해
                    Text("")
                        .frame(maxWidth: 0)
                    Image(systemName: "repeat.circle.fill")
                        .resizable()
                        .foregroundColor(userColor.userColorData.selectedColor.mainColor.toColor())
                        .frame(width: 20, height: 20)
                }
            }
        }
        Text(self.task.title)
            .strikethrough(self.task.isDone)
            .foregroundColor(self.task.isDone ? userColor.userColorData.selectedColor.mainColor.toColor() : .yamBlack)
//            .fontWeight(self.task.isDone ? .medium : .bold)
        Spacer()
        if task.isDone {
          Image(systemName: "checkmark").foregroundColor(userColor.userColorData.selectedColor.mainColor.toColor())
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
      self.taskList.updateIsDone(self.task.id)
  }
  
    private func toggleDetail() {
        guard !self.isShowDetailPopup else { return }
        guard let task = self.taskList.tasksObject.first(where: {$0.id == self.task.id }) else { return }
        self.selectedTask = SelectedTask(selectedTask: task)
        self.isShowDetailPopup.toggle()
    }
}
