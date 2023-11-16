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
    @Published var date: String {
        didSet {
            updateTasks()
            objectWillChange.send(self)
        }
    }

    init(key: String) {
        self.date = key
        updateTasks()
    }
    
    func updateTasks() {
        self.tasksObject = []
        print(date)
        if let tasksObject = RealmManager.shared.getTasksByDateObject(forKey: date)?.tasks {
            self.tasksObject = Array(tasksObject)
        }
    }
    
    func updateIsDone(_ taskId: String) {
        guard let index = self.tasksObject.firstIndex(where: { $0.id == taskId }) else { return }
        RealmManager.shared.updateTaskIsDone(task: self.tasksObject[index])
        objectWillChange.send(self)
    }
    
//    func updateText(_ task: TaskObject) {
//        
//    }
}
