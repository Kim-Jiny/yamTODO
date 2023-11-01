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
  
//  @EnvironmentObject private var selectedDays: DayOfWeekManager
  @StateObject var dayOfWeekManager = DayOfWeekManager()
  
  var body: some View {
    GeometryReader { geometry in
        ZStack {
          VStack {
            HStack(spacing: 0) {
              Image(systemName: "pencil.line")
                .resizable()
                .frame(width: 22, height: 20)
                .aspectRatio(contentMode: .fill)
                .foregroundColor(.yamBlue)
              TextField("Enter task details...", text: $textInput)
                .padding()
                .textFieldStyle(PlainTextFieldStyle())
              
            }
            .frame(height: 30)
            HStack(spacing: 0) {
              Image(systemName: "repeat")
                .resizable()
                .frame(width: 22, height: 20)
                .aspectRatio(contentMode: .fill)
                .foregroundColor(.yamBlue)
              RepeatView(selectedDays: $dayOfWeekManager.selectedDays)
            }
//            VStack(spacing: 0) {
//                Divider()
//                    .frame(width: geometry.size.width, height: 1, alignment: .top)
                HStack {
                    Button(action: {
                        self.isPresented = false
                    }, label: {
                        Text("Save")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(.yamBlue)
                        .fontWeight(.bold)
                        .padding()
                    })
                }
                .frame(height: 50)
//            }
//            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 51)
          }
          .padding(.top, 20)
          .padding()
          .background(Color.white)
          .cornerRadius(10)
          .frame(width: geometry.size.width - 70)
//          .onTapGesture {
//            //
//          }
          NewTaskView()
            .offset(y: -150)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.black.opacity(0.3))
        .onTapGesture {
//          self.isPresented = false
        }
      }
  }
}

struct NewTaskView: View {
  
  var body: some View {
//    ZStack {
      Text("New Task")
        .font(.title2)
        .fontWeight(.bold)
        .foregroundColor(.yamBlue)
        .multilineTextAlignment(.leading)
        .frame(width: 200, height: 50)
        .background(.white)
        .cornerRadius(25)
//    }
//    .background(.white)
  }
}

struct RepeatView: View {
  
  let daysOfWeek = DayOfWeek.allCases
  @Binding var selectedDays: Set<DayOfWeek>
  
  init(selectedDays: Binding<Set<DayOfWeek>>) {
    _selectedDays = selectedDays
  }
  
  var body: some View {
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
            .padding(2)
            .overlay(
              RoundedRectangle(cornerRadius: 15)
                .stroke(selectedDays.contains(day) ? Color.yamBlue : Color.clear, lineWidth: 2)
            )
        })
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(.primary)
        .font(.caption)
      }
    }
    .padding()
  }
}
