//
//  CalenderView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/16.
//

import SwiftUI
import RealmSwift
import Combine

struct CalendarView: View {
    @ObservedObject var userColor: UserColorObject
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var monthDataList: TasksByMonthListModel
    @ObservedObject var taskList: TaskList
    @Binding var selectedMonth: Date
    @Binding var selectedDate: Date
    @State var offset: CGSize = CGSize()
  
  var body: some View {
    VStack {
      headerView
      calendarGridView
            .animation(nil)
    }
    .gesture(
      DragGesture()
        .onChanged { gesture in
          self.offset = gesture.translation
        }
        .onEnded { gesture in
          if gesture.translation.width < -100 {
            changeMonth(by: 1)
          } else if gesture.translation.width > 100 {
            changeMonth(by: -1)
          }
          self.offset = CGSize()
        }
      
    )
      
    .animation(.easeOut, value: offset)
    .padding(.leading, 30)
    .padding(.trailing, 30)
    .onReceive(taskList.objectWillChange, perform: { _ in
        monthDataList.date = monthDataList.date
    })
  }
  
  // MARK: - 헤더 뷰
  private var headerView: some View {
    VStack {
      HStack {
        yearMonthView
        
        Spacer()
        // 연도 선택버튼 임의삭제
//        Button(
//          action: { },
//          label: {
//            Image(systemName: "list.bullet")
//              .font(.title)
//              .foregroundColor(.black)
//          }
//        )
      }
      .padding(.horizontal, 10)
      .padding(.bottom, 5)
      
      HStack {
        ForEach(Self.weekdaySymbols.indices, id: \.self) { symbol in
          Text(Self.weekdaySymbols[symbol].uppercased())
                .foregroundColor(colorScheme == .light ? .realBlack : .realWhite)
            .font(.system(size: 13))
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
        }
      }
      .padding(.bottom, 5)
    }
  }
  
  // MARK: - 연월 표시
  private var yearMonthView: some View {
    HStack(alignment: .center, spacing: 20) {
      Button(
        action: {
          changeMonth(by: -1)
        },
        label: {
          Image(systemName: "chevron.left")
            .font(.title)
            .foregroundColor(canMoveToPreviousMonth() ? colorScheme == .light ? .realBlack : .realWhite : . gray)
        }
      )
      .disabled(!canMoveToPreviousMonth())
      
        Text(selectedMonth, formatter: Date.calendarDateFormatter)
        .font(.title.bold())
      
      Button(
        action: {
          changeMonth(by: 1)
        },
        label: {
          Image(systemName: "chevron.right")
            .font(.title)
            .foregroundColor(canMoveToNextMonth() ? colorScheme == .light ? .realBlack : .realWhite : .gray)
        }
      )
      .disabled(!canMoveToNextMonth())
    }
  }
  
  // MARK: - 날짜 그리드 뷰
  private var calendarGridView: some View {
    let daysInMonth: Int = numberOfDays(in: selectedMonth)
    let firstWeekday: Int = firstWeekdayOfMonth(in: selectedMonth) - 1
    let lastDayOfMonthBefore = numberOfDays(in: previousMonth())
    let numberOfRows = Int(ceil(Double(daysInMonth + firstWeekday) / 7.0))
    let visibleDaysOfNextMonth = numberOfRows * 7 - (daysInMonth + firstWeekday)
      
    return LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
      ForEach(-firstWeekday ..< daysInMonth + visibleDaysOfNextMonth, id: \.self) { index in
        Group {
          if index > -1 && index < daysInMonth {
            let date = getDate(for: index)
            let day = Calendar.current.component(.day, from: date)
            let clicked = selectedDate == date
              let isToday = date.formattedCalendarDayDate == Date.today.formattedCalendarDayDate
              let overToday = date > Date.today
        
              if let tasksByDate = monthDataList.days.first(where: { $0.key == date.dateKey }) {
                  //지워진 태스크들을 제외하고
                  let taskList = Array(tasksByDate.tasks).filter {
                      !$0.isRemove
                  }
                  // 태스크들이 있는경우.
                  if taskList.count > 0 {
                      // 아직 완료되지 않은 작업이 있는 경우
                      if let _ = taskList.first(where: { !$0.isDone }) {
                          // 완료작업이 아에 없는 경우 : red
                          if let _ = taskList.first(where: { $0.isDone }) {
                              CalendarCellView(userColor: userColor, day: day, clicked: clicked, isToday: isToday, isOverToday: overToday, isCurrentMonthDay: true, pointType: 2)
//                              pointType = .yellow
                          } else {
                              CalendarCellView(userColor: userColor, day: day, clicked: clicked, isToday: isToday, isOverToday: overToday, isCurrentMonthDay: true, pointType: 1)
//                              pointType = .red
                          }
                      } else {
                          // 모든 작업이 완료된 경우
                          CalendarCellView(userColor: userColor, day: day, clicked: clicked, isToday: isToday, isOverToday: overToday, isCurrentMonthDay: true, pointType: 3)
                      }
                      // Task가 없는 경우
                  } else {
                      CalendarCellView(userColor: userColor, day: day, clicked: clicked, isToday: isToday, isOverToday: overToday, isCurrentMonthDay: true, pointType: 0)
                  }
                  //MonthData가 없는경우
              }else {
                  CalendarCellView(userColor: userColor, day: day, clicked: clicked, isToday: isToday, isOverToday: overToday, isCurrentMonthDay: true, pointType: 0)
              }
            // 달력내에서 이번달이 아닌경우
          } else if let prevMonthDate = Calendar.current.date(
            byAdding: .day,
            value: index + lastDayOfMonthBefore,
            to: previousMonth()
          ) {
            let day = Calendar.current.component(.day, from: prevMonthDate)
            
              CalendarCellView(userColor: userColor, day: day, isCurrentMonthDay: false)
          }
        }
        .onTapGesture {
          if 0 <= index && index < daysInMonth {
            let date = getDate(for: index)
              selectedDate = date
          }
        }
      }
    }
  }
}


