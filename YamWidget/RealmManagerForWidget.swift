//
//  RealmManagerForWidget.swift
//  yamTODO
//
//  Created by 김미진 on 11/21/24.
//

import Foundation
import RealmSwift

class RealmManagerForWidget {
    static let shared = RealmManagerForWidget()
    private let appGroupID = "group.com.jiny.yamTODO"
    fileprivate let optionKey = "TaskRepeat"
    
    // Realm Configuration
    private var appGroupRealmConfig: Realm.Configuration? {
        guard let fileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID)?
            .appendingPathComponent("default.realm") else {
            return nil
        }
        return Realm.Configuration(fileURL: fileURL, schemaVersion: 5)
    }
    
    /// 날짜를 기준으로 테스크 리스트를 가져오기 (비동기 버전)
    func getTasksByDateListAsync(date: Date) async -> TasksListModel {
        guard let config = self.appGroupRealmConfig else {
            print("Error: DB 없음")
            return TasksListModel(key: date.dateKey, tasks: [])
        }
        
        return await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                do {
                    let realm = try Realm(configuration: config)
                    // 그날의 task를 꺼냄
                    let tasks = realm.object(ofType: TasksByDateObject.self, forPrimaryKey: date.dateKey)
                    // 반복 옵션을 꺼냄
                    let repeatTasks = realm.object(ofType: TasksByDateObject.self, forPrimaryKey: self.optionKey)
                    print(tasks?.tasks)
                    // 반복 옵션들에 해당 요일이 존재하는지 확인
                    let dayRepeatTasks = repeatTasks?.tasks.filter({ optionTask in
                        let isContains = optionTask.optionType.contains((Calendar.current.component(.weekday, from: date) + 100))
                        let isOverDay = Calendar.current.startOfDay(for: optionTask.createdBy) <= Calendar.current.startOfDay(for: date)
                        var isBecomeEndDay = true
                        if let removedBy = optionTask.removedBy {
                            isBecomeEndDay = Calendar.current.startOfDay(for: removedBy) > Calendar.current.startOfDay(for: date)
                        }
                        return isContains && isOverDay && isBecomeEndDay
                    })
                    
                    // 기존 tasks의 rootId 목록
                    let existingRootIds = tasks?.tasks.map { $0.rootId } ?? []
                    
                    // 조건에 맞는 반복 작업 필터링
                    let filteredTasks = dayRepeatTasks?.filter { taskObject in
                        !taskObject.isRemove && !existingRootIds.contains(taskObject.rootId)
                    } ?? []
                    
                    // 기존 tasks와 필터링된 tasks를 합침
                    let combinedTasks = (tasks?.tasks.map { $0 } ?? []) + filteredTasks
                    
                    // 제거되지 않은 최종 태스크
                    let returnTasks = combinedTasks.filter { !$0.isRemove && !$0.isDone }
                    
                    // 모델 생성
                    let tasksListModel = TasksListModel(key: date.dateKey, tasks: returnTasks)
                    continuation.resume(returning: tasksListModel)
                    
                } catch {
                    print("Error: \(error)")
                    let tasksListModel = TasksListModel(key: date.dateKey, tasks: [])
                    continuation.resume(returning: tasksListModel)
                }
            }
        }
    }
}
