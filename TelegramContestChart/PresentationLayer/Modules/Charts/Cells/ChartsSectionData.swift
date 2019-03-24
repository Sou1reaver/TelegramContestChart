//
//  ChartsSectionData.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 21/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import Foundation

enum ChartsSectionType: Int {
    case chart
    case appearance
}

enum ChartsAnyCellDataType:Int {
    case chart
    case appearance
}

protocol ChartsAnyCellData {
    var dataType: ChartsAnyCellDataType { get }
    var appearanceType: AppearanceType { get }
}

struct ChartsSectionData {
    let type: ChartsSectionType
    let headerData: ChartsSectionHeaderData
    let cellModels: [ChartsAnyCellData]
}
