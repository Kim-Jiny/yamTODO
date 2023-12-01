//
//  TaskItemView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/17.
//

import SwiftUI

struct TaskItemView: View {
    @ObservedObject var userColor: UserColorObject
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var taskList: TaskList
    let task: TaskObject
    @Binding var isShowDetailPopup: Bool
    @Binding var selectedTask: SelectedTask

  var body: some View {
    return HStack {
        if task.isDelay != 0 {
            ZStack {
                Circle()
                    .foregroundColor(getMarkerColor(self.task.isDone, self.task.isFixed))
                    .frame(width: 20, height: 20)
                Text("+\(task.isDelay)")
                    .foregroundColor(.realBlack)
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
                        .foregroundColor(getMarkerColor(self.task.isDone, self.task.isFixed))
                        .frame(width: 20, height: 20)
                }
            }
        }
        if task.isFixed {
            Text(self.task.title)
                .strikethrough(self.task.isDone)
                .foregroundColor(getTextColor(self.task.isDone, self.task.isFixed))
                .bold()
        }else{
            Text(self.task.title)
                .strikethrough(self.task.isDone)
                .foregroundColor(getTextColor(self.task.isDone, self.task.isFixed))
        }
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
  }
}

extension TaskItemView {
    
    private func getMarkerColor(_ isDone: Bool, _ isFixed: Bool) -> Color {
        if isDone {
            return .yamLightGray
        }else {
            if isFixed {
                return userColor.userColorData.selectedColor.mainColor.toColor()
            }else {
                return userColor.userColorData.selectedColor.mainColor.toColor()
            }
        }
    }
    
    private func getTextColor(_ isDone: Bool, _ isFixed: Bool) -> Color {
        if isDone {
            return .yamLightGray
        }else {
            if isFixed {
                return userColor.userColorData.selectedColor.mainColor.toColor()
            }else {
                return .yamBlack
            }
        }
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
