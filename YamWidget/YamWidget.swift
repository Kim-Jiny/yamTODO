//
//  YamWidget.swift
//  YamWidget
//
//  Created by 김미진 on 11/21/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        let tasksListModel = TasksListModel(key: "Placeholder", tasks: [])
        return SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), tasksListModel: tasksListModel)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let tasksListModel = TasksListModel(key: "Snapshot", tasks: [])
        return SimpleEntry(date: Date(), configuration: configuration, tasksListModel: tasksListModel)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // 현재 시간 기준으로 데이터 가져오기
        let currentDate = Date().getStartTime() // 시작 시간 계산
        let tasksListModel = await RealmManagerForWidget.shared.getTasksByDateListAsync(date: Date().getStartTime())

        print(tasksListModel.tasks.count)
        // 생성된 Timeline 항목 추가
        for minuteOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: Date())!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, tasksListModel: tasksListModel)
            entries.append(entry)
        }

        let nextUpdateDate = currentDate.addingTimeInterval(300)
        return Timeline(entries: entries, policy: .after(nextUpdateDate))
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let tasksListModel: TasksListModel
}

struct YamWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily // 위젯 크기를 확인하는 환경 변수
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Color(Color.softBlack)
            switch widgetFamily {
            case .systemSmall:
                SmallWidgetView(entry: entry)
                    .padding(16)
            case .systemMedium:
                MediumWidgetView(entry: entry)
                    .padding(16)
            case .systemLarge:
                LargeWidgetView(entry: entry)
                    .padding(16)
            default:
                MediumWidgetView(entry: entry)
                    .padding(16)
            }
        }
    }
}

struct YamWidget: Widget {
    let kind: String = "YamWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            YamWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .contentMarginsDisabled()
        .containerBackgroundRemovable(false)
    }
}
