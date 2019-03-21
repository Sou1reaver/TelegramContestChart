//
//  TransitionController.swift
//  TelegramContestChart
//
//  Created by Vladimir Gordienko on 13/03/2019.
//  Copyright © 2019 Vladimir Gordienko. All rights reserved.
//

import UIKit

protocol AnyModuleInput: class {
    func setInitialData<DataType>(_ data: DataType)
}

struct TransitionConfigurationHolder {
    let configurationClosure: (AnyModuleInput) -> Void
}

protocol TransitionController {
    
    func showModule(performingSegueWithIdentifier id: String,
                    configuration: ((AnyModuleInput) -> Void)?)
}

extension TransitionController where Self: UIViewController {
    
    func showModule(performingSegueWithIdentifier id: String,
                    configuration: ((AnyModuleInput) -> Void)?) {
        
        if let conf = configuration {
            let holder = TransitionConfigurationHolder(configurationClosure: conf)
            performSegue(withIdentifier: id, sender: holder)
        } else {
            performSegue(withIdentifier: id, sender: nil)
        }
    }
    
    func removeSubmoduleWithView(_ containerView: UIView) {
        self.children.forEach {
            if containerView.subviews.contains($0.view) {
                $0.willMove(toParent: nil)
                $0.view.removeFromSuperview()
                $0.removeFromParent()
            }
        }
    }
    
    func showSubmodule(_ submodule: UIViewController,
                       onView containerView: UIView,
                       configuration: ((AnyModuleInput) -> Void)?) {
        
        self.children.forEach {
            if containerView.subviews.contains($0.view) {
                $0.willMove(toParent: nil)
                $0.view.removeFromSuperview()
                $0.removeFromParent()
            }
        }
        
        guard !(submodule is UINavigationController) && !(submodule is UITabBarController) else {
            
            fatalError("TransitionController: Submodule can not be UITabBarController or UINavigationController")
        }
        
        guard let input = submodule as? AnyModuleInput  else {
            
            fatalError("TransitionController: The destination view controller is not an instance of AnyModuleInputConvertible")
        }
        
        if let conf = configuration {
            let holder = TransitionConfigurationHolder(configurationClosure: conf)
            holder.configurationClosure(input)
            holder.configurationClosure(input)
        }
    
        self.addChild(submodule)
        containerView.addSubview(submodule.view)
        
        submodule.view.translatesAutoresizingMaskIntoConstraints = false
        submodule.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        submodule.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        submodule.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        submodule.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        submodule.didMove(toParent: self)
    }
}



