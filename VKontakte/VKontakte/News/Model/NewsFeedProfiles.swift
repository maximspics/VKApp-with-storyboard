//
//  NewsFeedAuthor.swift
//  VKontakte
//
//  Created by Maxim Safronov on 29.01.2020.
//  Copyright © 2020 Maxim Safronov. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class NewsFeedProfiles: Object {
    @objc dynamic var newsFeedProfilesId: Int = 0
    @objc dynamic var newsFeedProfilesFirstName: String = ""
    @objc dynamic var newsFeedProfilesLastName: String = ""
    @objc dynamic var newsFeedProfilesFullName: String { newsFeedProfilesFirstName + " " + newsFeedProfilesLastName }
    @objc dynamic var newsFeedProfilesAvatar: String = ""
    
    convenience init(from json: JSON) {
        self.init()
        self.newsFeedProfilesId = json["id"].intValue
        self.newsFeedProfilesFirstName = json["first_name"].stringValue
        self.newsFeedProfilesLastName = json["last_name"].stringValue
        self.newsFeedProfilesAvatar = json["photo_50"].stringValue
        print("Профиль новости: " + "\(json)")
    }
}
