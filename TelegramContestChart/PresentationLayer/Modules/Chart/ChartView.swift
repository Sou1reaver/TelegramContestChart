//
//  ChartView.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 14/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

class ChartView : UIView {
    
    private var lines: [ChartViewLine] = []

    override func draw(_ rect: CGRect) {
        
        var maxLineValue = 0
        for line in lines {
            guard let max = line.values.max() else { continue }
            if max > maxLineValue {
                maxLineValue = max
            }
        }
        guard maxLineValue > 0 else {
            return
        }
        
        if let context = UIGraphicsGetCurrentContext() {
            context.setLineWidth(1)
            context.beginPath()
  
            for line in lines {

                for (index, value) in line.values.enumerated() {
                    
                    let xSpace = bounds.width/CGFloat(line.values.count)
                    let nextIndex = index + 1
                    guard nextIndex < line.values.count else { break }
                    let yScale = min(1, self.bounds.height / CGFloat(maxLineValue))
                    
                    let point = CGPoint(x: CGFloat(round(xSpace*CGFloat(index))),
                                        y: CGFloat(round((CGFloat(value))*yScale)))
                    
                    let nextValue = line.values[nextIndex]
                    let nextPoint = CGPoint(x: CGFloat(round(xSpace*CGFloat(nextIndex))),
                                            y: CGFloat(round((CGFloat(nextValue))*yScale)))
                    
                    context.move(to: point)
                    context.addLine(to: nextPoint)
                    context.setStrokeColor(line.color.cgColor)
                    context.strokePath()
                }
            }
        }
        transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    func drawChartWith(lines: [ChartViewLine]) {
        self.lines = lines
        setNeedsDisplay()
    }
    
    private func createPointsFrom(yValues:[Int], inRect rect: CGRect) -> [CGPoint] {
        
        let xSpace = CGFloat(10)
        let yScale = min(1, rect.height / CGFloat(yValues.max() ?? 0))
        
        var points = [CGPoint]()
        for i in 0..<yValues.count {
            let x = CGFloat(round(xSpace*CGFloat(i)))
            let y = CGFloat(round((CGFloat(yValues[i]))*yScale))
            points.append(CGPoint(x: x, y: y))
        }
        return points
    }
}

struct ChartViewLine {
    var values: [Int]
    var color: UIColor
}
