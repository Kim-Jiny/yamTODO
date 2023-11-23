//
//  ColorSettingMainView.swift
//  yamTODO
//
//  Created by Jiny on 11/23/23.
//

import Foundation
import SwiftUI

struct ColorSettingMainView: View {
    @StateObject var userColor = UserColorObject()
    
    @State var selectedColorIndex: Int? = nil
    @State var isShowSelectPopup: Bool = false
    @State var isDeleteActionVisible: Bool = false
    @State var offset: CGSize = CGSize()
    
    var body: some View {
        List {
            Button {
                self.isShowSelectPopup = true
            } label: {
                Image(systemName: "plus.app")
                    .foregroundColor(.yamBlue)
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            ForEach(userColor.userColorData.colors.indices, id: \.self) { index in
                ColorSettingCell(isChecked: selectedColorIndex == index, colorModel: userColor.userColorData.colors[index])
                    .frame(height: 50)
                    .onTapGesture {
                        selectedColorIndex = index
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button {
                                // 왼쪽으로 스와이프하여 삭제버튼을 볼 수 있다.
                                isDeleteActionVisible.toggle()
                            } label: {
                                Label("Delete", systemImage: "trash.circle")
                            }
                            .tint(.yamBlue)
                        }
            }
        }
        .listStyle(DefaultListStyle())
        .navigationBarTitle(Text("App Color Setting"))
    }
}
