//
//  ChartsDetailCell.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 21/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

class ChartsDetailsCell: UITableViewCell {
    @IBOutlet weak var heightContainer
    : NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
}

struct ChartsDetailsCellData: ChartsAnyCellData {
    
    var dataType: ChartsAnyCellDataType {
        return .chart
    }
}

struct ChartsDetailsCellFactory: ReusableViewFactory {
    
    typealias ViewType = ChartsDetailsCell
    
    private let model: ChartsDetailsCellData
    
    init(_ model: ChartsDetailsCellData) {
        
        self.model = model
    }
    
    func setup(view: ChartsDetailsCell) {
        
    }
}
