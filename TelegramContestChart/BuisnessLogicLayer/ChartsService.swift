//
//  ChartService.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 13/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import Foundation


class ChartsService {
    
    private let serviceQueue = DispatchQueue(label: "ChartsServiceQueue")
    weak var output: ChartsServiceOutput?
    
    func obtainCharts() {
        serviceQueue.async { [weak self] in
            if let path = Bundle.main.path(forResource: "chart_data", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let charts = try JSONDecoder().decode(Charts.self, from: data)
                    DispatchQueue.main.async {
                        self?.output?.didObtainCharts(charts, withError: nil)
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        self?.output?.didObtainCharts(nil, withError: error)
                    }
                }
            }
        }
    }
}

protocol ChartsServiceOutput: class {
    func didObtainCharts(_ charts: Charts?, withError error: Error?)
}
