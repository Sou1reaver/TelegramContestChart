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


struct ChartDetailViewLineValueCellFactory: ReusableViewFactory {
    
    typealias ViewType = ChartDetailViewLineValueCell
    
    private let model: Int
    
    init(_ model: Int) {
        
        self.model = model
    }
    
    func setup(view: ChartDetailViewLineValueCell) {
        view.titleLabel.text = String(model)
    }
}
