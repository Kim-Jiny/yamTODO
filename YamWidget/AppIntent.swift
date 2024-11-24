//
//  AppIntent.swift
//  YamWidget
//
//  Created by 김미진 on 11/21/24.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "YamTODO"
    static var description = IntentDescription("I am YamTODO.")

    // An example configurable parameter.
    @Parameter(title: "Welcome to Yamtodo", default: "😃")
    var favoriteEmoji: String
}
