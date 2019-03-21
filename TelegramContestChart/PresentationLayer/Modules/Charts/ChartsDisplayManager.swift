//
//  ChartsDisplayManager.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 21/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

protocol ChartsDisplayManagerDelegate: class {
    func chartsDisplayManager(_ displayManager: ChartsDisplayManager, dequeueReusable cell: UITableViewCell, for indexPath: IndexPath)
    func chartsDisplayManager(_ displayManager: ChartsDisplayManager, didSelectDataWith dataType: ChartsAnyCellDataType)
    func chartsDisplayManager(_ displayManager: ChartsDisplayManager, didEndDisplaying cell: UITableViewCell, for indexPath: IndexPath)
}

final class ChartsDisplayManager: NSObject {
    
    // MARK: - Properties
    private weak var tableView: UITableView?
    private weak var delegate: ChartsDisplayManagerDelegate?
    private var sections: [ChartsSectionData] = []
    
    // MARK: - Methods
    init(tableView: UITableView, delegate: ChartsDisplayManagerDelegate) {
        
        self.delegate = delegate
        self.tableView = tableView
        super.init()
        setupTableView()
    }
    
    private func setupTableView() {
        
        tableView?.registerCellsNibsWith(factories: [
            ChartsDetailsCellFactory.self,
            ChartsAppearanceCellFactory.self])
        tableView?.registerHeaderFooterViewNibWith(factory: ChartsSectionHeaderFactory.self)
        
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.rowHeight = UITableView.automaticDimension
    }
    
    func set(_ sections: [ChartsSectionData]) {
        
        self.sections = sections
        tableView?.contentInset = UIEdgeInsets.zero
        tableView?.reloadData()
    }
    
    func updateCellAt(indexPath: IndexPath, withData data: ChartAnyCellData) {
        let factory = ChartAnyCellFactory(data)
        tableView?.updateCellAt(indexPath: indexPath, withFactory: factory)
    }
}

// MARK: UITableViewDataSource
extension ChartsDisplayManager: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellModel = self.sections[indexPath.section].cellModels[indexPath.row]
        let factory = ChartsAnyCellFactory(cellModel)
        let cell = tableView.dequeueReusableCellWith(factory:factory, for: indexPath)
        self.delegate?.chartsDisplayManager(self, dequeueReusable: cell, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.delegate?.chartsDisplayManager(self, didEndDisplaying: cell, for: indexPath)
    }
}

// MARK: - UITableViewDelegate
extension ChartsDisplayManager: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = sections[indexPath.section].cellModels[indexPath.row]
        delegate?.chartsDisplayManager(self, didSelectDataWith: data.dataType)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = sections[section]
        let factory = ChartsSectionHeaderFactory(section.headerData)
        return tableView.dequeueReusableHeaderFooterViewWith(factory: factory)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionType = sections[section].type
        switch sectionType {
        case .chart:
            return 44
        case .appearance:
            return CGFloat.leastNonzeroMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
}
