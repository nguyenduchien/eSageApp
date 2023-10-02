//
//  AccessoryRectangularWidgetViewModel.swift
//  eSageApp
//
//  Created by Hien Nguyen D. [2] VN.Danang on 22/09/2023.
//

import WidgetKit
import SwiftUI
import Intents

import Foundation

class AccessoryRectangulareSageWidgetViewModel {

    private let widgetState: WidgetState
    private let eSageDish: String?
    private let lastUpdateDate: Date
    private let showeSageConfiguration: Bool
    private let isPrivacy: Bool

    // Outputs
    var descriptionText: String {
        return "HAVE DATA"
    }

    var isPlaceHolder: Bool {
        return widgetState == .placeholder
    }

    var displayDate: Date {
        return lastUpdateDate
    }

    init(widgetState: WidgetState,
         lastUpdateDate: Date,
         isPrivacy: Bool) {
        self.widgetState = widgetState
        self.lastUpdateDate = lastUpdateDate
        self.isPrivacy = isPrivacy
    }

    private enum EventLabel: String {
        case havedata
        case loading
        case error
    }

}
