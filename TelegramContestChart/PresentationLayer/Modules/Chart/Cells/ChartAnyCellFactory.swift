//
//  ChartAnyCellFactory.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 16/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

struct ChartAnyCellFactory: ReusableViewFactory {
    
    typealias ViewType = UITableViewCell
    
    private let model: ChartAnyCellData
    private weak var chartControlCellDelegate: ChartControlCellDelegate?
    
    public var identifier: String {
        
        var id: String = ""
        switch model.dataType {
        case .chart:
            id = String(describing: ChartCellFactory.self.wrappedType)
        case .chartControl:
            id = String(describing: ChartControlCellFactory.self.wrappedType)
        case .lineType:
            id = String(describing: ChartLineTypeCellFactory.self.wrappedType)
        }
        return id
    }
    
    
    init(_ model: ChartAnyCellData, chartControlCellDelegate: ChartControlCellDelegate?) {
        
        self.model = model
        self.chartControlCellDelegate = chartControlCellDelegate
    }
    
    func setup(view: UITableViewCell) {
        
        switch (model, view) {
        case (let modelObject as ChartCellData, let modelCell as ChartCell):
            ChartCellFactory(modelObject).setup(view: modelCell)
        case (let modelObject as ChartControlCellData, let modelCell as ChartControlCell):
            ChartControlCellFactory(modelObject, delegate: chartControlCellDelegate).setup(view: modelCell)
        case (let modelObject as ChartLineTypeCellData, let modelCell as ChartLineTypeCell):
            ChartLineTypeCellFactory(modelObject).setup(view: modelCell)
        default:
            fatalError("Not supported set of modelObject and cell")
        }
    }
}
