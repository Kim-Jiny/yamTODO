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
    @Published var selectedTask: TaskObject?
  
    init(selectedTask: TaskObject?) {
        self.selectedTask = selectedTask
    }
    
    
    func updateText(_ title: String,_ desc: String,_ isRepeat: Bool = false) {
        guard let selectedTask = selectedTask else { return }
        RealmManager.shared.updateTaskObject(task: selectedTask, taskTitle: title, taskDesc: desc, isRepeat: isRepeat)
        objectWillChange.send(self)
    }
    
    // 선택된 테스크 삭제
    func deleteSelectTask() {
        guard let selectedTask = selectedTask else { return }
        RealmManager.shared.deleteTaskObjectFromDate(task: selectedTask)
//        self.selectedTask = nil
        objectWillChange.send(self)
    }
    
    // 선택된 옵션 태스크 삭제
    func deleteSelectOptionTask() {
        guard let selectedTask = selectedTask else { return }
        RealmManager.shared.deleteOptionTaskObject(task: selectedTask)
//        self.selectedTask = nil
        objectWillChange.send(self)
    }
    
    // 선택된 테스트 하루미루기
    func delaySelectTask() {
        guard let selectedTask = selectedTask else { return }
        RealmManager.shared.delayTaskObjectFromDate(task: selectedTask)
//        self.selectedTask = nil
        objectWillChange.send(self)
    }
}
