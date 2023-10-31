//
//  EditPopupView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/30.
//


import SwiftUI

struct EditPopupView: View {
  @Binding var isPresented: Bool
  @State private var selectedOption = 0
  @State private var textInput = ""
  
  let daysOfWeek = DayOfWeek.allCases
  @State private var selectedDays: Set<DayOfWeek> = []
  
  var body: some View {
//    ScrollView(.vertical) {
    ZStack {
      VStack {
        Text(" New Task")
        TextField("Title", text: $textInput)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
        HStack(spacing: 10) {
          ForEach(daysOfWeek, id: \.self) { day in
            Button(action: {
              if selectedDays.contains(day) {
                selectedDays.remove(day)
              } else {
                selectedDays.insert(day)
              }
            }, label: {
              Text(day.displayName)
                .frame(width: 20, height: 20)
                .padding(5)
                .overlay(
                  RoundedRectangle(cornerRadius: 15)
                    .stroke(selectedDays.contains(day) ? Color.blue : Color.clear, lineWidth: 2)
                )
            })
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(.primary)
            .font(.caption)
          }
        }
        .padding()
        Button {
          self.isPresented = false
        } label: {
          Text("Save")
        }

      }
      .padding()
      .background(Color.white)
      .cornerRadius(10)
//      .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    .background(Color.black.opacity(0.3))
  }
}


