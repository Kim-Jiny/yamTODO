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
    @State private var mainColor: Color = .yamBlue
    @State private var lightColor: Color = .yamSky
    @State private var darkColor: Color = .yamDarkBlue
    @State private var todayColor: Color = .yamLightGreen
    @State private var colorTitle: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    TextField("커스텀 색상의 이름을 작성해 주세요", text: $colorTitle)
                        .padding()
                        .textFieldStyle(PlainTextFieldStyle())
                        .background(Color.yamSky)
                        .cornerRadius(40)
                }
                .frame(width: UIScreen.main.bounds.width - 70, height: 80)
                .navigationTitle("컬러 설정 추가하기")
                ScrollView {
                    VStack {
                        HStack {
                            Spacer()
                            ColorSelectCell(color: mainColor)
                            ColorPicker(String(localized:"Select MainColor"), selection: $mainColor, supportsOpacity: true)
                                .padding()
                        }
                        HStack {
                            Spacer()
                            ColorSelectCell(color: lightColor)
                            ColorPicker(String(localized:"Select lightColor"), selection: $lightColor, supportsOpacity: true)
                                .padding()
                        }
                        HStack {
                            Spacer()
                            ColorSelectCell(color: darkColor)
                            ColorPicker(String(localized:"Select darkColor"), selection: $darkColor, supportsOpacity: true)
                                .padding()
                        }
                        HStack {
                            Spacer()
                            ColorSelectCell(color: todayColor)
                            ColorPicker(String(localized:"Select todayColor"), selection: $todayColor, supportsOpacity: true)
                                .padding()
                        }
                    }
                }
                Button {
                    saveColor()
                } label: {
                    Text("Add")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(Color.yamBlack)
                        .padding()
                        .frame(width: 200, height: 60)
                        .background(Color.yamSky)
                        .cornerRadius(40)
                }
            }
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
