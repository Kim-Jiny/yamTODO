import SwiftUI

struct MediumWidgetView: View {
    let entry: SimpleEntry

    var body: some View {
        HStack(spacing: 8) {
            // 좌측: To-Do 리스트
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image("YamIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                    Text("TODO List")
                        .font(.footnote)
                        .bold()
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                .padding(.bottom, 2)
                
                // `isFixed`가 true인 항목을 우선 표시
                let sortedTasks = entry.tasksListModel.tasks.sorted { $0.isFixed && !$1.isFixed }

                if sortedTasks.isEmpty {
                    Text("No tasks today!")
                        .font(.caption2)
                        .foregroundColor(.gray)
                } else {
                    ForEach(sortedTasks.prefix(5), id: \.id) { task in
                        if task.isFixed {
                            // `isFixed`가 true일 때 볼드체 적용
                            Text(task.title.isEmpty ? task.desc : task.title)
                                .font(.caption2)
                                .fontWeight(.bold) // 볼드체 적용
                                .lineLimit(1)
                                .truncationMode(.tail)
                        } else {
                            Text(task.title.isEmpty ? task.desc : task.title)
                                .font(.caption2)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 4)
            
            // 우측: 달력
            VStack {
                Text(getMonthYearText(for: entry.date))
                    .font(.footnote)
                    .bold()
                    .frame(maxWidth: .infinity)
                
                CalendarView(currentDate: entry.date)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.trailing, 4)
        }
        .padding(6)
    }

    private func getMonthYearText(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

struct CalendarView: View {
    let currentDate: Date
    let calendar = Calendar.current
    
    var body: some View {
        VStack(spacing: 4) {
            // 요일 헤더 (한 글자 표시)
            HStack(spacing: 1) {
                ForEach(calendar.veryShortWeekdaySymbols.indices, id: \.self) { index in
                    Text(calendar.veryShortWeekdaySymbols[index])
                        .font(.caption2)
                        .foregroundColor(index == 0 ? .red : (index == 6 ? .blue : .primary)) // 일요일은 빨간색, 토요일은 파란색으로 표시
                        .frame(maxWidth: .infinity)
                }
            }
            
            // 날짜 그리드
            let days = generateDaysInMonth(for: currentDate)
            let rows = days.chunked(into: 7)
            
            VStack(spacing: 1) {
                ForEach(rows, id: \.self) { row in
                    HStack(spacing: 1) {
                        ForEach(row.indices, id: \.self) { index in
                            let day = row[index]
                            Text(day == 0 ? "" : "\(day)")
                                .font(.system(size: 11))
                                .foregroundColor((index == 0 && day != calendar.component(.day, from: currentDate)) ? .red : (index == 6 && day != calendar.component(.day, from: currentDate) ? .blue : .primary)) // 일요일은 빨간색, 토요일은 파란색으로 표시
                                .frame(maxWidth: .infinity, maxHeight: 18)
                                .padding(2)
                                .background(day == calendar.component(.day, from: currentDate) ? ( index == 0 ? Color.red.opacity(0.4) : index == 6 ? Color.blue.opacity(0.4) : Color.green.opacity(0.4)) : Color.clear)
                                .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .background(Color.gray.opacity(0.05))
        .cornerRadius(4)
    }
    
    private func generateDaysInMonth(for date: Date) -> [Int] {
        let range = calendar.range(of: .day, in: .month, for: date)!
        let firstWeekday = calendar.component(.weekday, from: calendar.date(from: calendar.dateComponents([.year, .month], from: date))!) - 1
        let days = Array(range)
        
        return Array(repeating: 0, count: firstWeekday) + days
    }
}

// Helper extension
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}