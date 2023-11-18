//
//  EditPopupView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/30.
//


import SwiftUI

struct DetailPopupView: View {
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
                borderColor: UIColor.yamBlue!.cgColor,
                placeholder: "공백으로 남기면 Task가 삭제됩니다."
              )
                .frame(maxHeight: taskTitleHeight)
              DetailTextView(
                      text: $taskDesc,
                      height: $taskDescHeight,
                      maxHeight: 200,
                      textFont: .systemFont(ofSize: 13),
                      cornerRadius: 8,
                      borderWidth: 2,
                      borderColor: UIColor.yamBlue!.cgColor,
                      placeholder: "할 일에 대한 세부 설명을 입력할 수 있습니다."
                    )
              .lineLimit(10)
              .cornerRadius(8)
              .frame(height: taskDescHeight)
            HStack {
                Spacer()
                Button("삭제") {
                    showDeleteAlert.toggle()
                }
                .alert(isPresented: $showDeleteAlert) {
                    Alert(
                        title: Text(""),
                        message: Text("정말 삭제하시겠습니까?"),
                        primaryButton: .destructive(Text("삭제")) {
                            // 삭제 버튼을 눌렀을 때 수행할 액션
                            deleteTask()
                        },
                        secondaryButton: .cancel()
                    )
                }
                .foregroundColor(.yamDarkBlue)
                .fontWeight(.bold)
                Spacer()
                Button(action: {
                  if !taskTitle.isEmpty {
                    saveTask()
                  }
                }, label: {
                    Text("수정")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .foregroundColor(.yamBlue)
                    .fontWeight(.bold)
                    .padding()
                })
                Spacer()
                Button("하루 미루기") {
                    showDeleteAlert.toggle()
                }
                .alert(isPresented: $showDeleteAlert) {
                    Alert(
                        title: Text(""),
                        message: Text("정말 삭제하시겠습니까?"),
                        primaryButton: .destructive(Text("삭제")) {
                            // 삭제 버튼을 눌렀을 때 수행할 액션
                            deleteTask()
                        },
                        secondaryButton: .cancel()
                    )
                }
                .foregroundColor(.yamBlue)
                .fontWeight(.bold)
                Spacer()
            }
            .frame(height: 50)
          }
          .padding(.top, 8)
          .padding()
          .background(Color.yamWhite)
          .cornerRadius(10)
          .frame(width: UIScreen.main.bounds.size.width - 70)
          .onTapGesture {
            
          }
          
        }
        .frame(maxWidth: UIScreen.main.bounds.size.width, maxHeight: .infinity, alignment: .center)
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
    }
    
    private func deleteTask() {
        self.selectedTask.deleteSelectTask()
        self.isPresented = false
    }
}

