//
//  NewsImageCell.swift
//  VKontakte
//
//  Created by Maxim Safronov on 27.01.2020.
//  Copyright © 2020 Maxim Safronov. All rights reserved.
//

import UIKit
import Kingfisher

class NewsImageCell: UITableViewCell {
    
    @IBOutlet weak var newsImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureNewsImageCellNewsFeedAttachments (with newsFeedAttachmentsCell: NewsFeedAttachments, indexPath: IndexPath?) {
        newsImage.kf.setImage(with: URL(string: newsFeedAttachmentsCell.newsFeedAttachmentsPhoto))
    }
}
