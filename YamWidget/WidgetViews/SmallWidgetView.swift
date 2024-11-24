//
//  SmallWidgetView.swift
//  yamTODO
//
//  Created by 김미진 on 11/22/24.
//

import SwiftUI

struct SmallWidgetView: View {
    let entry: SimpleEntry
    
    var body: some View {
        // 좌측: To-Do 리스트
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Image("YamIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                Text(String(localized: "Today's To-Do"))
                    .foregroundColor(.softWhite) // 텍스트 색상 흰색
                    .font(.footnote)
                    .bold()
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .padding(.bottom, 2)
            
            // `isFixed`가 true인 항목을 우선 표시
            let sortedTasks = entry.tasksListModel.tasks.sorted { $0.isFixed && !$1.isFixed }
            
            if sortedTasks.isEmpty {
                Text(String(localized: "No tasks today!"))
                    .font(.caption2)
                    .foregroundColor(.softWhite) // 텍스트 색상 흰색
            } else {
                ForEach(sortedTasks.prefix(5), id: \.id) { task in
                    HStack {
                        Image("YamIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 8, height: 8)
                        if task.isFixed {
                            // `isFixed`가 true일 때 볼드체 적용
                            Text(task.title.isEmpty ? task.desc : task.title)
                                .font(.caption2)
                                .fontWeight(.bold) // 볼드체 적용
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .foregroundColor(.softWhite) // 텍스트 색상 흰색
                        } else {
                            Text(task.title.isEmpty ? task.desc : task.title)
                                .font(.caption2)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .foregroundColor(.softWhite) // 텍스트 색상 흰색
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 4)
        
    }
    
}
