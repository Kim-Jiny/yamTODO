//
//  RepeatDetailPopupView.swift
//  yamTODO
//
//  Created by Jiny on 2023/11/18.
//


import SwiftUI

struct RepeatDetailPopupView: View {
    // 가로모드인지 확인하는 코드
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @ObservedObject var userColor: UserColorObject
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var taskList: TaskList
    @Binding var selectedTask: SelectedTask
    @Binding var isPresented: Bool
    
    @State private var isKeyboardVisible = false
    @State private var isShowDeleteAlert = false
    @State private var isShowChangedAlert = false

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
                maxHeight: supportLandscape(geometry),
                textFont: .boldSystemFont(ofSize: 15),
                cornerRadius: 0,
                borderWidth: 0,
                borderColor: UIColor(userColor.userColorData.selectedColor.mainColor.toColor()).cgColor,
                placeholder: String(localized: "Untitled")
              )
                .frame(height: taskTitleHeight)
              DetailTextView(
                userColor: userColor,
                      text: $taskDesc,
                      height: $taskDescHeight,
                borderColor: userColor.userColorData.selectedColor.mainColor.toColor(),
                backgroundColor: colorScheme == .light ? userColor.userColorData.selectedColor.lightColor.toColor() : userColor.userColorData.selectedColor.darkColor.toColor(),
                      maxHeight: supportLandscape(geometry),
                      textFont: .systemFont(ofSize: 13),
                      cornerRadius: 8,
                      borderWidth: 2,
                      placeholder: String(localized:"You can enter a detailed description for the task.")
                    )
              .lineLimit(10)
              .cornerRadius(8)
              .frame(height: taskDescHeight)
//              HStack(spacing: 0) {
              RepeatView(userColor: userColor, selectedDays: $dayOfWeekManager.selectedDays, isEditRepeatOption: true)
              Text("You cannot change the day of the week setting for the recurring task.")
                  .font(.system(size: 10))
//              }
            HStack {
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    isShowDeleteAlert.toggle()
                }, label: {
                    Text("Delete")
                        .foregroundColor(colorScheme == .light ? userColor.userColorData.selectedColor.darkColor.toColor() : userColor.userColorData.selectedColor.lightColor.toColor())
                    .fontWeight(.bold)
                    .padding()
                }).alert(isPresented: $isShowDeleteAlert) {
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
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    if !taskTitle.isEmpty || !taskDesc.isEmpty {
                        isShowChangedAlert.toggle()
                    }else {
                        isShowDeleteAlert.toggle()
                    }
                }, label: {
                    Text("Edit")
                    .foregroundColor(userColor.userColorData.selectedColor.mainColor.toColor())
                    .fontWeight(.bold)
                    .padding()
                }).alert(isPresented: $isShowChangedAlert) {
                    Alert(
                        title: Text(""),
                        message: Text("Changes will be applied only to schedules that have not been modified by the user during the schedule after today."),
                        primaryButton: .destructive(Text("OK")) {
                            // 삭제 버튼을 눌렀을 때 수행할 액션
                            saveTask()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .frame(height: 50)
          }
          .padding(.top, 8)
          .padding()
          .background(colorScheme == .light ? Color.realWhite: Color.realBlack)
          .cornerRadius(10)
          .frame(width: geometry.size.width - 70)
          .onTapGesture {
            
          }
          
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(colorScheme == .light ? Color.yamBlack.opacity(0.2) : Color.realWhite.opacity(0.2))
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
    
    private func supportLandscape(_ screenSize: GeometryProxy) -> CGFloat {
        if horizontalSizeClass == .compact && verticalSizeClass == .regular {
            //세로 일때
            return 200
        }else {
            //가로일때
            return (screenSize.size.height - 400 / 2)
        }
    }
    
    private func saveTask() {
        selectedTask.updateText(self.taskTitle, self.taskDesc, true)
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

