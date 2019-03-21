//
//  BaseViewController.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 13/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, TransitionController {
    
    private var isFirstLayout = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isFirstLayout {
            isFirstLayout = false
            viewDidFirstLayoutSubviews()
        }
    }
    
    func viewDidFirstLayoutSubviews() {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let holder = sender as? TransitionConfigurationHolder {
            
            if let convertible = ((segue.destination as? UINavigationController)?.topViewController) as? AnyModuleInput {
                
                holder.configurationClosure(convertible)
            }
            else if let convertible = segue.destination as? AnyModuleInput {
                
                holder.configurationClosure(convertible)
            }
            else {
                
                fatalError("The destination view controller is not an instance of AnyModuleInputConvertible")
            }
        }
    }
}
