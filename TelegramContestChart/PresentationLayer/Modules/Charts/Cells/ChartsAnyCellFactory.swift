//
//  ChartsAnyCellFactory.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 21/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

struct ChartsAnyCellFactory: ReusableViewFactory {
    
    typealias ViewType = UITableViewCell
    
    private let model: ChartsAnyCellData
    
    public var identifier: String {
        
        var id: String = ""
        switch model.dataType {
        case .chart:
            id = String(describing: ChartsDetailsCellFactory.self.wrappedType)
        case .appearance:
            id = String(describing: ChartsAppearanceCellFactory.self.wrappedType)
        }
        return id
    }
    
    
    init(_ model: ChartsAnyCellData) {
        
        self.model = model
    }
    
    func setup(view: UITableViewCell) {
        
        switch (model, view) {
        case (let modelObject as ChartsDetailsCellData, let modelCell as ChartsDetailsCell):
            ChartsDetailsCellFactory(modelObject).setup(view: modelCell)
        case (let modelObject as ChartsAppearanceCellData, let modelCell as ChartsAppearanceCell):
            ChartsAppearanceCellFactory(modelObject).setup(view: modelCell)
        default:
            fatalError("Not supported set of modelObject and cell")
        }
    }
}
