//
//  InstagramLoginExecutive.swift
//  PhotoSave
//
//  Created by Michael Lee on 7/14/17.
//  Copyright © 2017 RiteshArora. All rights reserved.
//

import Foundation
import SwiftyJSON

//
// Display
//

protocol InstagramLoginDisplay: class {
    func loadDisplay(_ url: String)
    func gotoMain(session: Session)
}

//
// Executive
//

fileprivate let InstagramLoginURL = "https://www.instagram.com/accounts/login/"
fileprivate let InstagramHomeURL = "https://www.instagram.com/"
fileprivate let CookieField = "Cookie"
fileprivate let CookieSeparator = "; "
fileprivate let SessionIdFiled = "sessionid"
fileprivate let KeyValueSeprator = "="
fileprivate let SessionIdSeparator = ":"
fileprivate let BracketBegin = "{"

class InstagramLoginExecutive {
    
    weak var display: InstagramLoginDisplay?
    
    init(_ display: InstagramLoginDisplay) {
        self.display = display
    }
    
    func checkShouldStartRequest(_ request: URLRequest, userName: String?) -> Bool {
        
        guard let URLString = request.url?.absoluteString else {
            return true
        }
        print("URL String \(URLString)")
        
        if URLString == InstagramHomeURL {
            print("Request Headers: \(request.allHTTPHeaderFields!)")
            guard let cookies = HTTPCookieStorage.shared.cookies else {
                return true
            }
            
            guard let session = parseCookies(cookies) else {
                return true
            }
            
            AppSetting.instance.userId = session.userId
            if let userName = userName, !userName.isEmpty {
                AppSetting.instance.instagramProfile = userName
            }
            display?.gotoMain(session: session)
            return true
        }
        return true
    }
    
    private func parseCookies(_ cookies: [HTTPCookie]) -> Session? {
        let cookieDictionary = HTTPCookie.requestHeaderFields(with: cookies)
        let cookieJson = JSON(cookieDictionary)
        guard let cookieString = cookieJson[CookieField].string else {
            return nil
        }
        
        let components = cookieString.components(separatedBy: CookieSeparator)
        let sessionIds = components.filter { (cookieComponents) -> Bool in
            let keyValue = cookieComponents.components(separatedBy: KeyValueSeprator)
            if keyValue.count != 2 {
                return false
            }
            guard let key = keyValue.first, key == SessionIdFiled else {
                return false
            }
            return true
        }
        guard !sessionIds.isEmpty,
            let sessionIdEncoded = sessionIds.first,
            let sessionId = sessionIdEncoded.decodeUrl() else {
            return nil
        }
        guard let sessionIdValues = sessionId.index(of: "{") else {
            return nil
        }
        let sessionUserString = sessionId.substring(from: sessionIdValues)
        let sessionUserJson = JSON.parse(sessionUserString)
        guard let authUserId = sessionUserJson["_auth_user_id"].int else {
            return nil
        }
        return Session(userId: String(authUserId))
    }
    
    func displayDidLoad() {
        display?.loadDisplay(InstagramLoginURL)
    }
}
