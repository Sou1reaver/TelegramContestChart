//
//  ChartControlCell.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 16/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

class ChartControlCell: UITableViewCell {

    @IBOutlet weak var chartsViewControl: ChartViewControl!
}

struct ChartControlCellData: ChartAnyCellData {
    
    var dataType: ChartAnyCellDataType {
        return .chartControl
    }
    let chart: [ChartViewLine]
}

struct ChartControlCellFactory: ReusableViewFactory {
    
    typealias ViewType = ChartControlCell
    
    private let model: ChartControlCellData
    
    init(_ model: ChartControlCellData) {
        
        self.model = model
    }
    
    func setup(view: ChartControlCell) {
        view.chartsViewControl.addChartWith(lines: model.chart)
    }
}
