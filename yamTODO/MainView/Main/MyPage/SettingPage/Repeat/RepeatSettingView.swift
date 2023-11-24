//
//  RepeatSettingView.swift
//  yamTODO
//
//  Created by Jiny on 11/16/23.
//

import Foundation
import SwiftUI

struct RepeatSettingView: View {
    @ObservedObject var userColor: UserColorObject
    @StateObject var taskList = OptionTaskList()
    @State var isShowDetailPopup: Bool = false
    @State var selectedTask: SelectedTask = SelectedTask(selectedTask: nil)
    @State var selectedDate = Date()
    var body: some View {
        ZStack {
            List {
                ForEach(self.taskList.tasksObject) { task in
                    // 지워지거나 수정되지 않은 옵션만 표시
                    if !task.isRemove {
                        RepeatItemView(task: task, isShowDetailPopup: $isShowDetailPopup, selectedTask: $selectedTask)
                            .environmentObject(taskList)
                    }
                }
            }
            .navigationBarTitle("Recurring schedule")
            .navigationBarTitleDisplayMode(.inline)
            
            if isShowDetailPopup {
                if selectedTask.selectedTask != nil {
                    RepeatDetailPopupView(userColor: userColor, selectedTask: $selectedTask, isPresented: $isShowDetailPopup)
                  .environmentObject(taskList)
              }
            }
        }
    }
}
