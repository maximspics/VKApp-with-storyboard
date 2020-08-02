//
//  NewsImageView.swift
//  VKontakte
//
//  Created by Maxim Safronov on 10.11.2019.
//  Copyright © 2019 Maxim Safronov. All rights reserved.
//

import UIKit

@IBDesignable class NewsImageView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
        self.layer.borderWidth = 2
        self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.05)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
    }
    
}
