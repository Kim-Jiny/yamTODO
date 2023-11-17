//
//  CalenderView.swift
//  yamTODO
//
//  Created by Jiny on 2023/10/16.
//

import SwiftUI

struct CalendarView: View {
    @Binding var selectedMonth: Date
    @Binding var selectedDate: Date
    @State var offset: CGSize = CGSize()
  
  var body: some View {
    VStack {
      headerView
      calendarGridView
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
  }
  
  // MARK: - 헤더 뷰
  private var headerView: some View {
    VStack {
      HStack {
        yearMonthView
        
        Spacer()
        
        Button(
          action: { },
          label: {
            Image(systemName: "list.bullet")
              .font(.title)
              .foregroundColor(.black)
          }
        )
      }
      .padding(.horizontal, 10)
      .padding(.bottom, 5)
      
      HStack {
        ForEach(Self.weekdaySymbols.indices, id: \.self) { symbol in
          Text(Self.weekdaySymbols[symbol].uppercased())
            .foregroundColor(.gray)
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
            .foregroundColor(canMoveToPreviousMonth() ? .black : . gray)
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
            .foregroundColor(canMoveToNextMonth() ? .black : .gray)
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
            
            CellView(day: day, clicked: clicked, isToday: isToday)
          } else if let prevMonthDate = Calendar.current.date(
            byAdding: .day,
            value: index + lastDayOfMonthBefore,
            to: previousMonth()
          ) {
            let day = Calendar.current.component(.day, from: prevMonthDate)
            
            CellView(day: day, isCurrentMonthDay: false)
          }
        }
        .onTapGesture {
          if 0 <= index && index < daysInMonth {
            let date = getDate(for: index)
              selectedDate = date
              print(Calendar.current.component(.weekday, from: selectedDate))
          }
        }
      }
    }
  }
}

// MARK: - 일자 셀 뷰
private struct CellView: View {
  private var day: Int
  private var clicked: Bool
  private var isToday: Bool
  private var isCurrentMonthDay: Bool
  private var textColor: Color {
    if clicked {
      return Color.white
    } else if isCurrentMonthDay {
      return Color.black
    } else {
      return Color.gray
    }
  }
  private var backgroundColor: Color {
    if clicked {
      return Color.black
    } else if isToday {
      return Color.yamLightGreen
    } else {
      return Color.white
    }
  }
  
  fileprivate init(
    day: Int,
    clicked: Bool = false,
    isToday: Bool = false,
    isCurrentMonthDay: Bool = true
  ) {
    self.day = day
    self.clicked = clicked
    self.isToday = isToday
    self.isCurrentMonthDay = isCurrentMonthDay
  }
  
  fileprivate var body: some View {
    VStack {
      Circle()
        .fill(backgroundColor)
        .overlay(Text(String(day)))
        .foregroundColor(textColor)
      
      Spacer()
      
      if clicked {
        RoundedRectangle(cornerRadius: 10)
          .fill(.red)
          .frame(width: 10, height: 10)
      } else {
        Spacer()
          .frame(height: 10)
      }
    }
    .frame(height: 50)
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
  
  /// 이전 월 마지막 일자
  func previousMonth() -> Date {
    let components = Calendar.current.dateComponents([.year, .month], from: selectedMonth)
    let firstDayOfMonth = Calendar.current.date(from: components)!
    let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: firstDayOfMonth)!
    
    return previousMonth
  }
  
  /// 월 변경
  func changeMonth(by value: Int) {
    self.selectedMonth = adjustedMonth(by: value)
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
}
