//
//  LineChartView.swift
//  eSageApp
//
//  Created by Hien Nguyen D. [2] VN.Danang on 23/09/2023.
//

import SwiftUI

struct LineChartView: View {
    let amountTransitionList: [Int]
    let defaultLineColor: Color = Color(red: 0, green: 0.161, blue: 0.439)
    let tickCount = 4
    let viewModel: LineChartViewModel = LineChartViewModel()
    var body: some View {
        ZStack {
            GeometryReader { metrics in
                let size = metrics.size
                let yAxis = viewModel.generateYTicks(from: amountTransitionList, tickCount: tickCount)
                if let min = yAxis.min(),
                   let max = yAxis.max() {
                    let diff = max - min
                    let pointHeight = size.height / CGFloat(diff)
                    let horizontalPadding: CGFloat = 3
                    let eachWidth: CGFloat = {
                        guard amountTransitionList.count > 1 else {
                            return size.width / 2
                        }
                        return (size.width - horizontalPadding * 2) / CGFloat(amountTransitionList.count - 1)
                    }()
                    var startPoint: CGPoint = .zero
                    // line chart
                    Path { path in
                        amountTransitionList.map({ CGFloat($0) }).enumerated().forEach { (i, value) in
                            if i == 0 {
                                startPoint = CGPoint(x: horizontalPadding + eachWidth * CGFloat(i), y: size.height - value * pointHeight)
                                return
                            }
                            path.move(to: .init(x: startPoint.x, y: startPoint.y))
                            startPoint = CGPoint(x: horizontalPadding + eachWidth * CGFloat(i), y: size.height - value * pointHeight)
                            path.addLine(to: .init(x: startPoint.x, y: startPoint.y))
                        }
                    }
                    .stroke(defaultLineColor, style: .init(lineWidth: 1.0))
                    // circle
                    Path { path in
                        path.addRoundedRect(in: .init(x: startPoint.x - 2.5, y: startPoint.y - 2.5, width: 5, height: 5), cornerSize: CGSize(width: 2.5, height: 2.5))
                    }.fill(Color.white)
                    Path { path in
                        path.addRoundedRect(in: .init(x: startPoint.x - 2.5, y: startPoint.y - 2.5, width: 5, height: 5), cornerSize: CGSize(width: 2.5, height: 2.5))
                    }.stroke(defaultLineColor, style: .init(lineWidth: 1.5))
                }
            }
        }.padding(3)
    }
}

struct BigLineChartView: View {
    let amountTransitionList: [Int]
    let defaultLineColor: Color = Color(red: 0, green: 0.161, blue: 0.439)
    let yAxisColor: Color = Color(red: 0.565, green: 0.565, blue: 0.565)
    let backgroundLineColor: Color = Color(red: 0.929, green: 0.929, blue: 0.929)
    let viewModel: LineChartViewModel = LineChartViewModel()
    let tickCount = 4
    var body: some View {
        HStack {
            VStack(alignment: .trailing) {
                let yAxis = viewModel.generateYTicks(from: amountTransitionList, tickCount: tickCount)
                ForEach(0..<yAxis.count, id: \.self) { i in
                    Text("\(yAxis[i])")
                        .foregroundColor(yAxisColor)
                        .font(.system(size: 10, weight: .bold))
                        .frame(maxHeight: .infinity)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
            }.frame(width: 32, alignment: .trailing)
            ZStack {
                GeometryReader { metrics in
                    ZStack {
                        GeometryReader { lineChartMetrics in
                            let size = lineChartMetrics.size
                            // background line
                            ForEach(0..<tickCount, id: \.self) { i in
                                Path { path in
                                    let eachHeight = lineChartMetrics.size.height / 3
                                    path.move(to: .init(x: 0, y: eachHeight * CGFloat(i)))
                                    path.addLine(to: .init(x: lineChartMetrics.size.width, y: eachHeight * CGFloat(i)))
                                }.stroke(backgroundLineColor, style: .init(lineWidth: 1.0))
                            }
                            let yAxis = viewModel.generateYTicks(from: amountTransitionList, tickCount: tickCount)
                            if let min = yAxis.min(),
                               let max = yAxis.max() {
                                let diff = max - min
                                let pointHeight = size.height / CGFloat(diff)
                                let horizontalPadding: CGFloat = 8
                                let eachWidth: CGFloat = {
                                    guard amountTransitionList.count > 1 else {
                                        return size.width / 2
                                    }
                                    return (size.width - horizontalPadding * 2) / CGFloat(amountTransitionList.count - 1)
                                }()
                                var startPoint: CGPoint = .zero
                                // line chart
                                Path { path in
                                    amountTransitionList.map({ CGFloat($0) }).enumerated().forEach { (index, value) in
                                        if index == 0 {
                                            startPoint = CGPoint(x: horizontalPadding + eachWidth * CGFloat(index), y: size.height - value * pointHeight)
                                            return
                                        }
                                        path.move(to: .init(x: startPoint.x, y: startPoint.y))
                                        startPoint = CGPoint(x: horizontalPadding + eachWidth * CGFloat(index), y: size.height - value * pointHeight)
                                        path.addLine(to: .init(x: startPoint.x, y: startPoint.y))
                                    }
                                }
                                .stroke(defaultLineColor, style: .init(lineWidth: 1.0))
                                // circle
                                Path { path in
                                    path.addRoundedRect(in: .init(x: startPoint.x - 2.5, y: startPoint.y - 2.5, width: 5, height: 5), cornerSize: CGSize(width: 2.5, height: 2.5))
                                }.fill(Color.white)
                                Path { path in
                                    path.addRoundedRect(in: .init(x: startPoint.x - 2.5, y: startPoint.y - 2.5, width: 5, height: 5), cornerSize: CGSize(width: 2.5, height: 2.5))
                                }.stroke(defaultLineColor, style: .init(lineWidth: 1.5))
                            }
                        }
                    }.padding(.vertical, metrics.size.height / 8)
                }
            }
        }
    }
}
