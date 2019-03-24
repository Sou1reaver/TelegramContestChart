//
//  UICollectionView+Factory.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 24/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func dequeueReusableCellWith(factory: AnyReusableViewFactory, for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: factory.identifier, for: indexPath)
        factory.setup(anyView: cell)
        return cell
    }
    
    func updateCellAt(indexPath:IndexPath, withFactory factory:AnyReusableViewFactory) {
        if let cell = cellForItem(at: indexPath) {
            factory.setup(anyView: cell)
        }
    }
    
    func registerCellsNibsWith(factories: [AnyReusableViewFactory.Type]) {
        factories.forEach {
            let id = String(describing: $0.wrappedType)
            let nib = UINib(nibName: id, bundle: nil)
            register(nib, forCellWithReuseIdentifier: id)
        }
    }
    
    func registerCellNibWith(factory: AnyReusableViewFactory.Type) {
        registerCellsNibsWith(factories: [factory])
    }
}
