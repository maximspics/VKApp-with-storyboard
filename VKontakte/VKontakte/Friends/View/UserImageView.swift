//
//  UserImageView.swift
//  VKontakte
//
//  Created by Maxim Safronov on 23/09/2019.
//  Copyright © 2019 Maxim Safronov. All rights reserved.
//

import UIKit

@IBDesignable class UserImageView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
        self.layer.borderWidth = 2
        self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height/2
    }
    
}
