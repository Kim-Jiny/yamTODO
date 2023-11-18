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
    @State var isShowEditPopup: Bool = false
    @State var isShowDetailPopup: Bool = false
    @State var selectedTask: SelectedTask = SelectedTask(selectedTask: nil)
    @State var selectedDate = Date()
    var body: some View {
        NavigationView {
            List {
                ForEach(self.taskList.tasksObject) { task in
                    RepeatItemView(task: task, isShowEditPopup: self.$isShowEditPopup, isShowDetailPopup: self.$isShowDetailPopup, selectedTask: $selectedTask)
                        .environmentObject(taskList)
                }
            }
            .navigationBarTitle("반복 설정")
            
            if isShowEditPopup {
                EditPopupView(selectedDate: selectedDate, isPresented: $isShowEditPopup).environmentObject(taskList)
            }
            if isShowDetailPopup {
                if selectedTask.selectedTask != nil {
                DetailPopupView(selectedTask: $selectedTask, isPresented: $isShowDetailPopup)
                  .environmentObject(taskList)
              }
            }
        }
    }
}
