//
//  ImageGroupCell.swift
//  VKontakte
//
//  Created by Maxim Safronov on 22/09/2019.
//  Copyright © 2019 Maxim Safronov. All rights reserved.
//

import UIKit

class UserImageCell: UICollectionViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var likesTextCount: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        userImage.image = nil
        likesTextCount.text = nil
    }
    
    public func configure(witch photo: Photo) {
        self.userImage.kf.setImage(with: URL(string: photo.imageCellURLString))
    }
}
