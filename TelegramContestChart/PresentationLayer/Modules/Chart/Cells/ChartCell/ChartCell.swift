//
//  ChartCell.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 16/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

class ChartCell: UITableViewCell {

}

struct ChartCellData: ChartAnyCellData {
    
    var dataType: ChartAnyCellDataType {
        return .chart
    }
    let chart: [ChartViewLine]
}

struct ChartCellFactory: ReusableViewFactory {
    
    typealias ViewType = ChartCell
    
    private let model: ChartCellData
    
    init(_ model: ChartCellData) {
        
        self.model = model
    }
    
    func setup(view: ChartCell) {
        
    }
}
