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
            }
        }
        .listStyle(DefaultListStyle())
        .navigationBarTitle(Text("App Color Setting"))
    }
}
