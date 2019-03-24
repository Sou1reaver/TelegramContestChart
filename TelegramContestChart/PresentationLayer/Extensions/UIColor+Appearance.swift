//
//  UIColor+Appearance.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 24/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func navigationBarColorWith(appearanceType: AppearanceType) -> UIColor {
        switch appearanceType {
        case .light:
            return .white
        case .dark:
            return UIColor(red: 36.0/255.0, green: 48.0/255.0, blue: 63.0/255.0, alpha: 1)
        }
    }
    
    static func navigationBarTitleColorWith(appearanceType: AppearanceType) -> UIColor {
        switch appearanceType {
        case .light:
            return .black
        case .dark:
            return .white
        }
    }
    
    static func tableViewBackgroundColorWith(appearanceType: AppearanceType) -> UIColor {
        switch appearanceType {
        case .light:
            return UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 243.0/255.0, alpha: 1)
        case .dark:
            return UIColor(red: 26.0/255.0, green: 34.0/255.0, blue: 44.0/255.0, alpha: 1)
        }
    }
    
    static func chartModuleBackgroundColorWith(appearanceType: AppearanceType) -> UIColor {
        switch appearanceType {
        case .light:
            return .white
        case .dark:
            return UIColor(red: 36.0/255.0, green: 48.0/255.0, blue: 63.0/255.0, alpha: 1)
        }
    }
    
    static func chartModuleCellColorWith(appearanceType: AppearanceType) -> UIColor {
        switch appearanceType {
        case .light:
            return .white
        case .dark:
            return UIColor(red: 36.0/255.0, green: 48.0/255.0, blue: 63.0/255.0, alpha: 1)
        }
    }
    
    static func chartLineTypeCellTextColorWith(appearanceType: AppearanceType) -> UIColor {
        switch appearanceType {
        case .light:
            return .black
        case .dark:
            return .white
        }
    }
    
    static func textColorWith(appearanceType: AppearanceType) -> UIColor {
        switch appearanceType {
        case .light:
            return UIColor(red: 172.0/255.0, green: 176.0/255.0, blue: 180.0/255.0, alpha: 1)
        case .dark:
            return UIColor(red: 90.0/255.0, green: 100.0/255.0, blue: 120.0/255.0, alpha: 1)
        }
    }
    
    static func titleTextColorWith(appearanceType: AppearanceType) -> UIColor {
        switch appearanceType {
        case .light:
            return UIColor(red: 115.0/255.0, green: 115.0/255.0, blue: 120.0/255.0, alpha: 1)
        case .dark:
            return UIColor(red: 90.0/255.0, green: 100.0/255.0, blue: 120.0/255.0, alpha: 1)
        }
    }
}
