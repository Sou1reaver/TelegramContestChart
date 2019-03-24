//
//  ChartSectionHeaderView.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 16/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

class ChartsSectionHeaderView: UITableViewHeaderFooterView {
    @IBOutlet weak var titleLabel: UILabel!
    
}

struct ChartsSectionHeaderData {
    let title: String
    let appearanceType: AppearanceType
}


struct ChartsSectionHeaderFactory: ReusableViewFactory {
    
    typealias ViewType = ChartsSectionHeaderView
    
    private let model: ChartsSectionHeaderData
    
    init(_ model: ChartsSectionHeaderData) {
        
        self.model = model
    }
    
    func setup(view: ChartsSectionHeaderView) {
        view.titleLabel.text = model.title
        view.titleLabel.textColor = UIColor.titleTextColorWith(appearanceType: model.appearanceType)
    }
}
