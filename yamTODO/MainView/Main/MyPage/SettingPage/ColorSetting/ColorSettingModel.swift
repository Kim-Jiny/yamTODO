//
//  ColorSettingModel.swift
//  yamTODO
//
//  Created by Jiny on 11/23/23.
//

import Foundation
import SwiftUI

struct ColorModel: Identifiable, Equatable, Codable {
    var id = UUID().uuidString
    let mainColor: CodableColor
    let darkColor: CodableColor
    let lightColor: CodableColor
    let todayColor: CodableColor
    let colorTitle: String
}


struct CodableColor: Codable, Equatable {
    let red: Double
    let green: Double
    let blue: Double
    let opacity: Double

    init(_ color: Color) {
        let uiColor = UIColor(color)
        var redValue: CGFloat = 0
        var greenValue: CGFloat = 0
        var blueValue: CGFloat = 0
        var alphaValue: CGFloat = 0
        uiColor.getRed(&redValue, green: &greenValue, blue: &blueValue, alpha: &alphaValue)

        red = Double(redValue)
        green = Double(greenValue)
        blue = Double(blueValue)
        opacity = Double(alphaValue)
    }

    func toColor() -> Color {
        return Color(red: red, green: green, blue: blue, opacity: opacity)
    }
}

