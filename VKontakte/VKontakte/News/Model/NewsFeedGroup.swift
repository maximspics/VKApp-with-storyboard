//
//  NewsFeedGroup.swift
//  VKontakte
//
//  Created by Maxim Safronov on 01.02.2020.
//  Copyright © 2020 Maxim Safronov. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class NewsFeedGroup: Object {
    @objc dynamic var newsFeedGroupName: String = ""
    @objc dynamic var newsFeedGroupPhoto: String = ""
    @objc dynamic var newsFeedGroupId: Int = 0
    
    convenience init(from json: JSON) {
        self.init()
        self.newsFeedGroupName = json["name"].stringValue
        self.newsFeedGroupPhoto = json["photo_50"].stringValue
        self.newsFeedGroupId = json["id"].intValue        
        print("Профиль новости: " + "\(json)")
    }
}
