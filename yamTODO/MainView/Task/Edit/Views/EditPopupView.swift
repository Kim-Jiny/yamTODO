import Foundation
import SwiftUI
import RealmSwift

struct EditPopupView: View {
    @ObservedObject var userColor: UserColorObject
    @Environment(\.colorScheme) var colorScheme
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
                    Text("Register a task")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(userColor.userColorData.selectedColor.mainColor.toColor())
                        .multilineTextAlignment(.leading)
                        .frame(width: 200, height: 40)
//                        .background(.white)
//                        .cornerRadius(25)
                    
                    HStack(spacing: 0) {
                        Spacer()
                            .frame(width: 8)
                        Image(systemName: "pencil.line")
                            .resizable()
                            .frame(width: 16, height: 15)
//                            .aspectRatio(contentMode: .fill)
                            .foregroundColor(userColor.userColorData.selectedColor.mainColor.toColor())
                        TextField("Please create a task.", text: $taskTitle)
                            .padding()
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    
                    DetailTextView(
                        userColor: userColor,
                        text: $taskDesc,
                        height: $taskDescHeight,
                        borderColor: userColor.userColorData.selectedColor.mainColor.toColor(),
                        backgroundColor: colorScheme == .light ? userColor.userColorData.selectedColor.lightColor.toColor() : userColor.userColorData.selectedColor.darkColor.toColor(),
                        maxHeight: 200,
                        textFont: .systemFont(ofSize: 13),
                        cornerRadius: 8,
                        borderWidth: 0,
                        placeholder: String(localized:"You can enter a detailed description for the task.")
                    )
                    .lineLimit(10)
                    .cornerRadius(8)
                    .frame(height: 100)
                    
                    HStack(spacing: 0) {
//                        Image(systemName: "repeat")
//                            .resizable()
//                            .frame(width: 15, height: 15)
//                            .aspectRatio(contentMode: .fill)
//                            .foregroundColor(.yamBlue)
                        RepeatView(userColor: userColor, selectedDays: $dayOfWeekManager.selectedDays )
                    }
                    
                    if dayOfWeekManager.selectedDays.count > 0 {
                        Text("Recurring tasks can only be registered from today onwards.")
                            .font(.system(size: 10))
                    }
                    
                    HStack {
                        Button(action: {
                            if !taskTitle.isEmpty {
                                createTask()
                            }
                        }, label: {
                            Text("Save")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .foregroundColor(userColor.userColorData.selectedColor.mainColor.toColor())
                                .fontWeight(.bold)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(userColor.userColorData.selectedColor.mainColor.toColor(), lineWidth: 2) // 테두리 추가
                                )
                        })
                    }
                    .frame(height: 50)
                }
                .padding(.top, 8)
                .padding()
                .background(colorScheme == .light ? Color.yamWhite: Color.yamBlack)
                .cornerRadius(8)
                .frame(width: geometry.size.width - 70)
                .onTapGesture {
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(colorScheme == .light ? Color.yamBlack.opacity(0.2) : Color.yamWhite.opacity(0.2))
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
        
        taskList.createTask(new: newTask)
        self.taskTitle = ""
        self.isPresented = false
    }
}
