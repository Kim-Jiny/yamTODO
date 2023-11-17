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
    fileprivate let optionKey = "TaskRepeat"
  
  // 날짜를 키값으로 테스크 가져오기
  func getTasksByDateList(date: Date) -> TasksListModel {
    do {
      let realm = try Realm()
        // 그날의 task를 꺼냄
        let tasks = realm.object(ofType: TasksByDateObject.self, forPrimaryKey: date.dateKey)
        
        //리턴모델로 만듬.
        let tasksArray = Array(tasks?.tasks ?? List<TaskObject>())
        let returnModel = TasksListModel(key: date.dateKey, tasks: tasksArray)
        // 반복 옵션들을 꺼내서 해당요일이 존재하는지 확인함.
        let repeatTasks = realm.object(ofType: TasksByDateObject.self, forPrimaryKey: optionKey)
        let dayRepeatTasks = repeatTasks?.tasks.filter({ optionTask in
            optionTask.optionType.contains((Calendar.current.component(.weekday, from: date) + 100))
        })
        // 그날의 task에 RootId에 옵션과 중복되는 Task 가 있는지 확인하고 버림.
        let repeateArray = returnModel.tasks.filter({ task in
            task.rootId != ""
        }).compactMap { task in
            task.rootId
        }
        
        dayRepeatTasks?.forEach { repeatTask in
            if !repeateArray.contains(where: { $0 == repeatTask.id }) {
                // repeateArray에 repeatTask.id가 없는 경우
                // 그날의 task List에 반복 테스크를 넣어서 리턴시킴.
                let newRepeatTask = TaskObject(title: repeatTask.title)
                newRepeatTask.newTask(old: repeatTask)
                newRepeatTask.date = date
                self.writeTasksByDateObject(date: date, tasks: [newRepeatTask])
                returnModel.tasks.append(newRepeatTask)
            }
        }
        
      return returnModel
    }catch {
      print("Error: \(error)")
        return TasksListModel(key: date.dateKey, tasks: [])
    }
  }
    // 반복 옵션List 가지고오기
    func getOptionList(key: String) -> TasksListModel {
        if let optionTask = getOptionObject(key: key) {
            return TasksListModel(key: key, tasks: Array(optionTask.tasks))
        }else {
            return TasksListModel(key: key, tasks: [])
        }
    }
    // 날짜를 키값으로 테스크 가져오기
    private func getTasksByDateObject(date: Date) -> TasksByDateObject? {
      do {
        let realm = try Realm()
          // 그날의 task를 꺼냄
          let tasks = realm.object(ofType: TasksByDateObject.self, forPrimaryKey: date.dateKey)
          
        return tasks
      }catch {
        print("Error: \(error)")
        return nil
      }
    }

    // 반복 옵션List 가지고오기
    private func getOptionObject(key: String) -> TasksByDateObject? {
      do {
        let realm = try Realm()
          let tasks = realm.object(ofType: TasksByDateObject.self, forPrimaryKey: key)
          
        return tasks
      }catch {
        print("Error: \(error)")
        return nil
      }
    }
    
  // 테스크 가져오기
  private func getTaskObject(forKey key: String) -> TaskObject? {
    do {
      let realm = try Realm()
      return realm.object(ofType: TaskObject.self, forPrimaryKey: key)
    }catch {
      print("Error: \(error)")
      return nil
    }
  }
  // 해당 날짜에 테스크가 있는지 확인.
