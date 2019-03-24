//
//  ChartDetailViewLineValueCellTableViewCell.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 24/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

class ChartDetailViewLineValueCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
}

struct ChartDetailViewLineValueCellData {
    let value: Int
    let appearanceType: AppearanceType
}

struct ChartDetailViewLineValueCellFactory: ReusableViewFactory {
    
    typealias ViewType = ChartDetailViewLineValueCell
    
    private let model: ChartDetailViewLineValueCellData
    
    init(_ model: ChartDetailViewLineValueCellData) {
        
        self.model = model
    }
    
    func setup(view: ChartDetailViewLineValueCell) {
        view.titleLabel.text = String(model.value)
        view.titleLabel.textColor = UIColor.textColorWith(appearanceType: model.appearanceType)
        view.backgroundColor = UIColor.chartModuleCellColorWith(appearanceType: model.appearanceType)
    }
}
