//
//  LabelAnimation.swift
//  VKontakte
//
//  Created by Maxim Safronov on 26.11.2019.
//  Copyright © 2019 Maxim Safronov. All rights reserved.
//

import UIKit

extension UILabel {
    func animate(newText: String, characterDelay: TimeInterval) {
        DispatchQueue.main.async {
            self.text = ""
            for (index, character) in newText.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(index)) {
                    self.text?.append(character)
                    self.fadeTransition(characterDelay) // это анимация проявления
                }
            }
        }
    }
}

extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}
