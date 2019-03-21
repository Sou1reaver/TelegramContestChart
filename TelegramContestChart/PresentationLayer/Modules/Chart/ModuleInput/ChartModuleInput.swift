//
//  ChartModuleInput.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 21/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import Foundation

protocol ChartModuleInput: AnyModuleInput {
    func setInitialChart(_ chart: Chart)
}

extension ChartModuleInput {
    func setInitialData<DataType>(_ data: DataType) {
        if let chart = data as? Chart {
            setInitialChart(chart)
        }
    }
}
