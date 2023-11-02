//
//  TODOTask.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/16.
//

import Foundation
import SwiftUI

struct Task: Equatable, Hashable, Codable, Identifiable {
  let id: String
  var title: String
  var desc: String
  var isDone: Bool
  var date: Date
  var optionType: [Int]
  var rootId: String

  init(title: String) {
    self.id = UUID().uuidString
    self.title = title
    self.desc = ""
    self.isDone = false
    self.date = Date()
    self.optionType = []
    self.rootId = ""
  }
}
