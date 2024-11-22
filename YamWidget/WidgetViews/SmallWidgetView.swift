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
        VStack {
            Text("Small Widget")
                .font(.headline)
            Text(entry.date, style: .time)
        }
        .padding()
        .background(Color.blue)
        .cornerRadius(10)
    }
}
