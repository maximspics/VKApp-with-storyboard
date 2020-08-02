//
//  Attachments.swift
//  VKontakte
//
//  Created by Maxim Safronov on 27.01.2020.
//  Copyright © 2020 Maxim Safronov. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class NewsFeedAttachments: Object {
    @objc dynamic var newsFeedAttachmentsDescription: String = ""
    @objc dynamic var newsFeedAttachmentsTitle: String = ""
    @objc dynamic var newsFeedAttachmentsPhoto: String = ""
    
    convenience init?(from json: JSON) {
        self.init()
        
        guard let newsFeedAttachmentsDescription = json["link"]["description"].string else { return nil }
        self.newsFeedAttachmentsDescription = newsFeedAttachmentsDescription
        
        guard let newsFeedAttachmentsTitle = json["link"]["title"].string else { return nil }
        self.newsFeedAttachmentsTitle = newsFeedAttachmentsTitle
        
        guard let newsFeedAttachmentsPhoto = json["link"]["photo"].string else { return nil }
        self.newsFeedAttachmentsPhoto = newsFeedAttachmentsPhoto
        
        print("Attachments новости: " + "\(json)")
    }
}
