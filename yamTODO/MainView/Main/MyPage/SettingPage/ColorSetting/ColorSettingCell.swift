//
//  ColorSettingCell.swift
//  yamTODO
//
//  Created by Jiny on 11/23/23.
//

import Foundation
import SwiftUI

struct ColorSettingCell: View {
    @ObservedObject var userColor: UserColorObject
    let isChecked: Bool
    let colorModel: ColorModel

    var body: some View {
        HStack {
            HStack (spacing: 0) {
                // list 의 언더라인이 끊기는 문제를 해결하기위해
                Text("")
                    .frame(maxWidth: 0)
                ColorTriangleView(length: 40, firstColor: colorModel.mainColor.toColor(), secondColor: colorModel.lightColor.toColor())
                    .frame(width: 40, height: 40)
                    .cornerRadius(8)
                    .padding()
            }

            Text(colorModel.colorTitle)
                .foregroundColor(.yamBlack)
                .padding(.trailing, 8)
            Spacer()

            Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(isChecked ? userColor.userColorData.selectedColor.mainColor.toColor() : .gray)
                .padding(.trailing, 10)
//                .onTapGesture {
//                    isChecked.toggle()
//                }
        }
    }
}
