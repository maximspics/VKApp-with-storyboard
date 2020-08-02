//
//  Animator.swift
//  VKontakte
//
//  Created by Maxim Safronov on 22.11.2019.
//  Copyright © 2019 Maxim Safronov. All rights reserved.
//

import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    private let animationDuration: TimeInterval = 1
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Получаем оба вью контроллера
        guard let source = transitionContext.viewController(forKey: .from),
            let destination = transitionContext.viewController(forKey: .to) else {return}
        
        // Добавляем дестинейшн в контроллер
        transitionContext.containerView.addSubview(destination.view)
        
        // Задаем итоговое местоположение для обоих вью кождого из контроллеров
        source.view.frame = transitionContext.containerView.frame
        destination.view.frame = transitionContext.containerView.frame
        
        //трансформируем положение экрана, на которое нужно перейти
        destination.view.transform = CGAffineTransform(translationX: 0, y: -destination.view.bounds.height)
        
        // запускаем анимацию возвращения экрана в итоговое положение
        UIView.animate(withDuration: animationDuration, animations: {
            destination.view.transform = .identity
        }) {completed in
            transitionContext.completeTransition(completed)
        }
    }
}
