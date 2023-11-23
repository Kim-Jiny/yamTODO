//
//  ColorSettingView.swift
//  yamTODO
//
//  Created by Jiny on 11/22/23.
//

import Foundation
import SwiftUI

struct ColorSelectView: View {
    @ObservedObject var viewModel: ColorSelectViewModel
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
                Button("Delete Selected") {
                    viewModel.removeSelectedColor()
                }
                .disabled(viewModel.selectedColorIndex == nil)
                .padding()
                
                ColorPicker("Select Color", selection: $selectedColor, supportsOpacity: true)
                    .onChange(of: selectedColor) { _ in
                        viewModel.addColor(selectedColor)
                    }
                    .padding()
            }
            ScrollView {
                VStack {
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(viewModel.userColor.colors.indices, id: \.self) { index in
                            let colorModel = viewModel.userColor.colors[index]
                            ColorSelectCell(color: colorModel)
                                .onTapGesture {
                                    viewModel.selectColor(at: index)
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
