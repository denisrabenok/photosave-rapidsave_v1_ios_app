//
//  AppSettingBase.swift
//  PhotoSave
//
//  Created by Michael Lee on 11/30/16.
//  Copyright © 2016 idragon. All rights reserved.
//

import UIKit

class AppSettingBase: NSObject {

    static var DOCUMENT_PATH:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    static var PACKAGE_PATH:String = String.init(format: "%@/data/com.com.photosaver888/", DOCUMENT_PATH)
    
    override init() {
        
        super.init()
        self.setup()
    }
    
    public func setup() {
        self.loadSetting()
    }
    
    public func loadSetting() {
    }
    
    public func saveSetting() {
        UserDefaults.standard.synchronize()
    }
    
    public func integer(forKey:String, defVal:Int) -> Int {
        
        if ((UserDefaults.standard.object(forKey: forKey)) != nil) {
            return UserDefaults.standard.object(forKey: forKey) as! Int
        }
        
        return defVal
    }
    
    public func set(intVal:Int, forKey:String) {
        UserDefaults.standard.set(intVal, forKey: forKey)
    }
    
    public func bool(forKey:String, defVal:Bool) -> Bool {
        
        if (UserDefaults.standard.object(forKey: forKey) != nil) {
            return UserDefaults.standard.object(forKey: forKey) as! Bool
        }
        
        return defVal
    }
    
    public func set(boolVal:Bool?, forKey:String) {
        UserDefaults.standard.set(boolVal, forKey: forKey)
    }
    
    public func float(forKey:String, defVal:Float) -> Float {
        
        if (UserDefaults.standard.object(forKey: forKey) != nil) {
            return UserDefaults.standard.object(forKey: forKey) as! Float
        }
        
        return defVal
    }
    
    public func set(floatVal:Float, forKey:String) {
        UserDefaults.standard.set(floatVal, forKey: forKey)
    }
    
    public func double(forKey:String, defVal:Double) -> Double {
        
        if (UserDefaults.standard.object(forKey: forKey) != nil) {
            return UserDefaults.standard.object(forKey: forKey) as! Double
        }
        
        return defVal
    }
    
    public func set(doubleVal:Float, forKey:String) {
        UserDefaults.standard.set(doubleVal, forKey: forKey)
    }
    
    public func string(forKey:String, defVal:String?) -> String? {
        
        if (UserDefaults.standard.object(forKey: forKey) != nil) {
            return UserDefaults.standard.object(forKey: forKey) as? String
        }
        
        return defVal
    }
    
    public func set(stringVal: String?, forKey: String) {
        UserDefaults.standard.set(stringVal, forKey: forKey)
    }
    
    public func object(forKey:String, defVal:AnyObject?) -> AnyObject? {
        
        let filePath:String = String.init(format: "%@%@", AppSettingBase.PACKAGE_PATH, forKey)
        if (FileManager.default.fileExists(atPath: filePath)) {
            return NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as! NSObject
        }
        
        return defVal
    }
    
    public func set(object: AnyObject, forKey:String) {
        
        if (!FileManager.default.fileExists(atPath: AppSettingBase.PACKAGE_PATH)) {
            
            do {
                try FileManager.default.createDirectory(atPath: AppSettingBase.PACKAGE_PATH, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription);
            }
        }
        
        let savePath:String = String.init(format: "%@%@", AppSettingBase.PACKAGE_PATH, forKey)
        NSKeyedArchiver.archiveRootObject(object, toFile: savePath)
    }
}
