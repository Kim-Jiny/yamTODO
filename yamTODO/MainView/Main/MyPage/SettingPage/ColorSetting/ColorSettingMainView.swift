//
//  ColorSettingMainView.swift
//  yamTODO
//
//  Created by Jiny on 11/23/23.
//

import Foundation
import SwiftUI

struct ColorSettingMainView: View {
    @ObservedObject var userColor: UserColorObject
    @State var isShowColorAddedView: Bool = false
    
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
                        .foregroundColor(.yamBlue)
                    Text("새 컬러 추가하기")
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
                        userColor.selectColor(color: colorM)
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        if colorM.id != "defaultColorModel" {
                            Button {
                                userColor.removeColor(id: colorM.id)
                            } label: {
                                Label("Delete", systemImage: "trash.circle")
                            }
                            .tint(.yamBlue)
                        }
                    }
            }
        }
        .listStyle(DefaultListStyle())
        .navigationBarTitle(Text("App Color Setting"))
        .onReceive(userColor.userColorData.objectWillChange) { data in
            self.userColor.id = ""
        }
        .onReceive(userColor.userColorData.selectedChange) { data in
            self.userColor.id = ""
        }
    }
}
