//
//  UIBezierPathExtension.swift
//  VKontakte
//
//  Created by Maxim Safronov on 04/10/2019.
//  Copyright © 2019 Maxim Safronov. All rights reserved.
//

import UIKit

extension UIBezierPath {
    convenience init(heartIn rect: CGRect) {
        self.init()
    }
}
extension Int {
    var degreesToRadians: CGFloat { return CGFloat(self) * .pi / 180 }
}
