//
//  TriangleView.swift
//  yamTODO
//
//  Created by Jiny on 11/23/23.
//

import Foundation
import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.closeSubpath()
        }
    }
}

struct ColorTriangleView: View {
    let length: CGFloat
    let firstColor: Color
    let secondColor: Color
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(firstColor)
                    .frame(width: length, height: length)

                Triangle()
                    .fill(secondColor)
                    .frame(width: length, height: length)

            }
        }
    }
}
