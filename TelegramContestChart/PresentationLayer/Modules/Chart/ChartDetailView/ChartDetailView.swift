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
    let appearanceType: AppearanceType = .light
}

class ChartDetailView: UIView {

    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var lineValuesTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    var appearanceType: AppearanceType = .light {
        didSet {
            updateColors()
        }
    }
    
    private lazy var datesDisplayManager: ChartDetailViewDatesDisplayManager = {
        
        let displayManager = ChartDetailViewDatesDisplayManager(collectionView: collectionView)
        return displayManager
    }()
    
    private lazy var lineValuesDisplayManager: ChartDetailViewLineValuesDisplayManager = {
        
        let displayManager = ChartDetailViewLineValuesDisplayManager(tableView: lineValuesTableView)
        return displayManager
    }()
    
    private var maxVisibleLineValue = 0
    private var data: ChartDetailViewData?
    private lazy var chartView: ChartView = {
        let chartView = ChartView(frame: scrollView.bounds)
        chartView.backgroundColor = .clear
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
        
        updateColors()
    }
    
    private func updateColors() {
        lineValuesTableView.backgroundColor = UIColor.chartModuleCellColorWith(appearanceType: appearanceType)
        lineValuesTableView.separatorColor = UIColor.tableViewBackgroundColorWith(appearanceType: appearanceType)
        separatorView.backgroundColor = UIColor.tableViewBackgroundColorWith(appearanceType: appearanceType)
        collectionView.backgroundColor = UIColor.chartModuleCellColorWith(appearanceType: appearanceType)
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
        layoutIfNeeded()
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
        
        datesDisplayManager.set(visibleValuesDates.compactMap({ChartDetailViewDateCellData(value: $0, appearanceType: appearanceType)}))
        lineValuesDisplayManager.set(valuesForTablefrom(maxLineVisibleValue: maxLineVisibleValue).compactMap({ChartDetailViewLineValueCellData(value: $0, appearanceType: appearanceType)}))
    }
    
    private func valuesForTablefrom(maxLineVisibleValue: Int) -> [Int] {
        
        let numberValuesMoreZero = 5
        var values = [Int]()
        var step = 0
        for i in (0...maxLineVisibleValue).reversed() {
            if i % numberValuesMoreZero == 0 {
                if (i/numberValuesMoreZero) % 10 == 0 {
                    step = i/numberValuesMoreZero
                    break
                }

            }
        }
        
        for i in (1...numberValuesMoreZero).reversed() {
            values.append(step*i)
        }
        values.append(0)
        return values
    }

}
