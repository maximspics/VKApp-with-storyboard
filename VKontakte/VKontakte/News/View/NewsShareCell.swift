//
//  NewsShareCell.swift
//  VKontakte
//
//  Created by Maxim Safronov on 27.01.2020.
//  Copyright © 2020 Maxim Safronov. All rights reserved.
//

import UIKit

class NewsShareCell: UITableViewCell {
    
    @IBOutlet weak var viewsCount: UILabel!
    @IBOutlet weak var repostCount: UILabel!
    @IBOutlet weak var commentsCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureNewsShareCellNewsFeedItems (with newsFeedItemsCell: NewsFeedItem, indexPath: IndexPath?) {
        viewsCount.text = String(newsFeedItemsCell.newsFeedItemViews)
        repostCount.text = String(newsFeedItemsCell.newsFeedItemReposts)
        commentsCount.text = String(newsFeedItemsCell.newsFeedItemComments)
    }
}
