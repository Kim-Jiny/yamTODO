//
//  SelectTask.swift
//  yamTODO
//
//  Created by Jiny on 11/14/23.
//

import Foundation
import SwiftUI
import Combine

class SelectedTask: ObservableObject {
    let objectWillChange = PassthroughSubject<SelectedTask, Never>()
    @Published var selectedTask: TaskObject
  
    init(selectedTask: TaskObject) {
        self.selectedTask = selectedTask
    }
    
    
    func updateText(_ title: String,_ desc: String) {
        RealmManager.shared.updateTaskObject(task: selectedTask, taskTitle: title, taskDesc: desc)
        objectWillChange.send(self)
    }
}
