//
//  EditPopupView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/30.
//

import SwiftUI

struct DetailPopupView: View {
    // 가로모드인지 확인하는 코드
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var userColor: UserColorObject
    @Binding var selectedTask: SelectedTask
    @Binding var isPresented: Bool
    
    @State private var isKeyboardVisible = false
    @State private var showDeleteAlert = false
    @State private var showDelayAlert = false

    @State private var taskTitle = ""
    @State private var taskTitleHeight: CGFloat = 50
    @State private var taskDesc = ""
    @State private var taskDescHeight: CGFloat = 90

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
                        placeholder: String(localized: "If left blank, the task will be deleted.")
                    )
                    .frame(maxHeight: taskTitleHeight)
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
                        placeholder: String(localized: "You can enter a detailed description for the task.")
                    )
                    .lineLimit(10)
                    .cornerRadius(8)
                    .frame(height: taskDescHeight)
                    
                    HStack {
                        Button(action: {
                            showDeleteAlert.toggle()
                        }, label: {
                            Text("Delete")
                                .foregroundColor(colorScheme == .light ? userColor.userColorData.selectedColor.darkColor.toColor() : userColor.userColorData.selectedColor.lightColor.toColor())
                                .font(.system(size: 13))
                                .padding()
                        }).alert(isPresented: $showDeleteAlert) {
                            Alert(
                                title: Text(""),
                                message: Text("Are you sure you want to delete?"),
                                primaryButton: .destructive(Text("Delete")) {
                                    deleteTask()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            if !taskTitle.isEmpty {
                                saveTask()
                            } else {
                                showDeleteAlert.toggle()
                            }
                        }, label: {
                            Text("Edit")
                                .foregroundColor(userColor.userColorData.selectedColor.mainColor.toColor())
                                .font(.system(size: 13))
                                .padding()
                        })
                        
                        Spacer()
                        
                        Button("Postpone for a day") {
                            showDelayAlert.toggle()
                        }
                        .alert(isPresented: $showDelayAlert) {
                            Alert(
                                title: Text(""),
                                message: Text("Would you like to postpone this task to tomorrow?"),
                                primaryButton: .destructive(Text("OK")) {
                                    delayTask()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                        .foregroundColor(userColor.userColorData.selectedColor.mainColor.toColor())
                        .font(.system(size: 13))
                    }
                    .frame(height: 50)
                }
                .padding(.top, 8)
                .padding()
                .background(colorScheme == .light ? Color.realWhite : Color.realBlack)
                .cornerRadius(10)
                .frame(width: geometry.size.width - 70)
                .onTapGesture {
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(colorScheme == .light ? Color.yamBlack.opacity(0.2) : Color.yamWhite.opacity(0.2))
            .onTapGesture {
                if self.isKeyboardVisible {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                } else {
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
        selectedTask.updateText(self.taskTitle, self.taskDesc)
        self.isPresented = false
    }
    
    private func setupTask() {
        self.taskTitle = selectedTask.selectedTask?.title ?? ""
        self.taskDesc = selectedTask.selectedTask?.desc ?? ""
    }
    
    private func deleteTask() {
        self.selectedTask.deleteSelectTask()
        self.isPresented = false
    }
    
    private func delayTask() {
        self.selectedTask.delaySelectTask()
        self.isPresented = false
    }
}
