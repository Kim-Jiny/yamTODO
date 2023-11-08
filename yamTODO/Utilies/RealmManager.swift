//
//  RealmManager.swift
//  yamTODO
//
//  Created by Jiny on 2023/11/08.
//

import Foundation
import RealmSwift
class RealmManager {
  static let shared = RealmManager()
  
  func getTasksByDateObject(forKey key: String) -> TasksByDateObject? {
    do {
      let realm = try Realm()
      return realm.object(ofType: TasksByDateObject.self, forPrimaryKey: key)
    }catch {
      print("Error: \(error)")
      return nil
    }
  }

  func isKeyAlreadyExists(key: String) -> Bool {
      return getTasksByDateObject(forKey: key) != nil
  }
  
  func writeTasksByDateObject(forKey key: String, tasks: [TaskObject]) {
    do {
      let realm = try Realm() // Realm 객체 생성
      if let existingObject = getTasksByDateObject(forKey: key) {
        try realm.write {
          for task in tasks {
            existingObject.tasks.append(task)
          }
        }
      }else {
        let dateObject = TasksByDateObject(key: key, tasks: tasks)
        try realm.write {
            realm.add(dateObject)
        }
      }
    } catch {
        print("Error: \(error)")
    }
  }
  
  func writeOptionTask(tasks: [TaskObject]) {
    
  }
  
  func deleteTaskObjectFromDate(dateKeyId: String, TaskId: String) {
    do {
      let realm = try Realm() // Realm 객체 생성
      defer {
        realm.invalidate() // Realm 인스턴스 해제
      }
      if let dateObject = getTasksByDateObject(forKey: dateKeyId) {
        if let index = dateObject.tasks.firstIndex(where: { $0.id == TaskId }) {
          try realm.write {
            dateObject.tasks.remove(at: index)
          }
        }
      }
    } catch {
      print("Error: \(error)")
    }
  }
}
