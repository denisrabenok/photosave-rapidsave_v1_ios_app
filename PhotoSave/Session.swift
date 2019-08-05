//
//  Session.swift
//  PhotoSave
//
//  Created by Michael Lee on 7/14/17.
//  Copyright © 2017 RiteshArora. All rights reserved.
//

import Foundation

class Session {
    var userId: String
    
    init() {
        userId = ""
    }
    
    init(userId: String) {
        self.userId = userId
    }
}
