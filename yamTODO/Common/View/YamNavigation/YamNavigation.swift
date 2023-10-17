//
//  YamNavigationModifier.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/17.
//

import SwiftUI

struct YamNavigationModifier<C, L, R>: ViewModifier where C: View, L: View, R: View {
  let centerView: (() -> C)?
  let leftView: (() -> L)?
  let rightView: (() -> R)?
  
  init(centerView: (() -> C)? = nil, leftView: (() -> L)? = nil, rightView: (() -> R)? = nil) {
    self.centerView = centerView
    self.leftView = leftView
    self.rightView = rightView
  }
  func body(content: Content) -> some View {
//    VStack {
//      ZStack {
//        HStack {
//          self.leftView?()
//          Spacer()
//          self.rightView?()
//        }
//        .frame(height: 44)
//        .frame(maxWidth: .infinity)
//        .padding(.horizontal, 16)
//        
//        HStack {
//          Spacer()
//          self.centerView?()
//          Spacer()
//        }
//      }
//      .background(Color.yamLightGreen).ignoresSafeArea(.all, edges: .top)
//      
//      content
//      
//      Spacer()
//    }
//    .navigationBarHidden(true)
  }
}
