//
//  ColorSettingVM.swift
//  yamTODO
//
//  Created by Jiny on 11/23/23.
//

import Foundation
import SwiftUI

class ColorSelectViewModel: ObservableObject {
    @Published var userColor = UserColorData()
    @Published var selectedColorIndex: Int?

    func addColor(_ color: Color) {
        userColor.colors.append(ColorModel(color: CodableColor(color), colorTitle: "123"))
    }
    
    func selectColor(at index: Int) {
        if let selectedIndex = selectedColorIndex, selectedIndex == index {
            selectedColorIndex = nil
        } else {
            selectedColorIndex = index
        }

        for i in 0..<userColor.colors.count {
            userColor.colors[i].isSelected = (i == selectedColorIndex)
        }
    }
    
    func removeSelectedColor() {
        if let selectedIndex = selectedColorIndex {
            userColor.colors.remove(at: selectedIndex)
            selectedColorIndex = nil
        }
    }
}
