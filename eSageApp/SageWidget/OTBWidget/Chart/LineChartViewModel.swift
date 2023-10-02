//
//  LineChartViewModel.swift
//  eSageApp
//
//  Created by Hien Nguyen D. [2] VN.Danang on 23/09/2023.
//

import Foundation
import SwiftUI

struct LineChartViewModel {

    func generateYTicks(from values: [Int], tickCount: Int) -> [Int] {
        guard var min = values.min(),
              let max = values.max(),
              tickCount > 1 else { return [] }

        if min > 0 { min = 0 }
        let range = max != min ? max - min : max
        let unroundedTickSize = CGFloat(range) / CGFloat(tickCount - 1)
        let roundedTickRange: Int
        if unroundedTickSize < 1 {
            // minumum size is 1
            roundedTickRange = 1
        } else {
            let x = ceil(log10(unroundedTickSize) - 1)
            let pow10x = pow(10, x)
            roundedTickRange = Int(ceil(unroundedTickSize / pow10x) * pow10x)
        }

        var result: [Int] = []
        for index in 0..<tickCount {
            result.append(index * roundedTickRange)
        }

        return result.reversed()
    }
}

