//
//  ChartDetailViewDisplayManager.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 24/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

final class ChartDetailViewDatesDisplayManager: NSObject {
    
    // MARK: - Properties
    private weak var collectionView: UICollectionView?
    private var cellModels: [String] = []
    
    var itemSize: CGSize {
        let screenWidth = collectionView?.bounds.size.width ?? 0
        let itemsCount: CGFloat = 6
        let width = trunc(screenWidth / itemsCount)
        let height: CGFloat = 44
        return CGSize(width: width, height: height)
    }
    
    // MARK: - Methods
    init(collectionView: UICollectionView) {
        super.init()
        
        collectionView.registerCellNibWith(factory: ChartDetailViewDateCellFactory.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.collectionView = collectionView
    }
    
    func set(_ cellModels: [String]) {
        
        self.cellModels = cellModels
        collectionView?.reloadData()
    }
    
    func updateCellAt(indexPath: IndexPath, withData data: String) {
        let factory = ChartDetailViewDateCellFactory(data)
        collectionView?.updateCellAt(indexPath: indexPath, withFactory: factory)
    }
}

// MARK: UICollectionViewDataSource
extension ChartDetailViewDatesDisplayManager: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellModel = cellModels[indexPath.row]
        let factory = ChartDetailViewDateCellFactory(cellModel)
        return collectionView.dequeueReusableCellWith(factory:factory, for: indexPath)
    }
}

// MARK: UICollectionViewDelegate
extension ChartDetailViewDatesDisplayManager: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
}


