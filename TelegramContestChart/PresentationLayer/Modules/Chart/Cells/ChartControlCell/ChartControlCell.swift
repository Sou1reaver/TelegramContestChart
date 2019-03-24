//
//  ChartControlCell.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 16/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

protocol ChartControlCellDelegate: class {
    func chartViewControlDidChange(_ sender: ChartViewControl)
}

class ChartControlCell: UITableViewCell {

    @IBOutlet weak var chartsViewControl: ChartViewControl!
    weak var delegate: ChartControlCellDelegate?
    
    @IBAction func chartViewControlDidChange(_ sender: ChartViewControl) {
        delegate?.chartViewControlDidChange(sender)
    }
}

struct ChartControlCellData: ChartAnyCellData {
    
    let appearanceType: AppearanceType
    var dataType: ChartAnyCellDataType {
        return .chartControl
    }
    let chartData: ChartViewData
}

struct ChartControlCellFactory: ReusableViewFactory {
    
    typealias ViewType = ChartControlCell
    
    private let model: ChartControlCellData
    private weak var delegate: ChartControlCellDelegate?
    
    init(_ model: ChartControlCellData, delegate: ChartControlCellDelegate?) {
        
        self.model = model
        self.delegate = delegate
    }
    
    func setup(view: ChartControlCell) {
        view.chartsViewControl.addChartWith(data: model.chartData)
        view.backgroundColor = UIColor.chartModuleCellColorWith(appearanceType: model.appearanceType)
        view.delegate = delegate
    }
}
