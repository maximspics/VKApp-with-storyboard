//
//  NewsFeed.swift
//  VKontakte
//
//  Created by Maxim Safronov on 21.01.2020.
//  Copyright © 2020 Maxim Safronov. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class NewsFeedItem: Object {
    @objc dynamic var date: Double = 0
    @objc dynamic var newsFeedItemViews: Int = 0
    @objc dynamic var newsFeedItemComments: Int = 0
    @objc dynamic var newsFeedItemReposts: Int = 0
    @objc dynamic var newsFeedItemSourceId: Int = 0
    @objc dynamic var newsFeedItemText: String = ""
    let newsFeedItemDescription: List<NewsFeedAttachments> = List<NewsFeedAttachments>()
    let newsFeedItemPhoto:  List<NewsFeedAttachments> = List<NewsFeedAttachments>()
    let newsFeedItemTitle: List<NewsFeedAttachments> = List<NewsFeedAttachments>()
    let photos: List<Photo> = List<Photo>()

    convenience init(from json: JSON) {
        self.init()
        self.date = json["date"].doubleValue
        self.newsFeedItemViews = json["views"]["count"].intValue
        self.newsFeedItemComments = json["comments"]["count"].intValue
        self.newsFeedItemReposts = json["reposts"]["count"].intValue
        self.newsFeedItemSourceId = json["source_id"].intValue
        self.newsFeedItemText = json["text"].stringValue
        
        let description = json["attachments"].arrayValue.compactMap { NewsFeedAttachments(from: $0) }
        self.newsFeedItemDescription.append(objectsIn: description)
        
        let photo = json["attachments"].arrayValue.compactMap { NewsFeedAttachments(from: $0) }
        self.newsFeedItemPhoto.append(objectsIn: photo)
        
        let title = json["attachments"].arrayValue.compactMap { NewsFeedAttachments(from: $0) }
        self.newsFeedItemTitle.append(objectsIn: title)
        
        let photosArray = json["attachments"].arrayValue.filter { $0["type"] == "photo" }.compactMap { Photo(from: $0["photo"]) }
        self.photos.append(objectsIn: photosArray)
        
        print("NewsFeedItems Новости: " + "\(json)")
    }
}
