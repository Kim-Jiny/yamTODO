//
//  ColorSettingView.swift
//  yamTODO
//
//  Created by Jiny on 11/22/23.
//

import Foundation
import SwiftUI

struct ColorSelectView: View {
    @Binding var isPresented: Bool
    
    @EnvironmentObject var userColor: UserColorObject
    @Environment(\.colorScheme) var colorScheme
    @State private var mainColor: Color = .yamBlue
    @State private var lightColor: Color = .yamSky
    @State private var darkColor: Color = .yamDarkBlue
    @State private var todayColor: Color = .yamLightGreen
    @State private var colorTitle: String = ""
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    ZStack {
                        TextField("Please write the name of the custom color", text: $colorTitle)
                            .padding()
                            .textFieldStyle(PlainTextFieldStyle())
                            .background(colorScheme == .light ? userColor.userColorData.selectedColor.lightColor.toColor() : userColor.userColorData.selectedColor.darkColor.toColor())
                            .cornerRadius(40)
                    }
                    .frame(width: geometry.size.width - 70, height: 80)
                    .navigationTitle("Add a new color")
                    ScrollView {
                        VStack {
                            HStack {
                                Spacer()
                                ColorSelectCell(color: mainColor)
                                ColorPicker(String(localized:"Select the main color"), selection: $mainColor, supportsOpacity: true)
                                    .padding()
                            }
                            HStack {
                                Spacer()
                                ColorSelectCell(color: lightColor)
                                ColorPicker(String(localized:"Select the light color"), selection: $lightColor, supportsOpacity: true)
                                    .padding()
                            }
                            HStack {
                                Spacer()
                                ColorSelectCell(color: darkColor)
                                ColorPicker(String(localized:"Select the dark color"), selection: $darkColor, supportsOpacity: true)
                                    .padding()
                            }
                            HStack {
                                Spacer()
                                ColorSelectCell(color: todayColor)
                                ColorPicker(String(localized:"Select TodayColor"), selection: $todayColor, supportsOpacity: true)
                                    .padding()
                            }
                            Spacer()
                                .frame(height: 50)
                            Button {
                                saveColor()
                            } label: {
                                Text("Add")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                    .foregroundStyle(colorScheme == .light ? Color.yamBlack : Color.yamWhite)
                                    .padding()
                                    .frame(width: 200, height: 60)
                                    .background(colorScheme == .light ? userColor.userColorData.selectedColor.lightColor.toColor() : userColor.userColorData.selectedColor.darkColor.toColor())
                                    .cornerRadius(40)
                            }
                            .padding(.bottom, 50)
                        }
                    }
                }
            }
//            .onTapGesture {
//                // 탭했을 때, 키보드가 열려있다면 닫습니다.
//                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//            }
        }
    }
}


extension ColorSelectView {
    private func saveColor() {
        let colorM = ColorModel(mainColor: .init(mainColor), darkColor: .init(darkColor), lightColor: .init(lightColor), todayColor: .init(todayColor), colorTitle: colorTitle == "" ? "New\(userColor.userColorData.colors.count)" : colorTitle)
        userColor.addColor(colorM)
        
        isPresented = false
    }
}
