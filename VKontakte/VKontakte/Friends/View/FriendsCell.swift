//
//  FriebdsCell.swift
//  VKontakte
//
//  Created by Maxim Safronov on 04/10/2019.
//  Copyright © 2019 Maxim Safronov. All rights reserved.
//

import UIKit
import Kingfisher

class FriendsCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var universityLabel: UILabel!
    @IBOutlet weak var homeTownLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        itemImage.image = nil
    }
    public func
        configure(witch friend: User) {
        self.nameLabel.text = friend.fullName
        self.homeTownLabel.text = friend.homeTown
        self.itemImage.kf.setImage(with: URL(string: friend.photo100URLString))
        
        if let universityName = friend.universityName.first?.name {
            self.universityLabel.text = universityName
        } else {
            self.universityLabel.isHidden = true
        }
    }
}
