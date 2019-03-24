//
//  ChartDetailViewDateCell.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 24/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

class ChartDetailViewDateCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
}

struct ChartDetailViewDateCellData {
    let value: String
    let appearanceType: AppearanceType
}

struct ChartDetailViewDateCellFactory: ReusableViewFactory {
    
    typealias ViewType = ChartDetailViewDateCell
    
    private let model: ChartDetailViewDateCellData
    
    init(_ model: ChartDetailViewDateCellData) {
        
        self.model = model
    }
    
    func setup(view: ChartDetailViewDateCell) {
        view.titleLabel.text = model.value
        view.titleLabel.textColor = UIColor.textColorWith(appearanceType: model.appearanceType)
        view.backgroundColor = UIColor.chartModuleCellColorWith(appearanceType: model.appearanceType)
    }
}
