import Foundation
import SwiftUI
import RealmSwift

struct EditPopupView: View {
    @EnvironmentObject var taskList: TaskList
    @State var selectedDate: Date
    @Binding var isPresented: Bool
    @State private var isKeyboardVisible = false
    
    @State private var taskTitle = ""
    @State private var taskDesc = ""
    @State private var taskDescHeight: CGFloat = 50
    @StateObject var dayOfWeekManager = DayOfWeekManager()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    Text("할 일 등록")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.yamBlue)
                        .multilineTextAlignment(.leading)
                        .frame(width: 200, height: 40)
//                        .background(.white)
//                        .cornerRadius(25)
                    
                    HStack(spacing: 0) {
                        Image(systemName: "pencil.line")
                            .resizable()
                            .frame(width: 22, height: 20)
                            .aspectRatio(contentMode: .fill)
                            .foregroundColor(.yamBlue)
                        TextField("할 일을 작성해주세요.", text: $taskTitle)
                            .padding()
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    
                    DetailTextView(
                        text: $taskDesc,
                        height: $taskDescHeight,
                        maxHeight: 200,
                        textFont: .systemFont(ofSize: 13),
                        cornerRadius: 8,
                        borderWidth: 0,
                        borderColor: UIColor.yamBlue!.cgColor,
                        placeholder: "할 일에 대한 세부 설명을 입력할 수 있습니다."
                    )
                    .lineLimit(10)
                    .cornerRadius(8)
                    .frame(height: 100)
                    
                    HStack(spacing: 0) {
                        Image(systemName: "repeat")
                            .resizable()
                            .frame(width: 22, height: 20)
                            .aspectRatio(contentMode: .fill)
                            .foregroundColor(.yamBlue)
                        RepeatView(selectedDays: $dayOfWeekManager.selectedDays )
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
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.yamBlue, lineWidth: 2) // 테두리 추가
                                )
                        })
                    }
                    .frame(height: 50)
                }
                .padding(.top, 8)
                .padding()
                .background(Color.yamWhite)
                .cornerRadius(8)
                .frame(width: geometry.size.width - 70)
                .onTapGesture {
                    // 뷰 탭에 대한 추가 액션
                }
//                NewTaskView()
//                    .offset(y: -150)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(Color.yamBlack.opacity(0.2))
            .onTapGesture {
                if self.isKeyboardVisible {
                    // 키보드가 열려있으면 닫아주기
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                } else {
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
}

extension EditPopupView {
    private func createTask() {
        let newTask = TaskObject(title: self.taskTitle)
        newTask.desc = self.taskDesc
        newTask.date = self.selectedDate
        Array(self.dayOfWeekManager.selectedDays.map({ $0.index })).forEach { val in
            newTask.optionType.append(val)
        }
        RealmManager.shared.addTask(date: taskList.date, new: newTask)
        taskList.updateTasks()
//        taskList.tasksObject.insert(newTask, at: 0)
        self.taskTitle = ""
        self.isPresented = false
    }
}
