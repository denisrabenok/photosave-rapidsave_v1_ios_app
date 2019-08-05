//
//  MixPanelHelper.swift
//  PhotoSave
//
//  Created by Michael Lee on 7/21/17.
//  Copyright © 2017 RiteshArora. All rights reserved.
//

import Foundation
import AdSupport
import Mixpanel

fileprivate var mixpanelHelper: MixPanelHelper? = nil

class MixPanelHelper {
    
    var ipAddress: String?
    var installTimeString: String?
    var language: String?
    var IDFAId: String?
    var deviceModel: String?
    var deviceOSVersion: String?
    
    static let instance : MixPanelHelper = {
        
        if mixpanelHelper == nil {
            mixpanelHelper = MixPanelHelper.init()
        }
        
        mixpanelHelper?.loadProperties()
        return mixpanelHelper!
    }()
    
    func loadProperties() {
        ipAddress = getWiFiAddress()
        installTimeString = getPSTInstallTimeString()
        language = Locale.current.languageCode
        IDFAId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        deviceModel = UIDevice.current.modelName
        deviceOSVersion = UIDevice.current.systemName + UIDevice.current.systemVersion
    }
    
    func setMixPanelProperties() {
        
        if checkAfter7DaysFromInstall() == true {
            return
        }
        
        Mixpanel.mainInstance().people.set(properties: ["IP Address" : ipAddress ?? "",
                                                        "Installation Time" : installTimeString ?? "",
                                                        "Language" : language ?? "",
                                                        "Insta Profile" : AppSetting.instance.instagramProfile ?? "",
                                                        "Device Id" : IDFAId ?? "",
                                                        "Devcie Model" : deviceModel ?? "",
                                                        "Device OS Version" : deviceOSVersion ?? ""])
    }
    
    func checkAfter7DaysFromInstall() -> Bool {
        let c = Calendar.current
        let d1 = Date()
        let d2 = AppSetting.instance.installTime
        let components = c.dateComponents([Calendar.Component.day], from: d2, to: d1)
        guard let diffDays = components.day else {
            return true
        }
        
        return diffDays > 7
    }
    
    func getPSTInstallTimeString() -> String? {
        let installTime = AppSetting.instance.installTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")
        return dateFormatter.string(from: installTime)
    }
    
    func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
}
