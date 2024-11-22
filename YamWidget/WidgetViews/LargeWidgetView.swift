//
//  LargeWidgetView.swift
//  yamTODO
//
//  Created by 김미진 on 11/22/24.
//

import SwiftUI

struct LargeWidgetView: View {
    let entry: SimpleEntry

    var body: some View {
        VStack(alignment: .leading) {
            Text("Large Widget")
                .font(.largeTitle)
            Text(entry.date, style: .time)
            Spacer()
        }
        .padding()
        .background(Color.purple)
        .cornerRadius(10)
    }
}
