//
//  CalendarCell.swift
//  yamTODO
//
//  Created by 김미진 on 11/17/23.
//

import Foundation
import SwiftUI
import Combine

// MARK: - 일자 셀 뷰
struct CalendarCellView: View {
    @ObservedObject var monthDataList: TasksByMonthListModel
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
    
    init(
        monthDataList: TasksByMonthListModel,
        day: Int,
        clicked: Bool = false,
        isToday: Bool = false,
        isCurrentMonthDay: Bool = true
    ) {
        self.monthDataList = monthDataList
        self.day = day
        self.clicked = clicked
        self.isToday = isToday
        self.isCurrentMonthDay = isCurrentMonthDay
    }
    
    var body: some View {
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
