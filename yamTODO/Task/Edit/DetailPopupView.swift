//
//  EditPopupView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/30.
//


import SwiftUI

struct DetailPopupView: View {
  @EnvironmentObject var userData: UserData
  @EnvironmentObject var taskData: TaskData
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
            TextField("공백으로 남기면 Task가 삭제됩니다.", text: $taskTitle)
              .padding()
              .textFieldStyle(PlainTextFieldStyle())
//            HStack(spacing: 0) {
//              TextField("공백으로 남기면 Task가 삭제됩니다.", text: $taskTitle)
//                .padding()
//                .textFieldStyle(PlainTextFieldStyle())
//            }
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
              .lineLimit(10)
              .cornerRadius(8)
              .frame(height: 100)
            HStack {
                Button(action: {
                  if !taskTitle.isEmpty {
                    saveTask()
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
  
  private func saveTask() {
    var newTask = Task(title: self.taskTitle)
    newTask.optionType = dayOfWeekManager.selectedDayIndices
    self.userData.tasks.insert(newTask, at: 0)
    self.taskTitle = ""
    self.isPresented = false
  }
}

