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

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    private lazy var displayManager: ChartDetailViewDisplayManager = {
        
        let displayManager = ChartDetailViewDisplayManager(collectionView: collectionView)
        return displayManager
    }()
    
    private var maxVisibleLineValue = 0
    private var data: ChartDetailViewData?
    private lazy var chartView: ChartView = {
        let chartView = ChartView(frame: scrollView.bounds)
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
        updateFrames()
    }
    
    private func updateFrames() {
        scrollView.layoutIfNeeded()
        let newWidth = scrollView.bounds.width*chartXZoom
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
        
        let visibleRect = convert(scrollView.frame, to: chartView)
        let xSpace = chartView.bounds.width/CGFloat(data.chartViewData.maxLineValuesCount)
        var maxLineVisibleValue = 0
        
        var visibleValuesDates: [String] = []
        let xSpaceForData = collectionView.bounds.width/6
        
        for line in data.chartViewData.lines {
            var dateXCoor: CGFloat = 0
            for (index, value) in line.values.enumerated() {
                let x = CGFloat(round(xSpace*CGFloat(index)))

                if x >= visibleRect.minX && x <= visibleRect.maxX {
                    if maxLineVisibleValue < value {
                        maxLineVisibleValue = value
                    }
                    if data.dates.count > index && dateXCoor < x  {
                        let date = data.dates[index]
                        if !visibleValuesDates.contains(date) {
                            visibleValuesDates.append(date)
                        }
                        dateXCoor += xSpaceForData
                    }

                }
            }
        }
        if let data = self.data {
            chartView.drawChartWith(data: data.chartViewData, withMaxLineVisibleValue: maxLineVisibleValue)
        }
        
        displayManager.set(visibleValuesDates)
    }

}
