//
//  GroupXibCell.swift
//  VKontakte
//
//  Created by Maxim Safronov on 13.11.2019.
//  Copyright © 2019 Maxim Safronov. All rights reserved.
//

import UIKit

class GroupXibCell: UITableViewCell {
    
    @IBOutlet weak var groupTitle: UILabel!
    @IBOutlet weak var groupDescription: UILabel!
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var imageShadow: UserImageShadow!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        groupTitle.text = nil
        groupImage.image = nil
    }
    
    public func configure(witch group: Group) {
        self.groupTitle.text = group.name
        self.groupImage.kf.setImage(with: URL(string: group.imageName))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        UIView.animate(withDuration: 0.6, delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: [],
                       animations:  {
                        self.imageShadow.bounds.size.height *= 2
        })
    }
}
