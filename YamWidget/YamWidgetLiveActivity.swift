//
//  YamWidgetLiveActivity.swift
//  YamWidget
//
//  Created by 김미진 on 11/21/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct YamWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct YamWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: YamWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension YamWidgetAttributes {
    fileprivate static var preview: YamWidgetAttributes {
        YamWidgetAttributes(name: "World")
    }
}

extension YamWidgetAttributes.ContentState {
    fileprivate static var smiley: YamWidgetAttributes.ContentState {
        YamWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: YamWidgetAttributes.ContentState {
         YamWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: YamWidgetAttributes.preview) {
   YamWidgetLiveActivity()
} contentStates: {
    YamWidgetAttributes.ContentState.smiley
    YamWidgetAttributes.ContentState.starEyes
}
