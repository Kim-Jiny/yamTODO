//
//  RepeatView.swift
//  yamTODO
//
//  Created by Jiny on 11/16/23.
//

import Foundation
import SwiftUI

struct RepeatView: View {
    let daysOfWeek = DayOfWeek.allCases
    @Binding var selectedDays: Set<DayOfWeek>
    
    init(selectedDays: Binding<Set<DayOfWeek>>) {
        _selectedDays = selectedDays
    }
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "repeat")
                .resizable()
                .frame(width: 15, height: 15)
//                .aspectRatio(contentMode: .fill)
                .foregroundColor(.yamBlue)
            ForEach(daysOfWeek, id: \.self) { day in
                Button(action: {
                    if selectedDays.contains(day) {
                        selectedDays.remove(day)
                    } else {
                        selectedDays.insert(day)
                    }
                }, label: {
                    day.displayText
                        .frame(width: 27, height: 25)
                        .padding(2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(selectedDays.contains(day) ? Color.yamBlue : Color.clear, lineWidth: 2)
                        )
                })
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.primary)
                .font(.caption)
            }
        }
        .padding()
    }
}
