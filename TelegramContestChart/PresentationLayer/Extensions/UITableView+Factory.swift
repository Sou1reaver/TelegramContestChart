//
//  UITableView+Factory.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 13/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

public extension UITableView {
    func dequeueReusableCellWith(factory: AnyReusableViewFactory, for indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: factory.identifier, for: indexPath)
        factory.setup(anyView: cell)
        
        return cell
    }
    
    func dequeueReusableCellWith(factory: AnyReusableViewFactory) -> UITableViewCell? {
        guard let cell = dequeueReusableCell(withIdentifier: factory.identifier) else { return nil }
        factory.setup(anyView: cell)
        
        return cell
    }
    
    func dequeueReusableHeaderFooterViewWith(factory: AnyReusableViewFactory) -> UITableViewHeaderFooterView? {
        
        guard let header = dequeueReusableHeaderFooterView(withIdentifier: factory.identifier) else { return nil }
        factory.setup(anyView: header)
        
        return header
    }
    
    func updateCellAt(indexPath:IndexPath, withFactory factory:AnyReusableViewFactory) {
        if let cell = cellForRow(at: indexPath) {
            factory.setup(anyView: cell)
        }
    }
    
    func registerCellsNibsWith(factories: [AnyReusableViewFactory.Type]) {
        factories.forEach {
            let id = String(describing: $0.wrappedType)
            let nib = UINib(nibName: id, bundle: nil)
            register(nib, forCellReuseIdentifier: id)
        }
    }
    
    func registerCellNibWith(factory: AnyReusableViewFactory.Type) {
        registerCellsNibsWith(factories: [factory])
    }
    
    func registerHeaderFooterViewNibWith(factory: AnyReusableViewFactory.Type) {
        
        let id = String(describing: factory.wrappedType)
        let nib = UINib(nibName: id, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: id)
    }
}
