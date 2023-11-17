//
//  TasksByMonth.swift
//  yamTODO
//
//  Created by 김미진 on 11/17/23.
//

import Foundation
import RealmSwift
import Combine

class TasksByMonthObject: Object {
    @Persisted(primaryKey: true) var key: String
    @Persisted var days = List<TasksByDateObject>()
  
  convenience init(key: String, tasks: [TasksByDateObject]) {
        self.init()
        self.key = key
        self.days.append(objectsIn: tasks)
    }
}

class TasksByMonthListModel: ObservableObject {
    let objectWillChange = PassthroughSubject<TasksByMonthListModel, Never>()
    @Published var date: Date {
        didSet {
            updateTasks()
            objectWillChange.send(self)
        }
    }
    @Published var days: [TasksByDateObject] = []
  
    init(date: Date) {
        self.date = date
        updateTasks()
    }
    
    init(date: Date, days: [TasksByDateObject]) {
        self.date = date
        self.days = days
    }
        
    func updateTasks() {
        self.days = RealmManager.shared.getMonthData(date: date).days
    }
}
