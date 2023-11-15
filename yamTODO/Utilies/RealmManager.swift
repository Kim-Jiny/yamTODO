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
  
  // 날짜를 키값으로 테스크 가져오기
  func getTasksByDateObject(forKey key: String) -> TasksByDateObject? {
    do {
      let realm = try Realm()
      return realm.object(ofType: TasksByDateObject.self, forPrimaryKey: key)
    }catch {
      print("Error: \(error)")
      return nil
    }
  }
  // 테스크 가져오기
  func getTaskObject(forKey key: String) -> TaskObject? {
    do {
      let realm = try Realm()
      return realm.object(ofType: TaskObject.self, forPrimaryKey: key)
    }catch {
      print("Error: \(error)")
      return nil
    }
  }
  // 해당 날짜에 테스크가 있는지 확인.
  func isKeyAlreadyExists(key: String) -> Bool {
      return getTasksByDateObject(forKey: key) != nil
  }
  
  // 해당 날짜에 테스크가 있는경우 append 없는경우 생성하도록해서 Task 추가.
  func writeTasksByDateObject(forKey key: String, tasks: [TaskObject]) {
    do {
      let realm = try Realm() // Realm 객체 생성
      if let existingObject = getTasksByDateObject(forKey: key) {
        try realm.write {
          tasks.forEach { task in
            if let duplication = getTaskObject(forKey: task.id) {
              // 중복일때 업데이트 해줘야할까? 고민됨.
            }else {
              existingObject.tasks.append(task)
            }
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
  // 옵션은 각자 월,화,수,목,금,토,일 의 반복 키값에 넣음.
  func writeOptionTask(optionId: String, tasks: [TaskObject]) {
    self.writeTasksByDateObject(forKey: optionId, tasks: tasks)
  }
  
  // 테스크를 삭제.
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
  // 테스크를 업데이트
    func updateTaskObject(task: TaskObject, taskTitle: String, taskDesc: String) {
      do {
          guard let taskObject = task.realm?.object(ofType: TaskObject.self, forPrimaryKey: task.id) else {
              print("TaskObject not found")
              return
          }
          try task.realm?.write {
              // 해당 taskObject의 속성 업데이트
              taskObject.title = taskTitle
              taskObject.desc = taskDesc
          }
      } catch {
          print("Error: \(error)")
      }
  }
    
    func updateTaskIsDone(task: TaskObject) {
        do {
            try task.realm?.write {
                task.isDone = !task.isDone
            }
        } catch {
            print("Error: \(error)")
        }
    }

}
