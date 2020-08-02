//
//  LoadingAnimation.swift
//  VKontakte
//
//  Created by Maxim Safronov on 21.11.2019.
//  Copyright © 2019 Maxim Safronov. All rights reserved.
//

import UIKit

class LoadingAnimation: UIViewController {
    @IBOutlet var blueView: UIView!
    @IBOutlet var pinkView: UIView!
    @IBOutlet var greenView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        blueView.layer.cornerRadius = blueView.frame.height / 2
        pinkView.layer.cornerRadius = blueView.frame.height / 2
        greenView.layer.cornerRadius = blueView.frame.height / 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

        
        UIView.animate(withDuration: 0.6, delay: 0,
                       options: [.repeat, .autoreverse],
                       animations:   {
                        self.blueView.alpha = 0
        })
        UIView.animate(withDuration: 0.4, delay: 0.4,
                       options: [.repeat, .autoreverse],
                       animations:   {
                        self.pinkView.alpha = 0
        })
        UIView.animate(withDuration: 0.2, delay: 0.6,
                       options: [.repeat, .autoreverse],
                       animations:   {
                        self.greenView.alpha = 0
        })
        
        UIView.animate(withDuration: 0.4, delay: 0.4,
                       options: [.repeat, .autoreverse],
                       animations:   {
                        self.greenView.frame.origin.x += 70
                        self.pinkView.frame.origin.x -= 70
        })

        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.performSegue(withIdentifier: "End Loading", sender: nil)
            
        })
        
        
    }
    
}
