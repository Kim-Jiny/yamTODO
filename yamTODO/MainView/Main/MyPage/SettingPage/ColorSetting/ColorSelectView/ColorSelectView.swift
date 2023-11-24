//
//  ColorSettingView.swift
//  yamTODO
//
//  Created by Jiny on 11/22/23.
//

import Foundation
import SwiftUI

struct ColorSelectView: View {
//    @ObservedObject var viewModel: ColorSelectViewModel
    @EnvironmentObject var userColor: UserColorObject
    @State private var selectedColor: Color = .red
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack {
            HStack {
                ColorPicker("Select Color", selection: $selectedColor, supportsOpacity: true)
                    .onChange(of: selectedColor) { _ in
                        userColor.addColor(selectedColor)
                    }
                    .padding()
            }
            ScrollView {
                VStack {
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(userColor.userColorData.colors.indices, id: \.self) { index in
                            let colorModel = userColor.userColorData.colors[index]
                            ColorSelectCell(color: colorModel)
                                .onTapGesture {
                                    userColor.selectColor(id: colorModel.id)
                                }
                                .border(colorModel.isSelected ? Color.blue : Color.clear, width: 2)
                        }
                    }
                    .padding()
                }
                .navigationBarTitle(Text("App Color Setting"))
            }
        }
    }
}
