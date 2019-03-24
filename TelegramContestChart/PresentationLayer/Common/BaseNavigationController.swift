//
//  BaseNavigationController.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 24/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        switch appearanceType {
        case .light:
            return .default
        case .dark:
            return .lightContent
        }
    }
    
    var appearanceType: AppearanceType = .light {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
}
