//
//  ChartView.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 14/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

struct ChartViewData {
    var lines: [ChartViewLine]
    var maxLineValuesCount: Int
    var maxLineValue: Int
}

struct ChartViewLine {
    var values: [Int]
    var color: UIColor
}

class ChartView : UIView {
    
    private var data: ChartViewData!
    private var points: [CGPoint] = []

    private var maxLineVisibleValue: CGFloat!
    private var maxLineValuesCount: CGFloat!
    
    override func draw(_ rect: CGRect) {
        
        guard self.data != nil && maxLineVisibleValue != nil else { return }
        let xSpace = (bounds.width-2)/CGFloat(data.maxLineValuesCount)
        let yScale = (self.bounds.height-2) / maxLineVisibleValue
        
        if let context = UIGraphicsGetCurrentContext() {
            context.setLineWidth(1)
            context.beginPath()
            
            for line in data.lines {

                for (index, value) in line.values.enumerated() {
                    
                    let nextIndex = index + 1
                    guard nextIndex < line.values.count else { break }
                    
                    let point = CGPoint(x: CGFloat(round(xSpace*CGFloat(index))),
                                        y: CGFloat(round((CGFloat(value))*yScale)))
                    
                    let nextValue = line.values[nextIndex]
                    let nextPoint = CGPoint(x: CGFloat(round(xSpace*CGFloat(nextIndex))),
                                            y: CGFloat(round((CGFloat(nextValue))*yScale)))
                    points.append(contentsOf: [point, nextPoint])
                    
                    context.move(to: point)
                    context.addLine(to: nextPoint)
                    context.setStrokeColor(line.color.cgColor)
                    context.strokePath()
                }
            }
        }
        transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    func drawChartWith(data: ChartViewData, withMaxLineVisibleValue maxLineVisibleValue: Int) {
        self.data = data
        self.maxLineValuesCount = CGFloat(data.maxLineValuesCount)
        self.maxLineVisibleValue = CGFloat(maxLineVisibleValue)
        setNeedsDisplay()
    }
}

