//
//  TasksByDateObject.swift
//  yamTODO
//
//  Created by 김미진 on 11/21/24.
//

import Foundation
import RealmSwift

class TasksByDateObject: Object {
    @Persisted(primaryKey: true) var key: String
    @Persisted var tasks = List<TaskObject>()
  
  convenience init(key: String, tasks: [TaskObject]) {
        self.init()
        self.key = key
        self.tasks.append(objectsIn: tasks)
    }
}

class TaskObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String
    @Persisted var desc: String
    @Persisted var isDone: Bool
    @Persisted var date: Date
    @Persisted var optionType: List<Int>
    @Persisted var rootId: String
    @Persisted var removedBy: Date?
    @Persisted var createdBy: Date
    @Persisted var isRemove: Bool
    @Persisted var isDelay: Int
    //v2
    
    @Persisted var isChanged: Bool
    @Persisted var changedBy: Date?
    @Persisted var isFixed: Bool
    
    convenience init(title: String) {
        self.init()
        self.id = UUID().uuidString
        self.title = title
        self.desc = ""
        self.isDone = false
        self.date = Date()
        self.optionType = List<Int>()
        self.rootId = ""
        self.removedBy = nil
        self.createdBy = Date()
        self.isRemove = false
        self.isDelay = 0
        
        self.isChanged = false
        self.changedBy = nil
        self.isFixed = false
    }
    
    // 반복일정을 복사해서 넣어줄때,
    // 태스크를 하루 미룰때 사용.
    func newTask(old: TaskObject) {
        self.id = UUID().uuidString
        self.title = old.title
        self.desc = old.desc
        self.isDone = old.isDone
        self.date = old.date
        self.optionType = old.optionType
        self.rootId = old.rootId
        self.removedBy = old.removedBy
        self.createdBy = old.createdBy
        self.isRemove = old.isRemove
        self.isDelay = old.isDelay
        self.isChanged = old.isChanged
        self.changedBy = old.changedBy
        self.isFixed = old.isFixed
    }
}

extension TaskObject: Identifiable {
    
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
