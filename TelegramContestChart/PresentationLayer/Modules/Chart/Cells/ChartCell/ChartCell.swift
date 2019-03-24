//
//  ChartCell.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 16/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

class ChartCell: UITableViewCell {
    @IBOutlet weak var chartDetailView: ChartDetailView!
}

struct ChartCellData: ChartAnyCellData {
    
    let appearanceType: AppearanceType
    var dataType: ChartAnyCellDataType {
        return .chart
    }
    let chart: ChartDetailViewData
    let chatWidthZoom: CGFloat
    let chatXOffsetScale: CGFloat
}

struct ChartCellFactory: ReusableViewFactory {
    
    typealias ViewType = ChartCell
    
    private let model: ChartCellData
    
    init(_ model: ChartCellData) {
        
        self.model = model
    }
    
    func setup(view: ChartCell) {
        view.chartDetailView.appearanceType = model.appearanceType
        view.backgroundColor = UIColor.chartModuleCellColorWith(appearanceType: model.appearanceType)
        view.chartDetailView.setChartWith(data: model.chart, withWidthZoom: model.chatWidthZoom, and: model.chatXOffsetScale)
    }
}
