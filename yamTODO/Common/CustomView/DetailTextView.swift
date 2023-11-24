//
//  DetailTextView.swift
//  yamTODO
//
//  Created by 김미진 on 11/4/23.
//

import Foundation
import SwiftUI

public struct DetailTextView: UIViewRepresentable {
    @ObservedObject var userColor: UserColorObject
    @Environment(\.colorScheme) var colorScheme
    @Binding var text: String
    @Binding var height: CGFloat
    @State var borderColor: Color
    @State var backgroundColor: Color
    var maxHeight: CGFloat
    var textFont: UIFont
    var textColor: UIColor = UIColor.yamBlack!
    var textLimit: Int = 500
    var cornerRadius: CGFloat? = nil
    var borderWidth: CGFloat? = nil
//    var borderColor: CGColor? = nil
    var isScrollEnabled: Bool = true
    var isEditable: Bool = true
    var isUserInteractionEnabled: Bool = true
    var lineFragmentPadding: CGFloat = 0
    var textContainerInset: UIEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
    var placeholder: String? = nil
    var placeholderColor: UIColor = .placeholderText
  
    public func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        
        if let cornerRadius = cornerRadius {
          textView.layer.cornerRadius = cornerRadius
          textView.layer.masksToBounds = true
        }
        if let borderWidth = borderWidth {
          textView.layer.borderWidth = borderWidth
        }
          textView.layer.borderColor = UIColor(borderColor).cgColor
        if let placeholder = placeholder, text == "" {
          textView.text = placeholder
          textView.textColor = placeholderColor
        } else {
            textView.text = text
          textView.textColor = textColor
        }
        
        textView.font = textFont
        textView.isScrollEnabled = isScrollEnabled
        textView.isEditable = isEditable
        textView.isUserInteractionEnabled = isUserInteractionEnabled
        textView.textContainer.lineFragmentPadding = lineFragmentPadding
        textView.textContainerInset = textContainerInset
        textView.delegate = context.coordinator
        textView.backgroundColor = UIColor(backgroundColor)
        
        if let placeholder = placeholder, text == "" {
            textView.text = placeholder
            textView.textColor = placeholderColor
        } else {
            textView.text = text
            textView.textColor = textColor
        }
        return textView
  }
  
  public func updateUIView(_ uiView: UITextView, context: Context) {
      if text != "" {
          uiView.text = text
          uiView.textColor = textColor
          updateHeight(uiView)
      }
  }
  
  public func makeCoordinator() -> Coordinator {
    return Coordinator(parent: self)
  }
  
  private func updateHeight(_ uiView: UITextView) {
    let size = uiView.sizeThatFits(CGSize(width: uiView.frame.width, height: .infinity))
    DispatchQueue.main.async {
      if size.height <= maxHeight {
        height = size.height
      }else if size.height > maxHeight {
          height = maxHeight
      }
    }
  }
  
  public class Coordinator: NSObject, UITextViewDelegate {
    var parent: DetailTextView
    
    init(parent: DetailTextView) {
      self.parent = parent
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        parent.text = textView.text
        
        if textView.text.isEmpty {
          textView.textColor = parent.placeholderColor
        } else {
          textView.textColor = parent.textColor
        }
        
        if textView.text.count > parent.textLimit {
          textView.text.removeLast()
        }
      
        parent.updateHeight(textView)
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
      if textView.text == parent.placeholder {
        textView.text = ""
      }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = parent.placeholder
            textView.textColor = parent.placeholderColor
        } else {
          textView.textColor = parent.textColor
        }
    }
  }
}
