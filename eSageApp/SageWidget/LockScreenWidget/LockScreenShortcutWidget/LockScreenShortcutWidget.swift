//
//  LockScreenShortcutWidget.swift
//  eSageApp
//
//  Created by Hien Nguyen D. [2] VN.Danang on 22/09/2023.
//

import WidgetKit
import SwiftUI

struct LockScreenShortcutWidgetEntry: TimelineEntry {
    let date: Date
}

struct AccessoryCircularBarcodeShortcutWidgetView: View {
    var viewModel: AccessaryCircularBarcodeShortcutWidgetViewModel

    var body: some View {

        ZStack {
            Color.white.opacity(0.12)
            VStack(spacing: 4) {
                Image("logo_PLogo_White")
                    .resizable()
                    .frame(width: 24, height: 24)
                Text(LockScreenWidgetLocalizedString.pay.localized)
                    .font(.system(size: 10, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
            }.padding(EdgeInsets(top: 2, leading: 0, bottom: 0, trailing: 0))
        }
        .unredacted()
        .widgetURL(viewModel.deeplinkUrl)

    }
}

struct LockScreenShortcutWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: LockScreenShortcutProvider.Entry

    var body: some View {

        switch family {
        case .accessoryCircular:
            AccessoryCircularBarcodeShortcutWidgetView(viewModel: AccessaryCircularBarcodeShortcutWidgetViewModel())
        default:
            VStack {}
        }
    }
}

@available(iOSApplicationExtension 16.0, *)
struct LockScreenShortcutWidget: Widget {

    let kind: String = "LockScreenShortcutWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: LockScreenShortcutProvider()) { entry in
                LockScreenShortcutWidgetEntryView(entry: entry)
            }
            .configurationDisplayName(LockScreenWidgetLocalizedString.eSageWidgetTitle.localized)
            .description(LockScreenWidgetLocalizedString.eSageWidgetDescrption.localized)
            .supportedFamilies([.accessoryCircular])
    }
}

