//
//  YamWidgetBundle.swift
//  YamWidget
//
//  Created by 김미진 on 11/21/24.
//

import WidgetKit
import SwiftUI

@main
struct YamWidgetBundle: WidgetBundle {
    var body: some Widget {
        YamWidget()
        YamWidgetLiveActivity()
    }
}
