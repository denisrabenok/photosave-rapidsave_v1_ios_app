//
//  AppSetting.swift
//  PhotoSave
//
//  Created by Michael Lee on 11/30/16.
//  Copyright © 2016 PhotoSave. All rights reserved.
//

import UIKit

fileprivate var appSetting: AppSetting? = nil

class AppSetting: AppSettingBase {
    
    static let instance : AppSetting = {
        
        if appSetting == nil {
            appSetting = AppSetting.init()
        }
        
        return appSetting!
    }()
    
    var userId: String? {
        didSet {
            self.set(stringVal: userId, forKey: "PhotoSaveUserId")
        }
    }
    
    var userName: String? {
        didSet {
            self.set(stringVal: userName, forKey: "PhotoSaveUsername")
        }
    }
    
    var instagramProfile: String? {
        didSet {
            self.set(stringVal: instagramProfile, forKey: "InstagramProfile")
        }
    }
    
    var firstInstall: Bool? {
        didSet {
            self.set(boolVal: firstInstall, forKey: "First_Install")
        }
    }
    
    var installTime = Date()
    
    override func loadSetting() {
        userId = string(forKey: "PhotoSaveUserId", defVal: nil)
        userName = string(forKey: "PhotoSaveUsername", defVal: nil)
        installTime = object(forKey: "InstallTime", defVal: Date() as AnyObject) as! Date
        instagramProfile = string(forKey: "InstagramProfile", defVal: nil)
        firstInstall = bool(forKey: "First_Install", defVal: true)
    }
}
