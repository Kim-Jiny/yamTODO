//
//  TasksByDateModel.swift
//  yamTODO
//
//  Created by Jiny on 2023/11/06.
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
