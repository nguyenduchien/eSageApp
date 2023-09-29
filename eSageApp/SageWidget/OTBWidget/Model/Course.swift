//
//  Course.swift
//  eSageApp
//
//  Created by Hien Nguyen D. [2] VN.Danang on 29/09/2023.
//

import Foundation


import Foundation
import SwiftUI

struct CourseDetails: Codable {
    let course: Course
    let amount: Int?
    let profit: Int?
    let profitPercentage: Double?
    let amountTransitionList: [Int]?
}

enum Course: String, Codable {
    case standard
    case challenge

    var name: String {
        switch self {
        case .standard:
            return "standardCourse"
        case .challenge:
            return "challengeCourse"
        }
    }

    var description: String {
        switch self {
        case .standard:
            return "standardCourseDescription"
        case .challenge:
            return "challengeCourseDescription"
        }
    }

    var imageName: String {
        switch self {
        case .standard:
            return "standand_course"
        case .challenge:
            return "challenge_course"
        }
    }

    var preferdColor: Color {
        switch self {
        case .standard:
            return Color(red: 1, green: 0.835, blue: 0.357)
        case .challenge:
            return Color(red: 1, green: 0.686, blue: 0.679)
        }
    }
}
