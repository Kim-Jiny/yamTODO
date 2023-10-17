//
//  Extension+View.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/17.
//

import SwiftUI
import Foundation
extension View {
//  func onWillDisappear(_ perform: @escaping () -> Void) -> some View {
//    self.modifier(WillDisappearModifier(callback: perform))
//  }
  
  func yamNavigationBar<C, L, R>(
    centerView: @escaping (() -> C),
    leftView: @escaping (() -> L),
    rightView: @escaping (() -> R)
  ) -> some View where C: View, L: View, R: View {
    modifier(YamNavigationModifier(centerView: centerView, leftView: leftView, rightView: rightView))
  }
}

