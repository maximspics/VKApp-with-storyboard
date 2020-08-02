//
//  UserImageShadow.swift
//  VKontakte
//
//  Created by Maxim Safronov on 23/09/2019.
//  Copyright © 2019 Maxim Safronov. All rights reserved.
//

import UIKit

@IBDesignable class UserImageShadow: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.shadowColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height/2
    }
}
