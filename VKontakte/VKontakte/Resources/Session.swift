//
//  Session.swift
//  VKontakte
//
//  Created by Maxim Safronov on 01.12.2019.
//  Copyright © 2019 Maxim Safronov. All rights reserved.
//

import Foundation

class Session {
    private init() { }
 
    var token: String = ""
    var userId: Int =  0
    
    public static let shared = Session()
}
