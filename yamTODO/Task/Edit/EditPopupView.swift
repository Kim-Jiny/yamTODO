//
//  EditPopupView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/30.
//


import SwiftUI

struct EditPopupView: View {
  @EnvironmentObject var userData: UserData
  @Binding var isPresented: Bool
  @State private var isKeyboardVisible = false
  
  @State private var taskTitle = ""
  @State private var taskDesc = ""
    @State private var taskDescHeight: CGFloat = 50
  
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
              TextField("Enter task", text: $taskTitle)
                .padding()
                .textFieldStyle(PlainTextFieldStyle())
            }
//            TextField("Enter task Detail ..", text: $taskDesc)
//              .textFieldStyle(RoundedBorderTextFieldStyle())
              DetailTextView(
                      text: $taskDesc,
                      height: $taskDescHeight,
                      maxHeight: 200,
                      textFont: .boldSystemFont(ofSize: 14),
                      cornerRadius: 8,
                      borderWidth: 2,
                      borderColor: UIColor.yamBlue.cgColor,
                      placeholder: "Enter task Detail .."
                    )
//              .padding()
              .lineLimit(10)
              .cornerRadius(8)
              .frame(height: 100)
            HStack(spacing: 0) {
              Image(systemName: "repeat")
                .resizable()
                .frame(width: 22, height: 20)
                .aspectRatio(contentMode: .fill)
                .foregroundColor(.yamBlue)
              RepeatView(selectedDays: $dayOfWeekManager.selectedDays)
            }
                HStack {
                    Button(action: {
                      if !taskTitle.isEmpty {
                        createTask()
                      }
                    }, label: {
                        Text("Save")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(.yamBlue)
                        .fontWeight(.bold)
                        .padding()
                    })
                }
                .frame(height: 50)
          }
          .padding(.top, 20)
          .padding()
          .background(Color.white)
          .cornerRadius(10)
          .frame(width: geometry.size.width - 70)
          .onTapGesture {
            
          }
          NewTaskView()
            .offset(y: -150)
          
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.black.opacity(0.3))
        .onTapGesture {
          if self.isKeyboardVisible {
            // 키보드가 열려있으면 닫아주기
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
          }else {
            // 키보드가 닫혀있으면 창을 닫아주기 
            self.isPresented = false
          }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                self.isKeyboardVisible = true
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { notification in
                self.isKeyboardVisible = false
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self)
        }
      }
  }
  
  private func createTask() {
    var newTask = Task(title: self.taskTitle)
    newTask.optionType = dayOfWeekManager.selectedDayIndices
    self.userData.tasks.insert(newTask, at: 0)
    self.taskTitle = ""
    self.isPresented = false
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
