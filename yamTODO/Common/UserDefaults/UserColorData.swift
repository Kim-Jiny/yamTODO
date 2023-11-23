//
//  UserData.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/17.
//

import Combine
import SwiftUI

private let defaultColors: [ColorModel] = [
    ColorModel(id: "defaultColorModel", color: .init(.yamBlue), colorTitle: "Default", isSelected: false),
    ColorModel(id: "defaultColorModel", color: .init(.yamDarkBlue), colorTitle: "Default", isSelected: false)
]

final class UserColorData: ObservableObject {
  let objectWillChange = PassthroughSubject<UserColorData, Never>()

  @UserDefaultValue(key: "userAddedColors", defaultValue: defaultColors)
  var colors: [ColorModel] {
    didSet {
      objectWillChange.send(self)
    }
  }
}

final class UserColorObject: ObservableObject {
    @Published var userColorData = UserColorData()
}
