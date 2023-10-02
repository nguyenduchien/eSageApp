//
//  OTBWidgetViewModel.swift
//  eSageApp
//
//  Created by Hien Nguyen D. [2] VN.Danang on 23/09/2023.
//

import Foundation

struct OTBWidgetViewModel {

    enum TapArea {
        case standardCourse
        case challengeCourse
        case other
    }

    // Inputs
    let widgetSize: WidgetSize
    let widgetState: WidgetState
    let latestUpdateDate: Date
    let courseInfos: [CourseDetails]
    let pendingBonus: Int?
    private let deeplinkEventManager: OTBWidgetDeeplinkEventManager = OTBWidgetDeeplinkEventManager()

    var dateText: String {
        return dateFormat.string(from: latestUpdateDate)
    }

    var isUnlogin: Bool {
        return widgetState == .unLogin
    }

    var isError: Bool {
        return widgetState == .error
    }

    var isPlaceHolder: Bool {
        return widgetState == .placeholder
    }

    var bonus: Int {
        return pendingBonus ?? 0
    }

    var firstCourse: CourseDetails {
        return courseInfos.first(where: { $0.course == .standard }) ?? CourseDetails(course: .standard, amount: nil, profit: nil, profitPercentage: nil, amountTransitionList: nil)
    }

    var secondCourse: CourseDetails {
        return courseInfos.first(where: { $0.course == .challenge }) ?? CourseDetails(course: .challenge, amount: nil, profit: nil, profitPercentage: nil, amountTransitionList: nil)
    }

    var hasNoCourse: Bool {
        return courseInfos.isEmpty
    }

    let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = OTBWidgetLocalizedString.updateDateFormat.localized
        return formatter
    }()

    func deeplinkUrl(from tapArea: TapArea = .other) -> URL? {
        let destination = deeplinkDestination(from: tapArea)
        let event = deeplinkEventManager.generateDeeplinkEvent(from: widgetEvent(tapArea: tapArea), widgetSize: widgetSize)

        return URL.combine(destination: destination, event: event)
    }

    func deeplinkDestination(from tapArea: TapArea) -> DeeplinkDestination {
        switch tapArea {
        case .other:
            switch widgetState {
            case .unLogin:
                return .open
            case .placeholder:
                return .otb
            case .error:
                return .otb
            default:
                return .otb
            }
        case .standardCourse:
            return .otb
        case .challengeCourse:
            return .otb
        }
    }

    func widgetEvent(tapArea: TapArea) -> OTBWidgetEvents {
        switch tapArea {
        case .other:
            switch widgetState {
            case .unLogin:
                return .signInClicked
            case .placeholder:
                return .loadingClicked
            case .error:
                return .fetchErrorClicked
            default:
                return widgetSize == .small
                    ? .widgetClicked(generateEventStatus())
                    : .otherAreaClicked(generateEventStatus())
            }
        case .standardCourse:
            return .standandCourseClicked(generateEventStatus())
        case .challengeCourse:
            return .challengeCourseClicked(generateEventStatus())
        }
    }

    private func generateEventStatus() -> OTBWidgetEventStatus {
        if courseInfos.count == 0 {
            return .noDisk
        }

        if courseInfos.count == 1 {
            if courseInfos[0].course == .standard {
                return .standardCourseUser
            }

            if courseInfos[0].course == .challenge {
                return .challengeCourseUser
            }
        }

        return .standardAndChallengeCourseUser
    }
}
