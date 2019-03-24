//
//  ChartLineTypeCell.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 16/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

class ChartLineTypeCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak private var separatorHeightConstraint: NSLayoutConstraint!
    
    var showSeparator: Bool = true {
        didSet {
            separatorHeightConstraint.constant = showSeparator ? 1.0 : 0.0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        colorView.layer.cornerRadius = 3.0
    }
}

struct ChartLineTypeCellData: ChartAnyCellData {
    
    let appearanceType: AppearanceType
    var dataType: ChartAnyCellDataType {
        return ChartAnyCellDataType.lineType(title: title)
    }
    let title: String
    let color: UIColor
    let showSeparator: Bool
    let selected: Bool
    
    init(line: Line, selected: Bool, showSeparator: Bool, appearanceType: AppearanceType) {
        title = line.name
        color = UIColor(hexString: line.edgeHexColor)
        self.showSeparator = showSeparator
        self.selected = selected
        self.appearanceType = appearanceType
    }
}

struct ChartLineTypeCellFactory: ReusableViewFactory {
    
    typealias ViewType = ChartLineTypeCell
    
    private let model: ChartLineTypeCellData
    
    init(_ model: ChartLineTypeCellData) {
        
        self.model = model
    }
    
    func setup(view: ChartLineTypeCell) {
        view.colorView.backgroundColor = model.color
        view.titleLabel.text = model.title
        view.titleLabel.textColor = UIColor.chartLineTypeCellTextColorWith(appearanceType: model.appearanceType)
        view.showSeparator = model.showSeparator
        view.accessoryType = model.selected ? .checkmark : .none
        view.backgroundColor = UIColor.chartModuleCellColorWith(appearanceType: model.appearanceType)
        view.separatorView.backgroundColor = UIColor.tableViewBackgroundColorWith(appearanceType: model.appearanceType)
    }
}
