//
//  Extension+Color.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/17.
//

import SwiftUI

extension Color {
  init(hex: String) {
    let scanner = Scanner(string: hex)
    _ = scanner.scanString("#")
    
    var rgb: UInt64 = 0
    scanner.scanHexInt64(&rgb)
    
    let r = Double((rgb >> 16) & 0xFF) / 255.0
    let g = Double((rgb >>  8) & 0xFF) / 255.0
    let b = Double((rgb >>  0) & 0xFF) / 255.0
    self.init(red: r, green: g, blue: b)
  }
}

extension UIColor {
    convenience init?(hex: String) {
        var formattedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        formattedHex = formattedHex.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: formattedHex).scanHexInt64(&rgb) else { return nil }

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}


extension Color {
    // 다크모드 지원 컬러
    static let yamLightGreen = Color("yamLightGreen")
    static let yamSky = Color("yamSky")
    static let yamBlue = Color("yamBlue")
    static let yamDarkBlue = Color("yamDarkBlue")
    static let yamLightGray = Color("yamGray")
    static let yamWhite = Color("yamWhite")
    static let yamBlack = Color("yamBlack")
    static let yamRealDarkPoint = Color("yamRealDarkPoint")
    
    // 불변 컬러
    static let realWhite = Color("realWhite")
}

extension UIColor {
    static let yamLightGreen = UIColor(named: "yamLightGreen")
    static let yamSky = UIColor(named: "yamSky")
    static let yamBlue = UIColor(named: "yamBlue")
    static let yamDarkBlue = UIColor(named: "yamDarkBlue")
    static let yamLightGray = UIColor(named: "yamGray")
    static let yamWhite = UIColor(named: "yamWhite")
    static let yamBlack = UIColor(named: "yamBlack")
    
    static let yamRealDarkPoint = UIColor(named: "yamRealDarkPoint")
    static let realWhite = UIColor(named: "realWhite")
}
