//
//  ColorSettingMainView.swift
//  yamTODO
//
//  Created by Jiny on 11/23/23.
//

import Foundation
import SwiftUI
import Combine

class ColorSettingMainViewModel: ObservableObject {
    @Published var editSelectedColor: ColorModel?
    
}

struct ColorSettingMainView: View {
    @ObservedObject var userColor: UserColorObject
    @State var isShowColorAddedView: Bool = false
    @State var isShowColorEditView: Bool = false
    @ObservedObject var editSelectedColor = ColorSettingMainViewModel()
    
    @State var offset: CGSize = CGSize()
    
    var body: some View {
        List {
            Button {
                self.isShowColorAddedView = true
            } label: {
                HStack {
                        // list 의 언더라인이 끊기는 문제를 해결하기위해
                    Text("")
                        .frame(maxWidth: 0)
                    Spacer()
                    Image(systemName: "plus.app")
                        .foregroundColor(userColor.userColorData.selectedColor.mainColor.toColor())
                    Text("Add a new color")
                    Spacer()
                }
            }
            .frame(height: 50)
            .sheet(isPresented: $isShowColorAddedView) {
                ColorSelectView(isPresented: $isShowColorAddedView)
                    .environmentObject(userColor)
            }
            ForEach(userColor.userColorData.colors) { colorM in
                ColorSettingCell(userColor: userColor, isChecked: userColor.userColorData.selectedColor.id == colorM.id, colorModel: colorM)
                    .frame(height: 50)
                    .onTapGesture {
                        editSelectedColor.editSelectedColor = colorM
//                        isShowColorEditView = true
//                        userColor.selectColor(color: colorM)
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        if colorM.id != "defaultColorModel" {
                            Button {
                                userColor.removeColor(id: colorM.id)
                            } label: {
                                Label("Delete", systemImage: "trash.circle")
                            }
                            .tint(userColor.userColorData.selectedColor.mainColor.toColor())
                        }
                    }
            }
        }
        .sheet(isPresented: $isShowColorEditView) {
            ColorEditView(isPresented: $isShowColorEditView, colorM: editSelectedColor)
                .environmentObject(userColor)
        }
        .listStyle(DefaultListStyle())
        .navigationBarTitle(Text("App Color Setting"))
        .onReceive(userColor.userColorData.objectWillChange) { data in
            self.userColor.id = ""
        }
        .onReceive(userColor.userColorData.selectedChange) { data in
            self.userColor.id = ""
        }
        .onReceive(editSelectedColor.objectWillChange) { _ in
            if let _ = editSelectedColor.editSelectedColor {
                isShowColorEditView = true
            }
        }
    }
}
