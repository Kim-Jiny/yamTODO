//
//  ColorSettingMainView.swift
//  yamTODO
//
//  Created by Jiny on 11/23/23.
//

import Foundation
import SwiftUI

struct ColorSettingMainView: View {
    @ObservedObject var userColor = UserColorObject()
    
    @State var selectedColor: ColorModel? = nil
    @State var isShowColorAddedView: Bool = false
    
    @State var offset: CGSize = CGSize()
    
    var body: some View {
        List {
            Button {
                self.isShowColorAddedView = true
            } label: {
                HStack {
                    Image(systemName: "plus.app")
                        .foregroundColor(.yamBlue)
                    Text("새 컬러 추가하기")
                }
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .sheet(isPresented: $isShowColorAddedView) {
                ColorSelectView()
                    .environmentObject(userColor)
            }
            ForEach(userColor.userColorData.colors) { colorM in
                ColorSettingCell(isChecked: selectedColor?.id == colorM.id, colorModel: colorM)
                    .frame(height: 50)
                    .onTapGesture {
                        selectedColor = colorM
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
    }
}
