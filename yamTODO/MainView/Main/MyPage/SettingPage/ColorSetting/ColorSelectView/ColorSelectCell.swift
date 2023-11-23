//
//  ColorSettingCell.swift
//  yamTODO
//
//  Created by Jiny on 11/23/23.
//

import Foundation
import SwiftUI

struct ColorSelectCell: View {
    var color: ColorModel

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(color.color.toColor())
            .frame(width: 50, height: 50)
    }
    
    
}
