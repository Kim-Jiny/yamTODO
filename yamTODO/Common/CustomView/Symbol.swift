//
//  Symbols.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/31.
//


import SwiftUI

struct Symbol: View {
  let systemName: String
  let imageScale: Image.Scale
  let color: Color?
  
  init(
    _ systemName: String,
    scale imageScale: Image.Scale = .medium,
    color: Color? = nil
  ) {
    self.systemName = systemName
    self.imageScale = imageScale
    self.color = color
  }
  
  var body: some View {
    Image(systemName: systemName)
      .imageScale(imageScale)
      .foregroundColor(color)
  }
}

