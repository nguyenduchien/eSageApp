//
//  LockScreenWidget.swift
//  eSageApp
//
//  Created by Hien Nguyen D. [2] VN.Danang on 22/09/2023.
//

import WidgetKit
import SwiftUI
import Intents

struct AccessoryRectangulareSageWidgetEntry: TimelineEntry {
    let date: Date
    let widgetState: WidgetState
    let eSage: Int?
    let configuration: ConfigurationIntent
}

struct AccessoryRectangulareSageWidgetView: View {

    let viewModel: AccessoryRectangulareSageWidgetViewModel

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 0) {
                HStack {
                    Text(LockScreenWidgetLocalizedString.payWith.localized)
                        .font(.system(size: 12, weight: .bold))
                    Spacer()
                }.padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4))
                HStack(spacing: 4) {
                    if viewModel.isUnLogin {
                        Image("icon_system_userInfo")
                            .resizable()
                            .frame(width: 36, height: 36)
                        Text(LockScreenWidgetLocalizedString.pleaseLogin.localized)
                            .font(.system(size: 9, weight: .regular))
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                    } else {
                        Image("icon_system_qrCode_simple_mono")
                            .resizable()
                            .frame(width: 36, height: 36)
                        if viewModel.showeSage {
                            if viewModel.isPlaceHolder {
                                VStack(alignment: .leading, spacing: 4) {
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: 86, height: 10, alignment: .center)
                                    Rectangle()
                                        .fill(Color.white)
                                        .frame(width: 86, height: 10, alignment: .center)
                                }
                            } else {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 0) {
                                        Text(viewModel.displaydish >= 0 ? "\(viewModel.displaydish)" : "--")
                                            .foregroundColor(.white)
                                            .font(.system(size: 12, weight: .bold))
                                            .minimumScaleFactor(0.1)
                                        Text(LockScreenWidgetLocalizedString.yen.localized)
                                            .foregroundColor(.white)
                                            .font(.system(size: 12, weight: .bold))
                                            .minimumScaleFactor(0.1)
                                    }

                                    UpdateDateText(date: viewModel.displayDate, format: LockScreenWidgetLocalizedString.updateDateFormat.localized)
                                        .minimumScaleFactor(0.1)
                                }
                            }
                        } else {
                            Text(LockScreenWidgetLocalizedString.tapToPay.localized)
                                .font(.system(size: 12, weight: .bold))
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                        }
                    }
                    Spacer()
                }
            }.padding(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4))
            Spacer()
        }
        .unredacted()
        .widgetURL(viewModel.deeplinkUrl)
    }
}

@available(iOSApplicationExtension 16.0, *)
struct LockScreeneSageWidgetEntryView: View {
    @Environment(\.redactionReasons) var redactionReasons
    @Environment(\.widgetFamily) var family
    var entry: LockScreeneSageProvider.Entry

    var body: some View {

        switch family {
        case .accessoryRectangular:
            AccessoryRectangulareSageWidgetView(viewModel: .init(
                widgetState: entry.widgetState,
                eSagedish: entry.eSage,
                lastUpdateDate: entry.date,
                showeSageConfiguration: entry.configuration.showeSage?.boolValue ?? false,
                isPrivacy: redactionReasons.contains(.privacy)))
        default:
            VStack {}
        }
    }
}

@available(iOSApplicationExtension 16.0, *)
struct LockScreeneSageWidget: Widget {

    let kind: String = "LockScreeneSageWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: ConfigurationIntent.self,
            provider: LockScreeneSageProvider(widgetReloadManager: .init(
                reloadDateChecker: DefaultWidgetReloadDateChecker(
                    storage: GenericDataStorage<Date>(repository: UserDefaulsRepository())),
                helper: DefaultWidgetHelper(),
                cacheStorage: CodableDataStorage(repository: UserDefaulsRepository())))) { entry in
                LockScreeneSageWidgetEntryView(entry: entry)
            }
            .configurationDisplayName(LockScreenWidgetLocalizedString.eSageWidgetTitle.localized)
            .description(LockScreenWidgetLocalizedString.eSageWidgetDescrption.localized)
            .supportedFamilies([.accessoryRectangular])
    }
}

