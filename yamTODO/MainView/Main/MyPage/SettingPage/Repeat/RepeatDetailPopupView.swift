//
//  RepeatDetailPopupView.swift
//  yamTODO
//
//  Created by Jiny on 2023/11/18.
//


import SwiftUI

struct RepeatDetailPopupView: View {
    @ObservedObject var userColor: UserColorObject
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var taskList: TaskList
    @Binding var selectedTask: SelectedTask
    @Binding var isPresented: Bool
    
    @State private var isKeyboardVisible = false
    @State private var showDeleteAlert = false

    @State private var taskTitle = ""
    @State private var taskTitleHeight: CGFloat = 50
    @State private var taskDesc = ""
    @State private var taskDescHeight: CGFloat = 50

    @StateObject var dayOfWeekManager = DayOfWeekManager()
  
  var body: some View {
    GeometryReader { geometry in
        ZStack {
          VStack {
              TitleTextView(
                text: $taskTitle,
                height: $taskTitleHeight,
                maxHeight: 200,
                textFont: .boldSystemFont(ofSize: 15),
                cornerRadius: 0,
                borderWidth: 0,
                borderColor: UIColor(userColor.userColorData.selectedColor.mainColor.toColor()).cgColor,
                placeholder: "공백으로 남기면 Task가 삭제됩니다."
              )
                .frame(maxHeight: taskTitleHeight)
              DetailTextView(
                userColor: userColor,
                      text: $taskDesc,
                      height: $taskDescHeight,
                borderColor: userColor.userColorData.selectedColor.mainColor.toColor(),
                backgroundColor: colorScheme == .light ? userColor.userColorData.selectedColor.lightColor.toColor() : userColor.userColorData.selectedColor.darkColor.toColor(),
                      maxHeight: 200,
                      textFont: .systemFont(ofSize: 13),
                      cornerRadius: 8,
                      borderWidth: 2,
                      placeholder: String(localized:"You can enter a detailed description for the task.")
                    )
              .lineLimit(10)
              .cornerRadius(8)
              .frame(height: taskDescHeight)
//              HStack(spacing: 0) {
                  RepeatView(userColor: userColor, selectedDays: $dayOfWeekManager.selectedDays )
//              }
            HStack {
                Button(action: {
                    showDeleteAlert.toggle()
                }, label: {
                    Text("Delete")
                        .foregroundColor(colorScheme == .light ? userColor.userColorData.selectedColor.darkColor.toColor() : userColor.userColorData.selectedColor.lightColor.toColor())
                    .fontWeight(.bold)
                    .padding()
                }).alert(isPresented: $showDeleteAlert) {
                    Alert(
                        title: Text(""),
                        message: Text("Are you sure you want to delete? Deleting will remove recurring events beyond today. Please remove tasks that have already been scheduled in the past from the calendar."),
                        primaryButton: .destructive(Text("Delete")) {
                            // 삭제 버튼을 눌렀을 때 수행할 액션
                            deleteTask()
                        },
                        secondaryButton: .cancel()
                    )
                }
                Button(action: {
                  if !taskTitle.isEmpty {
                    saveTask()
                  }
                }, label: {
                    Text("Edit")
                    .foregroundColor(userColor.userColorData.selectedColor.mainColor.toColor())
                    .fontWeight(.bold)
                    .padding()
                })
            }
            .frame(height: 50)
          }
          .padding(.top, 8)
          .padding()
          .background(colorScheme == .light ? Color.yamWhite: Color.yamBlack)
          .cornerRadius(10)
          .frame(width: geometry.size.width - 70)
          .onTapGesture {
            
          }
          
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.yamBlack.opacity(0.2))
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
            setupTask()
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
        selectedTask.updateText(self.taskTitle, self.taskDesc)
        // 닫기
        self.isPresented = false
    }
    
    private func setupTask() {
        self.taskTitle = selectedTask.selectedTask?.title ?? ""
        self.taskDesc = selectedTask.selectedTask?.desc ?? ""
        selectedTask.selectedTask?.optionType.forEach({ repeatType in
            self.dayOfWeekManager.toggleDay(repeatType.getRepeatType())
        })
    }
    
    private func deleteTask() {
        self.selectedTask.deleteSelectOptionTask()
        self.isPresented = false
    }
}

