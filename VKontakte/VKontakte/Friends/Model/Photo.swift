//
//  Photo.swift
//  VKontakte
//
//  Created by Maxim Safronov on 25.12.2019.
//  Copyright © 2019 Maxim Safronov. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class Photo: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var likesCount: Int = 0
    @objc dynamic var likeUser: Int = 0
    @objc dynamic var imageCellURLString: String = ""
    @objc dynamic var imageFullURLString: String = ""
    @objc dynamic var url: URL? {
        URL(string: imageFullURLString)
    }
    @objc dynamic var height: Int = 0
    @objc dynamic var width: Int = 0
    
    var aspectRatio: CGFloat? {
        guard width != 0 else { return nil }
        return CGFloat(height)/CGFloat(width)
    }
    
    convenience init?(from json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.likesCount = json["count"].intValue
        self.likeUser = json["user_likes"].intValue
        
        guard let imageSize = json["sizes"].array?.first(where: { $0["type"] == "s" }) else { return nil }
        self.imageCellURLString = imageSize["url"].stringValue
        
        if let imageCellURLString = json["sizes"].array?.first(where: { $0["type"] == "m" })?["url"].string {
            self.imageCellURLString = imageCellURLString
        }
        
        let sizes = json["sizes"].arrayValue
            .filter({ ["w", "z", "y", "x", "m"].contains($0["type"]) })
            .sorted(by: { $0["width"].intValue * $0["height"].intValue > $1["width"].intValue * $1["height"].intValue })
        
        let firstPhoto = sizes.first
        self.imageFullURLString = firstPhoto?["url"].string ?? ""
        self.width = firstPhoto?["width"].int ?? 0
        self.height = firstPhoto?["height"].int ?? 0
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
