//
//  UIImageExtensions.swift
//  VKontakte
//
//  Created by Maxim Safronov on 04/10/2019.
//  Copyright © 2019 Maxim Safronov. All rights reserved.
//

import UIKit


extension UIImage {
    
    static var empty: UIImage {
        return UIGraphicsImageRenderer(size: CGSize.zero).image { _ in }
    }
    
}
