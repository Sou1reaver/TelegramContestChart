//
//  UIView+Nib.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 20/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

extension UIView {
    @discardableResult
    func fromNib<T>() -> T? where T: UIView {
        
        let bundle = Bundle(for: type(of: self))
        guard let view = bundle.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else { return nil }
        self.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        return view
    }

}

