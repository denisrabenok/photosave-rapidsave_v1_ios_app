//
//  SplashViewController.swift
//  PhotoSave
//
//  Created by Michael Lee on 7/31/17.
//  Copyright © 2017 RiteshArora. All rights reserved.
//

import UIKit

fileprivate let GotoMainSegueID = "gotoMainView"
fileprivate let GotoLoginSegueID = "gotoLoginView"
fileprivate let GotoTutorialSegueID = "gotoTutorialView"

class SplashViewController: UIViewController {

    // MARK: - UIView Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        perform(#selector(gotoView), with: nil, afterDelay: 0.1)
    }
    
    // MARK: - GoTo View
    
    func gotoView() {
        let isFirstInstall = AppSetting.instance.firstInstall
        if let isFirstInstall = isFirstInstall, isFirstInstall == false {
            guard AppSetting.instance.userId != nil else {
                performSegue(withIdentifier: GotoLoginSegueID, sender: nil)
                return
            }
            
            performSegue(withIdentifier: GotoMainSegueID, sender: nil)
        }
        else {
            performSegue(withIdentifier: GotoTutorialSegueID, sender: nil)
        }
        
        AppSetting.instance.firstInstall = false
    }
}
