//
//  ChartSectionData.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 16/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import Foundation

enum ChartSectionType: Int {
    case charts
    case lines
}

enum ChartAnyCellDataType {
    case chart
    case chartControl
    case lineType(title: String)
}

protocol ChartAnyCellData {
    var dataType: ChartAnyCellDataType { get }
    var appearanceType: AppearanceType { get }
}

struct ChartSectionData {
    let type: ChartSectionType
    let cellModels: [ChartAnyCellData]
}
