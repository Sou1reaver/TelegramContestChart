//
//  ChartModuleInput.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 21/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

struct ChartModuleInitialState {
    
    let chart: Chart
    let chatWidthZoom: CGFloat
    let chatXOffsetScale: CGFloat
    let appearanceType: AppearanceType
}

protocol ChartModuleInput: AnyModuleInput {
    func set(_ initialState: ChartModuleInitialState)
}

extension ChartModuleInput {
    func setInitialData<DataType>(_ data: DataType) {
        if let state = data as? ChartModuleInitialState {
            set(state)
        }
    }
}