// MARK: - CalendarView Static 프로퍼티
private extension CalendarView {
    
  static let weekdaySymbols: [String] = Calendar.current.shortWeekdaySymbols
}

// MARK: - 내부 로직 메서드
private extension CalendarView {
  /// 특정 해당 날짜
  func getDate(for index: Int) -> Date {
    let calendar = Calendar.current
      
    guard let firstDayOfMonth = calendar.date(
      from: DateComponents(
        year: calendar.component(.year, from: selectedMonth),
        month: calendar.component(.month, from: selectedMonth),
        day: 1
      )
    ) else {
      return Date()
    }
    
    var dateComponents = DateComponents()
    dateComponents.day = index
    
    let timeZone = TimeZone.current
    let offset = Double(timeZone.secondsFromGMT(for: firstDayOfMonth))
    dateComponents.second = Int(offset)
    
    let date = calendar.date(byAdding: dateComponents, to: firstDayOfMonth) ?? Date()
    return date
  }
  
  /// 해당 월에 존재하는 일자 수
  func numberOfDays(in date: Date) -> Int {
    return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
  }
  
  /// 해당 월의 첫 날짜가 갖는 해당 주의 몇번째 요일
  func firstWeekdayOfMonth(in date: Date) -> Int {
    let components = Calendar.current.dateComponents([.year, .month], from: date)
    let firstDayOfMonth = Calendar.current.date(from: components)!
    
    return Calendar.current.component(.weekday, from: firstDayOfMonth)
  }
    
    /// 오늘 날짜의 처음 시작 시간
    func getStartTime(in date: Date) -> Date {
        // 현재 날짜의 연, 월, 일 구성 요소를 가져옵니다.
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        // 디바이스의 시간대 설정
        let deviceTimeZone = TimeZone.autoupdatingCurrent
        // 해당 연, 월, 일로 시작 시간을 설정합니다.
        if var startDate = Calendar.current.date(from: components) {
            startDate = Calendar.current.startOfDay(for: startDate) // 이것이 오늘 날짜의 시작 시간입니다.
            return startDate.addingTimeInterval(TimeInterval(deviceTimeZone.secondsFromGMT(for: startDate)))
        }
        
        return date
    }
  
  /// 이전 월 마지막 일자
  func previousMonth() -> Date {
    let components = Calendar.current.dateComponents([.year, .month], from: selectedMonth)
    let firstDayOfMonth = Calendar.current.date(from: components)!
    let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: firstDayOfMonth)!
    
    return previousMonth
  }
  
  /// 월 변경
  func changeMonth(by value: Int) {
      let selectedDate = adjustedMonth(by: value)
      self.monthDataList.date = selectedDate
      
      // 이번달로 변경시 오늘 날짜로 선택해줌.
      if isDateInCurrentMonth(dateToCheck: selectedDate) {
          self.selectedDate = getStartTime(in: Date())
      }else {
          let calendar = Calendar.current
          let components = calendar.dateComponents([.year, .month], from: selectedDate)
          let startOfMonth = calendar.date(from: components)!
          self.selectedDate = getStartTime(in: startOfMonth)
      }
      self.selectedMonth = selectedDate
  }
  
  /// 이전 월로 이동 가능한지 확인
  func canMoveToPreviousMonth() -> Bool {
    let currentDate = Date()
    let calendar = Calendar.current
    let targetDate = calendar.date(byAdding: .month, value: -3, to: currentDate) ?? currentDate
    
    if adjustedMonth(by: -1) < targetDate {
      return false
    }
    return true
  }
  
  /// 다음 월로 이동 가능한지 확인
  func canMoveToNextMonth() -> Bool {
    let currentDate = Date()
    let calendar = Calendar.current
    let targetDate = calendar.date(byAdding: .month, value: 3, to: currentDate) ?? currentDate
    
    if adjustedMonth(by: 1) > targetDate {
      return false
    }
    return true
  }
  
  /// 변경하려는 월 반환
  func adjustedMonth(by value: Int) -> Date {
    if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: selectedMonth) {
      return newMonth
    }
    return selectedMonth
  }
    /// 해당 날짜가 포함된 달인지 확인
    func isDateInCurrentMonth(dateToCheck: Date) -> Bool {
        let calendar = Calendar.current
        let currentDate = Date()

        let startOfMonthComponents = calendar.dateComponents([.year, .month], from: currentDate)
        guard let startOfMonth = calendar.date(from: startOfMonthComponents) else { return false }

        if let lastDateOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) {
            let dateInterval = DateInterval(start: startOfMonth, end: lastDateOfMonth)
            return dateInterval.contains(dateToCheck)
        }

        return false
    }
}
