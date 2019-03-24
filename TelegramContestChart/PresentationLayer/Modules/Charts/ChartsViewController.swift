//
//  ChartsViewController.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 21/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

enum AppearanceType {
    case light
    case dark
}

private struct ChartsModuleState {
    
    var appearanceType: AppearanceType = .light
    var charts: Charts?
    
    var sections: [ChartsSectionData] = []
}

class ChartsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    private let controllerQueue = DispatchQueue(label: "ChartsViewControllerQueue")
    private lazy var displayManager: ChartsDisplayManager = {
        
        let displayManager = ChartsDisplayManager(tableView: tableView, delegate: self)
        return displayManager
    }()
    
    private lazy var chartsService: ChartsService = {
        let service = ChartsService()
        service.output = self
        return service
    }()
    private var state = ChartsModuleState()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshUI()
    }
    
    override func viewDidFirstLayoutSubviews() {
        self.chartsService.obtainCharts()
    }
    
    func calculateHeightFor(_ chart: Chart) -> CGFloat {

        let chartDetailViewHeight: CGFloat = 350
        let chartControlViewHeight: CGFloat = 50
        let lineSelectionHeight: CGFloat = 45
        let linesCount = CGFloat(chart.lines.count)
        return chartDetailViewHeight+chartControlViewHeight+lineSelectionHeight*linesCount
    }
    
    private func createSections(with charts:Charts) -> [ChartsSectionData] {
        
        let appearanceCellTitle: String
        switch self.state.appearanceType {
        case .light:
            appearanceCellTitle = "Switch to Night Mode"
        case .dark:
            appearanceCellTitle = "Switch to Day Mode"
        }
        
        var sections:[ChartsSectionData] = []
        let chartDetailsCellModels = charts.list.compactMap({ _ in ChartsDetailsCellData(appearanceType: state.appearanceType) })
        if !chartDetailsCellModels.isEmpty {
            let chartDetailsHeaderData = ChartsSectionHeaderData(title: "Charts", appearanceType: state.appearanceType)
            sections.append(ChartsSectionData(type: .chart,
                                              headerData: chartDetailsHeaderData,
                                              cellModels: chartDetailsCellModels))
        }
        
        let appearanceHeaderData = ChartsSectionHeaderData(title: "", appearanceType: state.appearanceType)
        let appearanceCellModels = [ChartsAppearanceCellData(appearanceType:state.appearanceType, title: appearanceCellTitle)]
        sections.append(ChartsSectionData(type: .appearance,
                                          headerData: appearanceHeaderData,
                                          cellModels: appearanceCellModels))
        return sections
    }
    
    private func displayCharts(charts: Charts) {
        controllerQueue.sync { [weak self] in
            guard let sections = self?.createSections(with: charts) else { return }
            self?.state.sections = sections
            DispatchQueue.main.async { [weak self] in
                self?.displayManager.set(sections)
            }
        }
    }
}

// MARK: - ChartsDisplayManagerDelegate
extension ChartsViewController: ChartsDisplayManagerDelegate {
    
    func chartsDisplayManager(_ displayManager: ChartsDisplayManager, dequeueReusable cell: UITableViewCell, for indexPath: IndexPath) {
        
        let section = state.sections[indexPath.section]
        
        switch section.type {
        case .chart:
            guard let charts = state.charts, let chartCell = cell as? ChartsDetailsCell else { break }
            let chart = charts.list[indexPath.row]
            let height = calculateHeightFor(chart)
            chartCell.heightContainer.constant = height
            let appearanceType = state.appearanceType
            showSubmodule(ChartViewController(), onView: chartCell.containerView, configuration: { (moduleInput) in
                let initialState = ChartModuleInitialState(chart: chart, chatWidthZoom: 1, chatXOffsetScale: 1, appearanceType: appearanceType)
                moduleInput.setInitialData(initialState)
            })
        case .appearance:
            break
        }
    }
    
    func chartsDisplayManager(_ displayManager: ChartsDisplayManager, didEndDisplaying cell: UITableViewCell, for indexPath: IndexPath) {
        guard let chartCell = cell as? ChartsDetailsCell else { return }
        removeSubmoduleWithView(chartCell.containerView)
    }
    
    func chartsDisplayManager(_ displayManager: ChartsDisplayManager, didSelectDataWith dataType: ChartsAnyCellDataType) {
        
        switch dataType {
        case .chart:
            break
        case .appearance:
            switchAppearance()
        }
    }
    
    private func switchAppearance() {
        switch self.state.appearanceType {
        case .light:
            state.appearanceType = .dark
        case .dark:
            state.appearanceType = .light
        }
        refreshUI()
    }
    
    private func refreshUI() {
        navigationController?.navigationBar.barTintColor = UIColor.navigationBarColorWith(appearanceType: state.appearanceType)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.navigationBarTitleColorWith(appearanceType: state.appearanceType)]
        
        let navVC = navigationController as? BaseNavigationController
        navVC?.appearanceType = state.appearanceType
        tableView.backgroundColor = UIColor.tableViewBackgroundColorWith(appearanceType: state.appearanceType)
        
        if let charts = state.charts {
            displayCharts(charts: charts)
        }
    }
}


// MARK: - ChartsServiceOutput

extension ChartsViewController: ChartsServiceOutput {
    func didObtainCharts(_ charts: Charts?, withError error: Error?) {
        if let charts = charts {
            state.charts = charts
            refreshUI()
        }
        if let error = error {
            print(error.localizedDescription)
        }
    }
}
