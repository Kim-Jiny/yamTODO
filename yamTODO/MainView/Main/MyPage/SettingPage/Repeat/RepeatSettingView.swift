//
//  RepeatSettingView.swift
//  yamTODO
//
//  Created by Jiny on 11/16/23.
//

import Foundation
import SwiftUI

struct RepeatSettingView: View {
    @StateObject var taskList = OptionTaskList()
    @State var isShowDetailPopup: Bool = false
    @State var selectedTask: SelectedTask = SelectedTask(selectedTask: nil)
    @State var selectedDate = Date()
    var body: some View {
        ZStack {
            List {
                ForEach(self.taskList.tasksObject) { task in
                    RepeatItemView(task: task, isShowDetailPopup: $isShowDetailPopup, selectedTask: $selectedTask)
                        .environmentObject(taskList)
                }
            }
            .navigationBarTitle("반복 할 일")
            .navigationBarTitleDisplayMode(.inline)
            
            if isShowDetailPopup {
                if selectedTask.selectedTask != nil {
                DetailPopupView(selectedTask: $selectedTask, isPresented: $isShowDetailPopup)
                  .environmentObject(taskList)
              }
            }
        }
    }
}