//  func isKeyAlreadyExists(key: String) -> Bool {
//      return getTasksByDateObject(forKey: key) != nil
//  }
  
  // 해당 날짜에 테스크가 있는경우 append 없는경우 생성하도록해서 Task 추가.
    private func writeOptionObject(key: String, task: TaskObject) {
        do {
            let realm = try Realm() // Realm 객체 생성
            if let existingObject = getOptionObject(key: key){
                try realm.write {
                    if let duplication = getTaskObject(forKey: task.id) {
                        //TODO: 중복일때 업데이트 해줘야할까?
                    }else {
                        task.rootId = task.id
                        existingObject.tasks.append(task)
                    }
                }
            }else {
                let optionTask = task
                optionTask.rootId = task.id
                let dateObject = TasksByDateObject(key: key, tasks: [optionTask])
                try realm.write {
                    realm.add(dateObject)
                }
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    // 해당 날짜에 테스크가 있는경우 append 없는경우 생성하도록해서 Task 추가.
    private func writeTasksByDateObject(date: Date, tasks: [TaskObject]) {
        do {
            let realm = try Realm() // Realm 객체 생성
            // 이번달 달력 데이터 있으면
            if let monthObject = getTasksByMonthObject(date: date) {
                // 해당 날짜에 데이터 있으면
                if let existingObject = getTasksByDateObject(date: date) {
                    try realm.write {
                        tasks.forEach { task in
                            // 해당 데이터 있으면
                            if let duplication = getTaskObject(forKey: task.id) {
                                //TODO: 중복일때 업데이트 해줘야할까?
                            }else {
                                // 데이터 추가
                                existingObject.tasks.append(task)
                            }
                        }
                    }
                    // 해당 날짜에 데이터가 없으면 근데 달력 데이터는 있으니까
                }else {
                    let dateObject = TasksByDateObject(key: date.dateKey, tasks: tasks)
                    try realm.write {
                        monthObject.days.append(dateObject)
                    }
                }
                // 달력 데이터가 없으면 그냥 아무것도 없으니까 처음부터 만들면 됌
            }else {
                let dateObject = TasksByDateObject(key: date.dateKey, tasks: tasks)
                let monthObject = TasksByMonthObject(key: date.monthKey, tasks: [dateObject])
                try realm.write {
                    realm.add(monthObject)
                }
            }
        } catch {
            print("Error: \(error)")
        }
    }
  // 테스크를 삭제.
    func deleteTaskObjectFromDate(task: TaskObject) {
        do {
            if let tasks = getTasksByDateObject(date: task.date), let index = tasks.tasks.firstIndex(of: task) {
                // tasks 리스트에서 해당 TaskObject를 제거합니다.
                // 만약에 rootId가 없으면 일반삭제 진행 - 반복 옵션이 아님
                if task.rootId == "" {
                    try! task.realm?.write {
                        tasks.tasks.remove(at: index)
                    }
                }else {
                // rootId가 있으면 반복옵션이므로 해당날짜만 삭제해야함. 따라서 removedBy를 업데이트합니다.
                    try task.realm?.write {
                        task.isRemove = true
                        task.removedBy = Date()
                    }
                }
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    func addTask(date: Date, new task: TaskObject) {
        // 반복 옵션이 있는경우 반복옵션 Table에 기록해야함.
        if task.optionType.count > 0 {
            self.writeOptionObject(key: optionKey, task: task)
        }else {
            self.writeTasksByDateObject(date: date, tasks: [task])
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
    
    // 테스크 Done 업데이트
    func updateTaskIsDone(task: TaskObject) {
        do {
            try task.realm?.write {
                task.isDone = !task.isDone
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    // Calendar Month Data
    // 해당달의 키값으로 테스크 가져오기
    func getTasksByMonthObject(date: Date) -> TasksByMonthObject? {
      do {
        let realm = try Realm()
          // 그날의 task를 꺼냄
          let tasks = realm.object(ofType: TasksByMonthObject.self, forPrimaryKey: date.monthKey)
          
        return tasks
      }catch {
        print("Error: \(error)")
        return nil
      }
    }
    
    func getMonthData(date: Date) -> TasksByMonthListModel {
        do {
          let realm = try Realm()
            // 그달의 task를 꺼냄
            let monthData = realm.object(ofType: TasksByMonthObject.self, forPrimaryKey: date.monthKey)
            
            //리턴모델로 만듬.
            let dateArray = Array(monthData?.days ?? List<TasksByDateObject>())
            let returnModel = TasksByMonthListModel(date: date, days: dateArray)
            
          return returnModel
        }catch {
          print("Error: \(error)")
            return TasksByMonthListModel(date: date, days: [])
        }
    }
}
