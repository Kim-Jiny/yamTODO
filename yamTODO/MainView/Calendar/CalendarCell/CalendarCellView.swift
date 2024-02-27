//
//  CalendarCell.swift
//  yamTODO
//
//  Created by 김미진 on 11/17/23.
//

import Foundation
import SwiftUI
import Combine

enum CalendarPointType {
    case green, yellow, red, notType
}

// MARK: - 일자 셀 뷰
struct CalendarCellView: View {
    @ObservedObject var userColor: UserColorObject
    @Environment(\.colorScheme) var colorScheme
//    @ObservedObject var monthDataList: TasksByMonthListModel
    private var day: Int
    private var clicked: Bool
    private var isToday: Bool
    private var isOverToday: Bool
    private var isCurrentMonthDay: Bool
    private var pointType: Int
    
    private var textColor: Color {
        if clicked {
            return colorScheme == .light ? Color.realWhite : Color.realBlack
        } else if isCurrentMonthDay {
            return colorScheme == .light ? Color.realBlack : Color.realWhite
        } else {
            return Color.gray
        }
    }
    
    private var backgroundColor: Color {
        if clicked {
            return colorScheme == .light ? Color.realBlack : Color.realWhite
        } else if isToday {
            return userColor.userColorData.selectedColor.todayColor.toColor()
        } else {
            return colorScheme == .light ? Color.realWhite : Color.realBlack
        }
    }
    
    private var pointColor: Color {
        if isToday || isOverToday {
            return Color.clear
        } else {
            switch pointType {
            case 3:
                return .green
            case 2:
                return .yellow
            case 1:
                return .red
            case 0:
                return .clear
            case 4:
                return .blue
            default:
                return .clear
            }
        }
    }
    
    init(
//        monthDataList: TasksByMonthListModel,
        userColor: UserColorObject,
        day: Int,
        clicked: Bool = false,
        isToday: Bool = false,
        isOverToday: Bool = false,
        isCurrentMonthDay: Bool = true,
        pointType: Int = 0
    ) {
//        self.monthDataList = monthDataList
        self.userColor = userColor
        self.day = day
        self.clicked = clicked
        self.isToday = isToday
        self.isOverToday = isOverToday
        self.isCurrentMonthDay = isCurrentMonthDay
        self.pointType = pointType
    }
    
    var body: some View {
        VStack {
            Circle()
                .fill(backgroundColor)
                .overlay(Text(String(day)))
                .foregroundColor(textColor)
                .overlay(
                        Circle()
                            .stroke(pointColor, lineWidth: 2) // 테두리 색상 및 두께 지정
//                            .overlay(Text(String(day)))
//                            .foregroundColor(textColor)
                    )
            Spacer()
                .frame(height: 5)
//            if clicked {
//                RoundedRectangle(cornerRadius: 10)
//                    .fill(Color.yamDarkBlue)
//                    .frame(width: 10, height: 10)
//            } else {
//                Spacer()
//                    .frame(height: 5)
//            }
        }
        .frame(height: 40)
    }
}
