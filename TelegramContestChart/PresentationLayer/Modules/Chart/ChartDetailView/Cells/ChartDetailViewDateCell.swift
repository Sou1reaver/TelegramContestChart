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

struct ChartDetailViewDateCellFactory: ReusableViewFactory {
    
    typealias ViewType = ChartDetailViewDateCell
    
    private let model: String
    
    init(_ model: String) {
        
        self.model = model
    }
    
    func setup(view: ChartDetailViewDateCell) {
        view.titleLabel.text = model
    }
}
