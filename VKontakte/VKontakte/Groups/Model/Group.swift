//
//  Group.swift
//  VKontakte
//
//  Created by Maxim Safronov on 21.11.2019.
//  Copyright © 2019 Maxim Safronov. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Group: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var imageName: String = ""
    
    convenience init(from json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.imageName = json["photo_100"].stringValue
        print("Группы: " + "\(json)")
    }

    static func == (lhs: Group, rhs: Group) -> Bool {
        return lhs.name == rhs.name && lhs.imageName == rhs.imageName
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
