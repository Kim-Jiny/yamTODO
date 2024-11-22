//
//  UserData.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/17.
//

import Combine
import SwiftUI

private let defaultColors: [ColorModel] = [
    ColorModel(id: "defaultColorModel", mainColor: .init(.yamBlue), darkColor: .init(.yamDarkBlue), lightColor: .init(.yamSky), todayColor: .init(.yamLightGreen), colorTitle: "Default")
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
    
    @UserDefaultValue(key: "userAddedColorsSelected", defaultValue: defaultColors.first!)
    var selectedColor: ColorModel {
        didSet {
            selectedChange.send(self)
        }
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
    
    func selectColor(color: ColorModel) {
        userColorData.selectedColor = color
    }
    
    func removeColor(id: String) {
        userColorData.removeColor(id: id)
    }
    
    func updateColor(_ color: ColorModel) {
        if let selectedColorIndex = userColorData.colors.firstIndex(where: { userColor in
            userColor.id == color.id
        }) {
            userColorData.colors[selectedColorIndex] = color
            
            if userColorData.selectedColor.id == color.id {
                userColorData.selectedColor = color
            }
        }
    }
}


extension Color {
    // 다크모드 지원 컬러
    static let yamLightGreen = YamColor.yamGreen
    static let yamSky = YamColor.yamLightBlue
    static let yamBlue = YamColor.yamBlue
    static let yamDarkBlue = YamColor.yamDarkBlue
    static let yamLightGray = YamColor.gray
    static let yamDarkGray = YamColor.darkGray
    static let yamWhite = YamColor.yamWhite
    static let yamBlack = YamColor.yamBlack
    static let yamRealDarkPoint = YamColor.yamDarkBlue
    
    // 불변 컬러
    static let realWhite = YamColor.white
    static let realBlack = YamColor.black
    
    private struct YamColor {
        static let white = Color(hex: "#F7F7F7")
        static let black = Color(hex: "#181818")
        static let gray = Color("yamGray")
        static let darkGray = Color("yamGrayR")
//        static let gray = Color(hex: "#EDEBF1")
        
        static let yamPurple = Color(hex: "#9487AF")
        static let yamDarkPurple = Color(hex: "#352656")
        static let yamLightPurple = Color(hex: "#B7AFCA")
        
        static let yamBlue = Color(hex: "#3CA0C7")
        static let yamDarkBlue = Color(hex: "#246077")
        static let yamLightBlue = Color(hex: "#D8ECF3")
        
        static let yamGreen = Color(hex: "#3CC7A9")
        static let yamWhite = Color("yamWhite")
        static let yamBlack = Color("yamBlack")
    }
}

extension UIColor {
    static let yamLightGreen = UIColor(named: "yamLightGreen")
    static let yamSky = UIColor(named: "yamSky")
    static let yamBlue = UIColor(named: "yamBlue")
    static let yamDarkBlue = UIColor(named: "yamDarkBlue")
    static let yamLightGray = UIColor(named: "yamGray")
    static let yamDarkGray = UIColor(named: "yamGrayR")
    static let yamWhite = UIColor(named: "yamWhite")
    static let yamBlack = UIColor(named: "yamBlack")
    
    static let yamRealDarkPoint = UIColor(named: "yamRealDarkPoint")
    static let realWhite = UIColor(named: "realWhite")
}
