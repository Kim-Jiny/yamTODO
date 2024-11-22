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
    private let appGroupID = "group.com.jiny.yamTODO"
    private var appGroupRealmConfig: Realm.Configuration? {
        guard let fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID)?
            .appendingPathComponent("default.realm") else {
            return nil
        }
        return Realm.Configuration(fileURL: fileURL, schemaVersion: 5)
    }
    
    
    // 날짜를 키값으로 테스크 가져오기
    func getTasksByDateList(date: Date) -> TasksListModel {
        guard let config = self.appGroupRealmConfig else {
            print("Error: DB 없음")
            return TasksListModel(key: date.dateKey, tasks: [])
        }
        
        do {
            let realm = try Realm(configuration: config)
            // 그날의 task를 꺼냄
            let tasks = realm.object(ofType: TasksByDateObject.self, forPrimaryKey: date.dateKey)
            // 반복 옵션을 꺼냄
            var repeatTasks = realm.object(ofType: TasksByDateObject.self, forPrimaryKey: optionKey)
            
            // TODO: 반복옵션이 변경되었을때 changedBy날짜와 태스크의 날짜를 비교해서 유저가 변경한 isChanged가 아닐때 변경된것을 적용해줌. 변경된 날짜보다 같거나 이후에 등록된 일정만 변경됨.
            // 반복옵션이 삭제되었을때 등록된 태스크에서 제거된 반복옵션부터 삭제
            if let repeatTasks = repeatTasks, let tasks = tasks {
                // 반봅옵션 id list
                let repeatIdArr = Array(repeatTasks.tasks.map({ $0.id }))
                // 기존의 테스크들중에 옵션키값이 존재하는 애들의 지워진 날짜 비교
                tasks.tasks.forEach { task in
                    // 테스트가 옵션에서 가지고온거면
                    if task.optionType.count > 0 {
                        // 옵션리스트에도 id가 존재하면.
                        repeatTasks.tasks.forEach {
                            if $0.id == task.rootId {
                                // 그런데 옵션리스트에서는 삭제되었고 삭제된 시간이 오늘 날짜 이전이면 해당 태스크를 삭제해줘야함.
                                if let removedBy = $0.removedBy {
                                    let isOverEndDay = Calendar.current.startOfDay(for: removedBy) < Calendar.current.startOfDay(for: date)
                                    // 삭제
                                    if isOverEndDay {
                                        deleteTaskObjectFromDate(task: task, force: true)
                                    }
                                }
                                // 옵션리스트에서 변경된 날짜가 태스크의 날짜보다 이후이면 변경을 업데이트 해줘야함.
                                // 옵션에서 changedBy가 존재할때, 태스크가 유저가 변경하지 않았을때
                                if let changedBy = $0.changedBy, task.isChanged == false {
                                    // 반복 옵션의 변경된 날짜 <= 태스크의 날짜
                                    let isOverChangedDay = Calendar.current.startOfDay(for: changedBy) <= Calendar.current.startOfDay(for: date)
                                    
                                    if isOverChangedDay {
                                        // task를 업데이트해줌.  - 여기서 지워주면 밑에서 채워줌.
                                        deleteTaskObjectFromDate(task: task, force: true)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            let reTasks = realm.object(ofType: TasksByDateObject.self, forPrimaryKey: date.dateKey)
            //리턴모델로 만듬.
            let tasksArray = Array(reTasks?.tasks ?? List<TaskObject>())
            let returnModel = TasksListModel(key: date.dateKey, tasks: tasksArray)
            
            // 반복 옵션이 등록되지 않았을때 realm에 추가 등록해줌.
            // 반복 옵션들에 해당요일이 존재하는지 확인함.
            let dayRepeatTasks = repeatTasks?.tasks.filter({ optionTask in
                // 옵션이 해당날짜에 해당되는지 확인
                let isContains = optionTask.optionType.contains((Calendar.current.component(.weekday, from: date) + 100))
                // 오늘날짜가 생성날짜보다 이후 인지 확인
                let isOverDay = Calendar.current.startOfDay(for: optionTask.createdBy) <= Calendar.current.startOfDay(for: date)
                // 오늘날짜가 지워진 날짜보다 이전인지 확인
                var isBecomeEndDay = true
                if optionTask.removedBy != nil {
                    isBecomeEndDay = Calendar.current.startOfDay(for: optionTask.removedBy!) > Calendar.current.startOfDay(for: date)
                }
                return isContains && isOverDay && isBecomeEndDay
            })
            // 그날의 task에 RootId에 옵션과 중복되는 Task 가 있는지 확인하고 버림.
            let repeateArray = returnModel.tasks.filter({ task in
                task.rootId != "" && task.isDelay == 0
            }).compactMap { task in
                task.rootId
            }
            
            // 해당 날짜 반복 태스트 for
            dayRepeatTasks?.forEach { repeatTask in
                // 포함되어있지 않으면 포함해줌.
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
        guard let config = self.appGroupRealmConfig else {
            print("Error: DB 없음")
            return nil
        }
        
        do {
            let realm = try Realm(configuration: config)
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
        guard let config = self.appGroupRealmConfig else {
            print("Error: DB 없음")
            return nil
        }
        
        do {
            let realm = try Realm(configuration: config)
            let tasks = realm.object(ofType: TasksByDateObject.self, forPrimaryKey: key)
            
            return tasks
        }catch {
            print("Error: \(error)")
            return nil
        }
    }
    
    // 테스크 가져오기
    private func getTaskObject(forKey key: String) -> TaskObject? {
        guard let config = self.appGroupRealmConfig else {
            print("Error: DB 없음")
            return nil
        }
        do {
            let realm = try Realm(configuration: config)
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
        guard let config = self.appGroupRealmConfig else {
            print("Error: DB 없음")
            return
        }
        do {
            let realm = try Realm(configuration: config) // Realm 객체 생성
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
        guard let config = self.appGroupRealmConfig else {
            print("Error: DB 없음")
            return
        }
        do {
            let realm = try Realm(configuration: config) // Realm 객체 생성
            // 이번달 달력 데이터 있으면
            print(date)
            print(date.monthKey)
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
    func deleteTaskObjectFromDate(task: TaskObject, force: Bool = false) {
        do {
            if let tasks = getTasksByDateObject(date: task.date), let index = tasks.tasks.firstIndex(of: task) {
                // tasks 리스트에서 해당 TaskObject를 제거합니다.
                // 만약에 rootId가 없으면 일반삭제 진행 - 반복 옵션이 아님
                if task.rootId == "" || force {
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
    
    func deleteOptionTaskObject(task: TaskObject) {
        do {
            if let tasks = getOptionObject(key: optionKey) {
                // tasks 리스트에서 해당 TaskObject를 삭제를 업데이트합니다.
                // 바로 삭제를 하지않는 이유는 ~까지 옵션을 구현하기 위함.
                try task.realm?.write {
                    task.isRemove = true
                    task.removedBy = Date()
                }
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    // 테스크를 업데이트
    func updateTaskObject(task: TaskObject, taskTitle: String, taskDesc: String, isRepeat: Bool) {
        do {
            guard let taskObject = task.realm?.object(ofType: TaskObject.self, forPrimaryKey: task.id) else {
                print("TaskObject not found")
                return
            }
            try task.realm?.write {
                // 해당 taskObject의 속성 업데이트
                taskObject.title = taskTitle
                taskObject.desc = taskDesc
                taskObject.changedBy = Date().getStartTime()
                // 반복옵션의 루트 수정시
                if !isRepeat {
                    taskObject.isChanged = true
                }
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
                task.isChanged = true
            }
        } catch {
            print("Error: \(error)")
        }
    }
    // 테스크 Fix 업데이트
    func updateTaskIsFixed(task: TaskObject) {
        do {
            try task.realm?.write {
                task.isFixed = !task.isFixed
                task.isChanged = true
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    // Calendar Month Data
    // 해당달의 키값으로 테스크 가져오기
    func getTasksByMonthObject(date: Date) -> TasksByMonthObject? {
        guard let config = self.appGroupRealmConfig else {
            print("Error: DB 없음")
            return nil
        }
        do {
            let realm = try Realm(configuration: config)
            // 그날의 task를 꺼냄
            let tasks = realm.object(ofType: TasksByMonthObject.self, forPrimaryKey: date.monthKey)
            
            return tasks
        }catch {
            print("Error: \(error)")
            return nil
        }
    }
    
    func getMonthData(date: Date) -> TasksByMonthListModel {
        guard let config = self.appGroupRealmConfig else {
            print("Error: DB 없음")
            return TasksByMonthListModel(date: date, days: [])
        }
        do {
            let realm = try Realm(configuration: config)
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
    
    // 테스크를 하루 미룸.
    func delayTaskObjectFromDate(task: TaskObject) {
        do {
            if let tasks = getTasksByDateObject(date: task.date), let index = tasks.tasks.firstIndex(of: task) {
                // 새로운 태스크를 추가해줌.
                let newTask = TaskObject()
                newTask.newTask(old: task)
                newTask.optionType = List<Int>()
                if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: task.date) {
                    newTask.date = tomorrow
                    newTask.isDelay = task.isDelay + 1
                }
                addTask(date: newTask.date, new: newTask)
                // 만약에 rootId가 없으면 그냥삭제  - 반복 옵션이 아님
                if task.rootId == "" {
                    try! task.realm?.write {
                        tasks.tasks.remove(at: index)
                    }
                }else {
                    // rootId가 있으면 반복옵션이므로 해당날짜 removedBy업데이트
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
}
