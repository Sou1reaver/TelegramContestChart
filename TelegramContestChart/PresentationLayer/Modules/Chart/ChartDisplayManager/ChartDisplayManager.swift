//
//  ChartDisplayManager.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 16/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit


protocol ChartDisplayManagerDelegate: class {
    func chartsDisplayManager(_ displayManager: ChartDisplayManager, didSelectDataWith dataType: ChartAnyCellDataType, at indexPath: IndexPath)
    func chartViewControlDidChange(_ sender: ChartViewControl)
}

final class ChartDisplayManager: NSObject {
    
    // MARK: - Properties
    private weak var tableView: UITableView?
    private weak var delegate: ChartDisplayManagerDelegate?
    private var sections: [ChartSectionData] = []
    
    // MARK: - Methods
    init(tableView: UITableView, delegate: ChartDisplayManagerDelegate) {
        
        self.delegate = delegate
        self.tableView = tableView
        super.init()
        setupTableView()
    }
    
    private func setupTableView() {
        
        tableView?.registerCellsNibsWith(factories: [
            ChartCellFactory.self,
            ChartControlCellFactory.self,
            ChartLineTypeCellFactory.self,
            ChartsAppearanceCellFactory.self])
        
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.rowHeight = UITableView.automaticDimension
    }
    
    func set(_ sections: [ChartSectionData]) {
        
        self.sections = sections
        tableView?.contentInset = UIEdgeInsets.zero
        tableView?.reloadData()
    }
    
    func updateCellAt(indexPath: IndexPath, withData data: ChartAnyCellData) {
        let factory = ChartAnyCellFactory(data, chartControlCellDelegate: self)
        tableView?.updateCellAt(indexPath: indexPath, withFactory: factory)
    }
}

// MARK: UITableViewDataSource
extension ChartDisplayManager: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellModel = self.sections[indexPath.section].cellModels[indexPath.row]
        let factory = ChartAnyCellFactory(cellModel, chartControlCellDelegate: self)
        return tableView.dequeueReusableCellWith(factory:factory, for: indexPath)
    }
}

// MARK: - UITableViewDelegate
extension ChartDisplayManager: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = sections[indexPath.section].cellModels[indexPath.row]
        delegate?.chartsDisplayManager(self, didSelectDataWith: data.dataType, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
}

// MARK: - ChartControlCellDelegate
extension ChartDisplayManager: ChartControlCellDelegate {
    func chartViewControlDidChange(_ sender: ChartViewControl) {
        delegate?.chartViewControlDidChange(sender)
    }
}

