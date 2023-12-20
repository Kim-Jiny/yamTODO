//
//  ColorEditView.swift
//  yamTODO
//
//  Created by Jiny on 11/28/23.
//

import Foundation
import SwiftUI

struct ColorEditView: View {
    @Binding var isPresented: Bool
    
    @EnvironmentObject var userColor: UserColorObject
    @Environment(\.colorScheme) var colorScheme
    @State var colorM: ColorSettingMainViewModel
    @State private var mainColor: Color = .yamBlue
    @State private var lightColor: Color = .yamSky
    @State private var darkColor: Color = .yamDarkBlue
    @State private var todayColor: Color = .yamLightGreen
    @State private var colorTitle: String = ""
    
    @State private var isShowDeleteAlert: Bool = false
    
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
                    .navigationTitle("To modify the color")
                    ScrollView {
                        VStack {
                            HStack {
                                Spacer()
                                ColorSelectCell(color: $mainColor)
                                ColorPicker(String(localized:"Select the main color"), selection: $mainColor, supportsOpacity: false)
                                    .padding()
                            }
                            HStack {
                                Spacer()
                                ColorSelectCell(color: $lightColor)
                                ColorPicker(String(localized:"Select the light color"), selection: $lightColor, supportsOpacity: false)
                                    .padding()
                            }
                            HStack {
                                Spacer()
                                ColorSelectCell(color: $darkColor)
                                ColorPicker(String(localized:"Select the dark color"), selection: $darkColor, supportsOpacity: false)
                                    .padding()
                            }
                            HStack {
                                Spacer()
                                ColorSelectCell(color: $todayColor)
                                ColorPicker(String(localized:"Select TodayColor"), selection: $todayColor, supportsOpacity: false)
                                    .padding()
                            }
                            Spacer()
                                .frame(height: 50)
                            HStack {
                                Button {
                                    // 진짜 지우겠냐는 알럿을 띄워주고 삭제
                                    isShowDeleteAlert = true
                                } label: {
                                    Text("Delete")
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                        .foregroundStyle(colorScheme == .light ? Color.realBlack : Color.realWhite)
                                        .padding()
                                        .frame(width: 150, height: 60)
                                        .background(colorScheme == .light ? userColor.userColorData.selectedColor.lightColor.toColor() : userColor.userColorData.selectedColor.darkColor.toColor())
                                        .cornerRadius(40)
                                }
                                .padding(.bottom, 50)
                                Button {
                                    saveColor()
                                } label: {
                                    Text("Save")
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                        .foregroundStyle(colorScheme == .light ? Color.realWhite : Color.realBlack)
                                        .padding()
                                        .frame(width: 150, height: 60)
                                        .background(colorScheme == .light ? userColor.userColorData.selectedColor.darkColor.toColor() : userColor.userColorData.selectedColor.lightColor.toColor())
                                        .cornerRadius(40)
                                }
                                .padding(.bottom, 50)
                            }
                        }
                        .alert(isPresented: $isShowDeleteAlert) {
                            Alert(
                                title: Text(""),
                                message: Text("Are you sure you want to delete?"),
                                primaryButton: .destructive(Text("Delete")) {
                                    deleteColor()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    }
                }
            }
        }
        .onAppear() {
            if let colorM = colorM.editSelectedColor {
                self.mainColor = colorM.mainColor.toColor()
                self.lightColor = colorM.lightColor.toColor()
                self.darkColor = colorM.darkColor.toColor()
                self.todayColor = colorM.todayColor.toColor()
                self.colorTitle = colorM.colorTitle
            }
        }
    }
}


extension ColorEditView {
    private func saveColor() {
        if let colorM = colorM.editSelectedColor {
            let colorM = ColorModel(id: colorM.id,mainColor: .init(mainColor), darkColor: .init(darkColor), lightColor: .init(lightColor), todayColor: .init(todayColor), colorTitle: colorTitle == "" ? "New\(userColor.userColorData.colors.count)" : colorTitle)
            userColor.updateColor(colorM)
        }
        isPresented = false
    }
    
    
    private func deleteColor() {
        if let colorM = colorM.editSelectedColor {
            userColor.removeColor(id: colorM.id)
        }
        isPresented = false
    }
}
