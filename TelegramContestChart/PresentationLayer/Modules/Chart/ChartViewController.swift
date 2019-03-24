//
//  ChartViewController.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 13/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

private struct ChartModuleState {
    
    enum AppearanceType {
        case light
        case dark
    }
    
    var appearanceType: AppearanceType = .light
    var chart: Chart!

    var selectedLinesTitles = Set<String>()
    var sections: [ChartSectionData] = []
    
    var chatWidthZoom: CGFloat = 1
    var chatXOffsetScale: CGFloat = 1
}

class ChartViewController: BaseViewController {
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.alwaysBounceVertical = false
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        return tableView
    }()
    private let controllerQueue = DispatchQueue(label: "ChartViewControllerQueue")
    private var state = ChartModuleState()
    
    private lazy var displayManager: ChartDisplayManager = {
        
        let displayManager = ChartDisplayManager(tableView: tableView, delegate: self)
        return displayManager
    }()
    
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        return dateFormatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidFirstLayoutSubviews() {
        display(chart: state.chart, selectedAllLines: true)
    }
    
    private func createSections(with chartDetailData:ChartDetailViewData) -> [ChartSectionData] {
        
        var sections:[ChartSectionData] = []
        
        let chartsCellModels:[ChartAnyCellData] =
            [ChartCellData(chart: chartDetailData, chatWidthZoom: state.chatWidthZoom, chatXOffsetScale: state.chatXOffsetScale),
             ChartControlCellData(chartData: chartDetailData.chartViewData)]
        sections.append(ChartSectionData(type: .charts, cellModels: chartsCellModels))
        
        let linesCells = self.state.chart.lines.compactMap({ [weak self] in
            return self?.chartsLineTypeCellDataWith(line: $0)
        })
        if !linesCells.isEmpty {
            sections.append(ChartSectionData(type: .lines, cellModels: linesCells))
        }
                
        return sections
    }
    
    private func chartsLineTypeCellDataWith(line: Line) -> ChartAnyCellData {
        
        let showSeparator = line != state.chart?.lines.last
        let selected = state.selectedLinesTitles.contains(where: {$0 == line.name})
        return ChartLineTypeCellData(line: line, selected: selected, showSeparator: showSeparator)
    }
    
    private func display(chart: Chart, selectedAllLines: Bool = false) {
        
        self.controllerQueue.async {[weak self] in
            guard let `self` = self else { return }
            var chartViewLines = [ChartViewLine]()
            var maxLineValuesCount = 0
            var maxLineValue = 0
            
            for line in chart.lines {
                
                let lineSelected: Bool
                if selectedAllLines && !self.state.selectedLinesTitles.contains(line.name) {
                    self.state.selectedLinesTitles.insert(line.name)
                    lineSelected = true
                } else {
                    lineSelected = self.state.selectedLinesTitles.contains(line.name)
                }
                if lineSelected {
                    if maxLineValuesCount < line.values.count {
                        maxLineValuesCount = line.values.count
                    }
                    if let max = line.values.max(), maxLineValue < max {
                        maxLineValue = max
                    }
                    chartViewLines.append(ChartViewLine(values: line.values, color: UIColor(hexString: line.edgeHexColor)))
                }
            }
            
            let chartViewData = ChartViewData.init(lines: chartViewLines, maxLineValuesCount: maxLineValuesCount, maxLineValue: maxLineValue)
            let dt = self.dateFormatter
            let stringDates: [String] = chart.dates.compactMap({dt.string(from: $0)})
            let chartDetailsData = ChartDetailViewData(chartViewData: chartViewData, dates: stringDates)
            self.state.sections = self.createSections(with: chartDetailsData)
            DispatchQueue.main.async {[weak self] in
                guard let sections = self?.state.sections else { return }
                self?.displayManager.set(sections)
            }
        }
    }
}

// MARK: - ImageEditModuleInput
extension ChartViewController: ChartModuleInput {
    func set(_ initialState: ChartModuleInitialState) {
        state.chart = initialState.chart
        state.chatWidthZoom = initialState.chatWidthZoom
        state.chatXOffsetScale = initialState.chatXOffsetScale
    }
}

// MARK: - ChartDisplayManagerDelegate
extension ChartViewController: ChartDisplayManagerDelegate {
    func chartsDisplayManager(_ displayManager: ChartDisplayManager, didSelectDataWith dataType: ChartAnyCellDataType, at indexPath: IndexPath) {
        
        switch dataType {
        case .chart:
            break
        case .chartControl:
            break
        case .lineType (let title):

            if state.selectedLinesTitles.contains(title) {
                state.selectedLinesTitles.remove(title)
            } else {
                state.selectedLinesTitles.insert(title)
            }
            if let chart = state.chart {
                display(chart: chart)
            }
        }
    }
    
    func chartsDisplayManager(_ displayManager: ChartDisplayManager, didChangeChatWidthZoom zoom: CGFloat, and xOffsetScale: CGFloat) {
        
        state.chatWidthZoom = zoom
        state.chatXOffsetScale = xOffsetScale
        if let chart = state.chart {
            display(chart: chart)
        }
    }
}

