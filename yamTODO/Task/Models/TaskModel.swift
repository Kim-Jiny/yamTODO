//
//  TODOTask.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/16.
//

import Foundation
//import SwiftUI
import RealmSwift

struct Task: Equatable, Hashable, Codable, Identifiable {
  let id: String
  var title: String
  var desc: String
  var isDone: Bool
  var date: Date
  var optionType: [Int]
  var rootId: String // 옵션에서 받아온 테스크인데 중복되지않도록. 
  var removedBy: Date? // 옵션으로 쓰는데 지워질때 ( 이전데이터는 남아야하므로 )
  var createdBt: Date // 옵션으로 쓰는데 생성될때 ( 이전날짜들은 표시되지 말아야하므로 )
  var isRemove: Bool // 당장 오늘 데이터에서 지워질때

  init(title: String) {
    self.id = UUID().uuidString
    self.title = title
    self.desc = ""
    self.isDone = false
    self.date = Date()
    self.optionType = []
    self.rootId = ""
    self.removedBy = nil
    self.createdBt = Date()
    self.isRemove = false
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
    @Persisted var createdBt: Date
    @Persisted var isRemove: Bool

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
        self.createdBt = Date()
        self.isRemove = false
    }
}

extension TaskObject: Identifiable {
  
}
