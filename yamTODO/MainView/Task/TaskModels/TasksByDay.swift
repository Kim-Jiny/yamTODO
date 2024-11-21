//
//  TasksByDateModel.swift
//  yamTODO
//
//  Created by Jiny on 2023/11/06.
//

import Foundation
import RealmSwift
import Combine

class TaskList: ObservableObject {
    let objectWillChange = PassthroughSubject<TaskList, Never>()
    @Published var tasksObject: [TaskObject] = []
    @Published var date: Date {
        didSet {
            updateTasks()
            objectWillChange.send(self)
        }
    }
    
    init(date: Date) {
        self.date = date
    }
    
    func updateTasks() {
        self.tasksObject = RealmManager.shared.getTasksByDateList(date: date).tasks
    }
    
    func updateIsDone(_ taskId: String) {
        guard let index = self.tasksObject.firstIndex(where: { $0.id == taskId }) else { return }
        RealmManager.shared.updateTaskIsDone(task: self.tasksObject[index])
        objectWillChange.send(self)
    }
    
    func createTask(new: TaskObject) {
        RealmManager.shared.addTask(date: date.getStartTime(), new: new)
        updateTasks()
        objectWillChange.send(self)
    }
}

class OptionTaskList: ObservableObject {
    let objectWillChange = PassthroughSubject<OptionTaskList, Never>()
    @Published var tasksObject: [TaskObject] = []
    @Published var key: String {
        didSet {
            updateTasks()
            objectWillChange.send(self)
        }
    }
    
    init() {
        self.key = "TaskRepeat"
        updateTasks()
    }
    
    func updateTasks() {
        self.tasksObject = []
        self.tasksObject = RealmManager.shared.getOptionList(key: key).tasks
    }
    
    func updateIsDone(_ taskId: String) {
        guard let index = self.tasksObject.firstIndex(where: { $0.id == taskId }) else { return }
        RealmManager.shared.updateTaskIsDone(task: self.tasksObject[index])
        objectWillChange.send(self)
    }
    
}

