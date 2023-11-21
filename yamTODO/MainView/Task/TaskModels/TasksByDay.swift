//
//  TasksByDateModel.swift
//  yamTODO
//
//  Created by Jiny on 2023/11/06.
//

import Foundation
import RealmSwift
import Combine

class TasksByDateObject: Object {
    @Persisted(primaryKey: true) var key: String
    @Persisted var tasks = List<TaskObject>()
  
  convenience init(key: String, tasks: [TaskObject]) {
        self.init()
        self.key = key
        self.tasks.append(objectsIn: tasks)
    }
}

class TaskList: ObservableObject {
    let objectWillChange = PassthroughSubject<TaskList, Never>()
    @Published var tasksObject: [TaskObject] = []
    @Published var tomarrowTasksObject: [TaskObject] = []
    @Published var date: Date {
        didSet {
            updateTasks()
        }
    }
    
    init(date: Date) {
        self.date = date
    }
    
    func updateTasks() {
        self.tasksObject = RealmManager.shared.getTasksByDateList(date: date).tasks
        objectWillChange.send(self)
    }
    
    func updateIsDone(_ taskId: String) {
        guard let index = self.tasksObject.firstIndex(where: { $0.id == taskId }) else { return }
        RealmManager.shared.updateTaskIsDone(task: self.tasksObject[index])
        objectWillChange.send(self)
    }
    
    func createTask(new: TaskObject) {
        RealmManager.shared.addTask(date: date, new: new)
        updateTasks()
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


class TasksListModel {
    var key: String
    var tasks: [TaskObject]
  
   init(key: String, tasks: [TaskObject]) {
        self.key = key
        self.tasks = tasks
    }
    
    func getTasksListModel(_ object: TasksByDateObject) {
        self.key = object.key
        self.tasks = Array(object.tasks)
    }
}
