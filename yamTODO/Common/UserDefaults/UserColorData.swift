//
//  UserData.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/17.
//

import Combine
import SwiftUI

private let defaultColors: [ColorModel] = [
    ColorModel(id: "defaultColorModel", mainColor: .init(.yamBlue), darkColor: .init(.yamDarkBlue), lightColor: .init(.yamSky), todayColor: .init(.yamLightGreen), colorTitle: "Default", isSelected: false)
]

final class UserColorData: ObservableObject {
    let objectWillChange = PassthroughSubject<UserColorData, Never>()
    let selectedChange = PassthroughSubject<UserColorData, Never>()

    @UserDefaultValue(key: "userAddedColors", defaultValue: defaultColors)
    var colors: [ColorModel] {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    @UserDefaultValue(key: "userAddedColorsSelected", defaultValue: "defaultColorModel")
    var selectedColor: String {
        didSet {
            selectedChange.send(self)
        }
    }
    
    func selectColor(id: String) {
        selectedColor = id
    }
    
    func removeColor(id: String) {
        if let selectedColorIndex = colors.firstIndex(where: { color in
            color.id == id
        }) {
            colors.remove(at: selectedColorIndex)
        }
    }
}

final class UserColorObject: ObservableObject {
    @Published var userColorData = UserColorData()
    @Published var id: String = ""

    func addColor(_ color: ColorModel) {
        userColorData.colors.append(color)
    }
    
    func selectColor(id: String) {
        userColorData.selectColor(id: id)
    }
    
    func removeColor(id: String) {
        userColorData.removeColor(id: id)
    }
}
