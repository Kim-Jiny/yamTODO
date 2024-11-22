import SwiftUI

struct LargeWidgetView: View {
    let entry: SimpleEntry
    
    var body: some View {
        // 오늘 할 일과 내일 할 일을 처리하는 변수들
        let todayTasks = entry.tasksListModel.tasks.sorted { $0.isFixed && !$1.isFixed }
        let maxTodayTasks = 12
        let todayTasksToDisplay = todayTasks.prefix(maxTodayTasks)  // 오늘 할 일 14개로 제한
        
        // 내일 할 일은 남은 할 일만 표시
        let remainingTasksCount = maxTodayTasks - todayTasksToDisplay.count
        let tomorrowTasks = entry.tasksListModel.tasks.sorted { $0.isFixed && !$1.isFixed }
        let tomorrowTasksToDisplay = remainingTasksCount > 0 ? tomorrowTasks.prefix(remainingTasksCount) : [] // 오늘 할 일이 14개면 내일 할 일은 안 표시
        
        return VStack(spacing: 0) {
            // 상단 HStack: 오늘 날짜와 할 일
            HStack(alignment: .top, spacing: 8) {
                // 좌측: 오늘 날짜
                VStack(alignment: .center, spacing: 0) {
                    // 월, 연도 (작은 글씨)
                    Text(getMonthYearText(for: entry.date))
                        .font(.caption)
                        .foregroundColor(.primaryText)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    // 날짜 (큰 글씨)
                    Text(getDateText(for: entry.date))
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.softWhite) // 큰 글씨는 흰색
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    
                }
                .padding(.top, 4)
                .padding(.bottom, 4)
                .background(Color.soBlack)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.backgroundGray, lineWidth: 2) // 테두리 스타일
                )
                .frame(maxWidth: 80, maxHeight: .infinity, alignment: .top)
                
                // 우측: 오늘 할 일
                VStack(alignment: .leading, spacing: 2) {
                    if todayTasksToDisplay.isEmpty {
                        Text("No tasks today!")
                            .font(.headline)
                            .foregroundColor(.primaryText)
                    } else {
                        ForEach(todayTasksToDisplay, id: \.id) { task in
                            HStack {
                                Image("YamIcon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 8, height: 8)
                                
                                if task.isFixed {
                                    // `isFixed`가 true일 때 볼드체 적용
                                    Text(task.title.isEmpty ? task.desc : task.title)
                                        .font(.caption)
                                        .fontWeight(.bold) // 볼드체 적용
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                        .foregroundColor(.softWhite) // 텍스트 색상 흰색
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                } else {
                                    Text(task.title.isEmpty ? task.desc : task.title)
                                        .font(.caption)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                        .foregroundColor(.softWhite) // 텍스트 색상 흰색
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                }
                            }
                        }
                    }
                    Spacer()  // 여백을 추가하여 할일을 상단에 배치
                }
                .frame(maxWidth: .infinity, alignment: .top) // 할 일 목록을 상단 정렬
            }
            
            // 하단 HStack: 내일 날짜와 할 일 (오늘 할 일이 다 표시된 후 내일은 표시 안함)
            if remainingTasksCount > 0 || !tomorrowTasksToDisplay.isEmpty {
                HStack(alignment: .top, spacing: 8) {
                    // 좌측: 내일 날짜
                    VStack(alignment: .center, spacing: 0) {
                        // 월, 연도 (작은 글씨)
                        Text(getMonthYearText(for: Calendar.current.date(byAdding: .day, value: 1, to: entry.date)!))
                            .font(.caption)
                            .foregroundColor(.primaryText)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // 날짜 (큰 글씨)
                        Text(getDateText(for: Calendar.current.date(byAdding: .day, value: 1, to: entry.date)!))
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.softWhite) // 큰 글씨는 흰색
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                    }
                    .padding(.top, 4)
                    .padding(.bottom, 4)
                    .background(Color.soBlack)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.backgroundGray, lineWidth: 2) // 테두리 스타일
                    )
                    .frame(maxWidth: 80, maxHeight: .infinity, alignment: .top)
                    
                    // 우측: 내일 할 일
                    VStack(alignment: .leading, spacing: 2) {
                        if tomorrowTasksToDisplay.isEmpty {
                            Text("No tasks tomorrow!")
                                .font(.headline)
                                .foregroundColor(.primaryText)
                        } else {
                            ForEach(tomorrowTasksToDisplay, id: \.id) { task in
                                HStack {
                                    Image("YamIcon")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 8, height: 8)
                                    
                                    if task.isFixed {
                                        // `isFixed`가 true일 때 볼드체 적용
                                        Text(task.title.isEmpty ? task.desc : task.title)
                                            .font(.caption)
                                            .fontWeight(.bold) // 볼드체 적용
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                            .foregroundColor(.softWhite) // 텍스트 색상 흰색
                                            .frame(maxWidth: .infinity, alignment: .leading)

                                    } else {
                                        Text(task.title.isEmpty ? task.desc : task.title)
                                            .font(.caption)
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                            .foregroundColor(.softWhite) // 텍스트 색상 흰색
                                            .frame(maxWidth: .infinity, alignment: .leading)

                                    }
                                }
                            }
                        }
                        Spacer()  // 여백을 추가하여 할일을 상단에 배치
                    }
                    .frame(maxWidth: .infinity, alignment: .top) // 내일 할 일 목록도 상단 정렬
                }
            }
        }
    }

    // 월, 연도 텍스트 생성
    private func getMonthYearText(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM yyyy" // 월과 연도 포맷
        return formatter.string(from: date)
    }
    
    // 날짜 텍스트 생성
    private func getDateText(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd" // 날짜 포맷
        return formatter.string(from: date)
    }
}
