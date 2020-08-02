//
//  UIViewController+Ext.swift
//  VKontakte
//
//  Created by Maxim Safronov on 28.10.2019.
//  Copyright © 2019 Maxim Safronov. All rights reserved.
//

import UIKit

extension UIViewController {
    func show(message: String) {
        let alertVC = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
        
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
}
