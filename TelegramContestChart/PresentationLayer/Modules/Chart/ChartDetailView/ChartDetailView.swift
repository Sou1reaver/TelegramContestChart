//
//  ChartDetailView.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 20/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

struct ChartDetailViewData {
    let lines: [ChartViewLine]
    let dates: [String]
}

class ChartDetailView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    private var data: ChartDetailViewData?
    private lazy var chartView: ChartView = {
        let chartView = ChartView(frame: bounds)
        chartView.backgroundColor = .white
        contentView.addSubview(chartView)
        return chartView
    }()
    
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
        chartView.frame = bounds
        contentView.sizeToFit()
    }
    
    func setChartWith(data: ChartDetailViewData) {
        self.data = data
        chartView.drawChartWith(lines: data.lines)
        updateFrames()
    }

}
