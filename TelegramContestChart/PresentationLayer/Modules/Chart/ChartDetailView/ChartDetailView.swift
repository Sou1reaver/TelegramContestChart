//
//  ChartDetailView.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 20/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

struct ChartDetailViewData {
    let chartViewData: ChartViewData!
    let dates: [String]
}

class ChartDetailView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    private var maxVisibleLineValue = 0
    private var data: ChartDetailViewData?
    private lazy var chartView: ChartView = {
        let chartView = ChartView(frame: bounds)
        chartView.backgroundColor = .white
        contentView.addSubview(chartView)
        return chartView
    }()
    
    private var chartXZoom: CGFloat = 1
    private var xOffsetScale: CGFloat = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateFrames()
    }
    
    private func initialSetup() {
        fromNib()
    }
    
    private func updateFrames() {
        let newWidth = bounds.width*chartXZoom
        let xOffset: CGFloat
        if xOffsetScale == 1 {
            xOffset = 0
        } else {
            xOffset = max(CGFloat(0), CGFloat(newWidth*xOffsetScale))
        }
  
        chartView.frame = CGRect(x: 0, y: 0, width: newWidth, height: chartView.bounds.height)
        contentView.sizeToFit()
        scrollView.contentOffset = CGPoint(x: xOffset, y: 0)
    }

    func setChartWith(data: ChartDetailViewData, withWidthZoom zoom: CGFloat, and xOffsetScale: CGFloat) {
        self.data = data
        self.xOffsetScale = xOffsetScale
        
        chartXZoom = zoom
        updateFrames()
        
        let visibleRect = convert(bounds, to: chartView)
        let xSpace = chartView.bounds.width/CGFloat(data.chartViewData.maxLineValuesCount)
        var maxLineVisibleValue = 0
        
        for line in data.chartViewData.lines {
            for (index, value) in line.values.enumerated() {
                let x = CGFloat(round(xSpace*CGFloat(index)))
                if x >= visibleRect.minX && x <= visibleRect.maxX {
                    if maxLineVisibleValue < value {
                        maxLineVisibleValue = value
                    }
                }
            }
        }
        if let data = self.data, maxLineVisibleValue > 0 {
            chartView.drawChartWith(data: data.chartViewData, withMaxLineVisibleValue: maxLineVisibleValue)
        }
    }

}
