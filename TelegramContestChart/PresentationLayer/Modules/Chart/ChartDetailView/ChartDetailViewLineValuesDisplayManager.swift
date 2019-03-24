//
//  ChartDetailViewLineValuesDisplayManager.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 24/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

final class ChartDetailViewLineValuesDisplayManager: NSObject {
    
    // MARK: - Properties
    private weak var tableView: UITableView?
    private var cellModels: [ChartDetailViewLineValueCellData] = []
    
    // MARK: - Methods
    init(tableView: UITableView) {
        super.init()
        
        tableView.registerCellNibWith(factory: ChartDetailViewLineValueCellFactory.self)
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView = tableView
    }
    
    func set(_ cellModels: [ChartDetailViewLineValueCellData]) {
        
        self.cellModels = cellModels
    }
    
    func updateCellAt(indexPath: IndexPath, withData data: ChartDetailViewLineValueCellData) {
        let factory = ChartDetailViewLineValueCellFactory(data)
        tableView?.updateCellAt(indexPath: indexPath, withFactory: factory)
    }
}

// MARK: - UITableViewDataSource
extension ChartDetailViewLineValuesDisplayManager: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = cellModels[indexPath.row]
        let factory = ChartDetailViewLineValueCellFactory(cellModel)
        return tableView.dequeueReusableCellWith(factory:factory, for: indexPath)
    }
}

// MARK: - UITableViewDelegate
extension ChartDetailViewLineValuesDisplayManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/6
    }
}



