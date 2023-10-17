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
  var isDone: Bool

  init(id: String, title: String, isDone: Bool) {
    self.id = id // = UUID().uuidString
    self.title = title
    self.isDone = isDone
  }
}
