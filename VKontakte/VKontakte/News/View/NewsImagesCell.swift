//
//  NewsImagesCell.swift
//  VKontakte
//
//  Created by Maxim Safronov on 10.11.2019.
//  Copyright © 2019 Maxim Safronov. All rights reserved.
//

import UIKit

class NewsImagesCell: UICollectionViewCell {
    @IBOutlet weak var newsImages: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        newsImages.image = nil
    }
}
