//
//  LikeControll.swift
//  VKontakte
//
//  Created by Maxim Safronov on 25/09/2019.
//  Copyright © 2019 Maxim Safronov. All rights reserved.
//

import UIKit

@IBDesignable class LikeControl: UIControl{
    var friend: User!
    var likesCount = Int()
    
    var isLiked: Bool = false{
        didSet{
            sendActions(for: .valueChanged)
            guard var count = Int(counterLabel.text ?? "0") else {return}
            count = isLiked ? count+1 : count-1
            counterLabel.text = String(count)
        }
    }
    
    @IBOutlet weak var counterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gr = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        addGestureRecognizer(gr)
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let path = UIBezierPath()
        let sideOne = rect.width * 0.4
        let sideTwo = rect.height * 0.3
        let arcRadius = sqrt(sideOne*sideOne + sideTwo*sideTwo)/2
        
        path.addArc(withCenter: CGPoint(x: rect.width * 0.3, y: rect.height * 0.35), radius: arcRadius, startAngle: 135.degreesToRadians, endAngle: 315.degreesToRadians, clockwise: true)
        
        path.addLine(to: CGPoint(x: rect.width/2, y: rect.height * 0.2))
        
        path.addArc(withCenter: CGPoint(x: rect.width * 0.7, y: rect.height * 0.35), radius: arcRadius, startAngle: 225.degreesToRadians, endAngle: 45.degreesToRadians, clockwise: true)
        
        path.addLine(to: CGPoint(x: rect.width * 0.5, y: rect.height * 0.95))
        
        path.close()
        UIColor.white.setStroke()
        path.stroke()
        UIColor.red.setFill()
        
        if isLiked {
            path.fill()
        } else {
            path.stroke()
        }
        
    }
    @objc func likeTapped(){
        isLiked.toggle()
        setNeedsDisplay()
    }
    
    public func configureLikes(likes counts: Int) -> Int {
        self.likesCount = counts
        return self.likesCount
    }
}

