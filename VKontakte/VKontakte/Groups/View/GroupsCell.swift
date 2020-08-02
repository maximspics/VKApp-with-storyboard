//
//  GroupsCell.swift
//  VKontakte
//
//  Created by Maxim Safronov on 04/10/2019.
//  Copyright © 2019 Maxim Safronov. All rights reserved.
//

import UIKit

class GroupsCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        itemImage.image = nil
    }
    
    public func configure(witch group: Group) {
        self.nameLabel.text = group.name
        self.itemImage.kf.setImage(with: URL(string: group.imageName))
    }
}
