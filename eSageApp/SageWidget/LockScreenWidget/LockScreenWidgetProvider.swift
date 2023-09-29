//
//  LockScreenWidgetProvider.swift
//  eSageApp
//
//  Created by Hien Nguyen D. [2] VN.Danang on 22/09/2023.
//

import WidgetKit

struct LockScreeneSageProvider: IntentTimelineProvider {

    var defaultReloadPeriod: TimeInterval {
        let exluded = [Int](0...119) + [Int](1799...1919) // No reload between 0 min to 2 min and 30 min to 32 min every hour.　(e.g. 6:00 ~ 6:02, 6:30 ~ 6:32)
        return 86400 + Double((0...3599).random(without: exluded))
    }

    func placeholder(in context: Context) -> AccessoryRectangulareSageWidgetEntry {
        AccessoryRectangulareSageWidgetEntry(
            date: Date(),
            widgetState: .placeholder,
            eSage: nil,
            configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (AccessoryRectangulareSageWidgetEntry) -> Void) {
        getEntry(for: configuration, in: context) { (entry, _) in
            completion(entry)
        }
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<AccessoryRectangulareSageWidgetEntry>) -> Void) {
        getEntry(for: configuration, in: context) { (entry, reloadAfter) in
            let timeline = Timeline(entries: [entry], policy: .after(reloadAfter))
            completion(timeline)
        }
    }

    private func getEntry(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Entry, Date) -> Void) {
        let identifier = "eSageWidget_\(context.family.description)"
        let cacheKey = "eSageWidget_eSageWidgetEntry"
        let isReloadFromMainApp = widgetReloadManager.isReloadFromMainApp(key: identifier)
        if widgetReloadManager.shouldSkipReload(identifier: identifier, cacheKey: cacheKey),
           let cache = widgetReloadManager.getCache(cacheKey: cacheKey) {
            // skip this time's reload and use cache instead
            let entry = AccessoryRectangulareSageWidgetEntry(
                date: cache.entry.date,
                widgetState: cache.entry.widgetState,
                eSage: cache.entry.eSage,
                configuration: configuration)
            completion(entry, cache.reloadDate)
            return
        }

        if skipPeriodChecker.shouldSkipReload(date: Date()),
           isReloadFromMainApp == false {
            // during the period, should skip call api and reload after 10min~60min
            let reloadAfter = Date().addingTimeInterval(Double.random(in: 600..<3600))
            let cacheEntry = widgetReloadManager.getCache(cacheKey: cacheKey)?.entry
                ?? eSageWidgetEntry(date: Date(), widgetState: .error, eSage: nil, pendingBonus: nil)
            widgetReloadManager.saveCache(cacheKey: cacheKey, cache: cacheEntry, date: reloadAfter)
            let entry = AccessoryRectangulareSageWidgetEntry(
                date: cacheEntry.date,
                widgetState: cacheEntry.widgetState,
                eSage: cacheEntry.eSage,
                configuration: configuration)
            completion(entry, reloadAfter)
            return
        }

        requestHandler.fetch(completion: { info in
            // reload every 24 hours + random 60 minutes
            var timeInterval: TimeInterval = defaultReloadPeriod
            if Environment.current == .staging || Environment.current == .qa {
                let refreshInterval = UserDefaultsManager(appGroupName: UserDefaultsManager.getGroupNameFromPlist() ?? "").eSageWidgetRefreshInterval ?? Int(defaultReloadPeriod)
                timeInterval = TimeInterval(refreshInterval)
            }

            let reloadAfter = Date().addingTimeInterval(timeInterval)
            let entry = AccessoryRectangulareSageWidgetEntry(
                date: info.date,
                widgetState: info.widgetState,
                eSage: info.eSage,
                configuration: configuration)
            widgetReloadManager.saveCache(cacheKey: cacheKey, cache: info, date: reloadAfter)
            completion(entry, reloadAfter)
        })
    }
}
