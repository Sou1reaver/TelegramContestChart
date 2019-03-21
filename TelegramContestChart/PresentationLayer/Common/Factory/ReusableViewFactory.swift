//
//  ReusableViewFactory.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 13/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

public protocol AnyReusableViewFactory {
    static var wrappedType: UIView.Type { get }
    
    var identifier: String { get }
    func setup(anyView: UIView)
}

public protocol ReusableViewFactory: AnyReusableViewFactory {
    associatedtype ViewType: UIView
    func setup(view: ViewType)
}

extension ReusableViewFactory {
    public static var wrappedType: UIView.Type {
        return ViewType.self
    }
    
    public var identifier: String {
        return String(describing: type(of: self).wrappedType)
    }
    
    public func setup(anyView: UIView) {
        guard let view = anyView as? ViewType else { fatalError("Given cell is not an instance of \(String(describing: ViewType.self))") }
        setup(view: view)
    }
}
