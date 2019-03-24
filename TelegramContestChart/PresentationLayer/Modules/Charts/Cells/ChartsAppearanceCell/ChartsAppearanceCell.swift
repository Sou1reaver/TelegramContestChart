//
//  ChartAppearanceCell.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 16/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

class ChartsAppearanceCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
}

struct ChartsAppearanceCellData: ChartsAnyCellData {
    
    var dataType: ChartsAnyCellDataType {
        return .appearance
    }
    let appearanceType: AppearanceType
    let title: String
}

struct ChartsAppearanceCellFactory: ReusableViewFactory {
    
    typealias ViewType = ChartsAppearanceCell
    
    private let model: ChartsAppearanceCellData
    
    init(_ model: ChartsAppearanceCellData) {
        
        self.model = model
    }
    
    func setup(view: ChartsAppearanceCell) {
        view.titleLabel.text = model.title
        view.backgroundColor = UIColor.chartModuleCellColorWith(appearanceType: model.appearanceType)
    }
}
    
    

