//
//  Extension+Color.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/17.
//

import SwiftUI

extension Color {
    // Hex 코드로 컬러치환
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
    
    static func myColor(lightMode: Color, darkMode: Color) -> Color {
        if UITraitCollection.current.userInterfaceStyle == .dark {
            return darkMode
        } else {
            return lightMode
        }
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
    static let yamLightGreen = Color.myColor(lightMode: .YamColor.yamGreen, darkMode: .YamColor.yamDarkPurple)
    static let yamSky = Color.myColor(lightMode: .YamColor.yamLightBlue, darkMode: .YamColor.yamDarkPurple)
    static let yamBlue = Color.myColor(lightMode: .YamColor.yamBlue, darkMode: .YamColor.yamPurple)
    static let yamDarkBlue = Color.myColor(lightMode: YamColor.yamDarkBlue, darkMode: YamColor.yamLightPurple)
    static let yamLightGray = Color.myColor(lightMode: YamColor.gray, darkMode: YamColor.gray)
    static let yamWhite = Color.myColor(lightMode: YamColor.white, darkMode: YamColor.black)
    static let yamBlack = Color.myColor(lightMode: YamColor.black, darkMode: YamColor.white)
    static let yamRealDarkPoint = Color.myColor(lightMode: YamColor.yamDarkBlue, darkMode: YamColor.yamDarkPurple)
    
    // 불변 컬러
    static let realWhite = Color.myColor(lightMode: YamColor.white, darkMode: YamColor.white)
    
    private struct YamColor {
        static let white = Color(hex: "#F7F7F7")
        static let black = Color(hex: "#061013")
        static let gray = Color(hex: "#EDEBF1")
        
        static let yamPurple = Color(hex: "#9487AF")
        static let yamDarkPurple = Color(hex: "#352656")
        static let yamLightPurple = Color(hex: "#B7AFCA")
        
        static let yamBlue = Color(hex: "#3CA0C7")
        static let yamDarkBlue = Color(hex: "#246077")
        static let yamLightBlue = Color(hex: "#D8ECF3")
        
        static let yamGreen = Color(hex: "#3CC7A9")
    }
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
