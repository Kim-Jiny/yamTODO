//
//  SelectTask.swift
//  yamTODO
//
//  Created by Jiny on 11/14/23.
//

import Foundation
import SwiftUI

class SelectedTask: ObservableObject {
    @Published var selectedTask: TaskObject
  
  init(selectedTask: TaskObject) {
    self.selectedTask = selectedTask
  }
}
