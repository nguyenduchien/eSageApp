//
//  LockScreenShortcutWidgetProvider.swift
//  eSageApp
//
//  Created by Hien Nguyen D. [2] VN.Danang on 22/09/2023.
//

import WidgetKit

struct LockScreenShortcutProvider: TimelineProvider {

    func placeholder(in context: Context) -> LockScreenShortcutWidgetEntry {
        LockScreenShortcutWidgetEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (LockScreenShortcutWidgetEntry) -> Void) {
        completion(LockScreenShortcutWidgetEntry(date: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<LockScreenShortcutWidgetEntry>) -> Void) {
        let entry = LockScreenShortcutWidgetEntry(date: Date())
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}
