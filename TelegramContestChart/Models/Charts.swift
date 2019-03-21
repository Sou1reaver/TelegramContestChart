//
//  Chart.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 11/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import Foundation

enum ChartsDecodeError: Error {
    case invalidKey
}

struct Charts: Decodable {
    
    private(set) var list: [Chart]
    
    init(from coder: Decoder) throws {
        
        var container = try coder.unkeyedContainer()
        list = []
        
        while !container.isAtEnd {
            let chart = try container.decode(Chart.self)
            list.append(chart)
        }
    }
}

struct Chart: Decodable {
    private let timestampKey = "x"
    private(set) var dates: [Date]
    private(set) var lines: [Line]
    
    enum CodingKeys: String, CodingKey {
        case columns = "columns"
        case colors = "colors"
        case names = "names"
    }
    
    init(from coder: Decoder) throws {
        let container = try coder.container(keyedBy: CodingKeys.self)

        var columnsContainer = try container.nestedUnkeyedContainer(forKey: .columns)
        
        let colorsDict = try container.decode([String:String].self, forKey: .colors)
        let namesDict = try container.decode([String:String].self, forKey: .names)
        
        dates = []
        lines = []
        
        while !columnsContainer.isAtEnd {
            var columnContainer = try columnsContainer.nestedUnkeyedContainer()
            var key: String!
            var values: [Int] = []
            while !columnContainer.isAtEnd {
                if key == nil {
                    key = try columnContainer.decode(String.self)
                    continue
                }
                switch key {
                case timestampKey:
                    let value = try columnContainer.decode(TimeInterval.self)
                    dates.append(Date(timeIntervalSince1970: value))
                default:
                    let value = try columnContainer.decode(Int.self)
                    values.append(value)
                }
            }
            
            switch key {
            case timestampKey:
                continue
            default:
                let name = namesDict[key]
                let color = colorsDict[key]
                guard let unwrapName = name, let unwrapHexColor = color else {
                    throw ChartsDecodeError.invalidKey
                }
                let graph = Line(key: key,
                                  values: values,
                                  edgeHexColor: unwrapHexColor,
                                  name: unwrapName)
                lines.append(graph)
            }

        }

    }
}

struct Line: Hashable {

    let key: String
    let values: [Int]
    let edgeHexColor: String
    let name: String
}



