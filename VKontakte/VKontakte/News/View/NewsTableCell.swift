//
//  NewsTableCell.swift
//  VKontakte
//
//  Created by Maxim Safronov on 27.01.2020.
//  Copyright © 2020 Maxim Safronov. All rights reserved.
//

import UIKit
import Kingfisher

class NewsTableCell: UITableViewCell {
    
    @IBOutlet weak var newsSourceName: UILabel!
    @IBOutlet weak var newsSourceAvatar: UIImageView!
    @IBOutlet weak var newsDate: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
//    func configureAllNews (with newsCellContent: ((NewsFeedItems), (NewsFeedProfiles), (NewsFeedGroup), (NewsFeedAttachments)), indexPath: IndexPath?) {
//        let humanDate = Date(timeIntervalSince1970: Double(newsCellContent.0.newsFeedItemsDate)!)
//        let dateFormatter = DateFormatter()
//        dateFormatter.timeStyle = .medium
//        dateFormatter.dateStyle = DateFormatter.Style.medium
//        dateFormatter.timeZone = .current
//        let localDate = dateFormatter.string(from: humanDate)
//        newsDate.text = localDate
//        newsSourceName.text = newsCellContent.2.newsFeedGroupName
//        newsSourceAvatar.kf.setImage(with: URL(string: newsCellContent.2.newsFeedGroupPhoto))
//        newsDescription.text = newsCellContent.3.newsFeedAttachmentsDescription
//        newsTitle.text = newsCellContent.3.newsFeedAttachmentsTitle
//    }

    func configureNewsTableCellNewsFeedGroup (with newsCellContent: NewsFeedGroup, indexPath: IndexPath?) {
        newsSourceName.text = newsCellContent.newsFeedGroupName
        newsSourceAvatar.kf.setImage(with: URL(string: newsCellContent.newsFeedGroupPhoto))
    }

    func configureNewsTableCellNewsFeedItems (with newsFeedItemsCell: NewsFeedItem, indexPath: IndexPath?) {
        let humanDate = Date(timeIntervalSince1970: newsFeedItemsCell.date)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: humanDate)
        newsDate.text = localDate
    }

    func configureNewsTableCellNewsFeedAttachments (with newsCellContent: NewsFeedAttachments, indexPath: IndexPath?) {
        newsDescription.text = newsCellContent.newsFeedAttachmentsDescription
        newsTitle.text = newsCellContent.newsFeedAttachmentsTitle
    }
    
}
