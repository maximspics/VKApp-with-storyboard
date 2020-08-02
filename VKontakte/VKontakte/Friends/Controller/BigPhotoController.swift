//
//  BigPhotoController.swift
//  VKontakte
//
//  Created by Maxim Safronov on 26.11.2019.
//  Copyright © 2019 Maxim Safronov. All rights reserved.
//

import UIKit
import Kingfisher

class BigPhotoController: UIViewController {
    enum AnimationDirection {
        case left
        case right
    }
    
    @IBOutlet var bigPhotoImageView: UIImageView! {
        didSet {
            bigPhotoImageView.isUserInteractionEnabled = true
        }
    }
    private let additionalImageView = UIImageView()
    
    var friendID: Int = 0    
    var photos = [Photo]()
    public var selectedPhotoIndex: Int = 0
    private var propertyAnimator: UIViewPropertyAnimator!
    private var animationDirection: AnimationDirection = .left
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(selectedPhotoIndex+1) из \(photos.count)"
        view.backgroundColor = .black
        view.insertSubview(additionalImageView, belowSubview: bigPhotoImageView)
        additionalImageView.contentMode = .scaleAspectFit
        additionalImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            additionalImageView.leadingAnchor.constraint(equalTo: bigPhotoImageView.leadingAnchor),
            additionalImageView.trailingAnchor.constraint(equalTo: bigPhotoImageView.trailingAnchor),
            additionalImageView.topAnchor.constraint(equalTo: bigPhotoImageView.topAnchor),
            additionalImageView.bottomAnchor.constraint(equalTo: bigPhotoImageView.bottomAnchor)
        ])
        
        if !photos.indices.contains(selectedPhotoIndex) {
            selectedPhotoIndex = 0
        }
        
        guard photos.indices.contains(selectedPhotoIndex) else { return }
        
        bigPhotoImageView.kf.setImage(with: URL(string:photos[selectedPhotoIndex].imageFullURLString)) { result in
            
            switch result {
            case .success(let data):
                self.bigPhotoImageView.image = data.image
            case .failure:
                print("image not found")
            }
        }
        
        let panRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(photoSwipedLeft(_:)))
        panRecognizer.direction = .left
        bigPhotoImageView.addGestureRecognizer(panRecognizer)
        
        let panGR = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        view.addGestureRecognizer(panGR)
        
    }
    
    @objc func photoSwipedLeft(_ swipeGestureRecognizer: UISwipeGestureRecognizer) {
        guard selectedPhotoIndex + 1 <= photos.count - 1 else { return }
        
        additionalImageView.transform = CGAffineTransform(translationX: 1.3*self.additionalImageView.bounds.width, y: 150).concatenating(CGAffineTransform(scaleX: 1.3, y: 1.3))
        
        let photo = photos[selectedPhotoIndex + 1]
        additionalImageView.kf.setImage(with: URL(string: photo.imageFullURLString))
        
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut, animations: {
            self.bigPhotoImageView.transform = CGAffineTransform(translationX: -1.5*self.bigPhotoImageView.bounds.width, y: -100).concatenating(CGAffineTransform(scaleX: 0.6, y: 0.6))
            self.additionalImageView.transform = .identity
        }) { _ in
            self.selectedPhotoIndex += 1
            
            let photo = self.photos[self.selectedPhotoIndex]
            self.bigPhotoImageView.kf.setImage(with: URL(string: photo.imageFullURLString))
            
            self.bigPhotoImageView.transform = .identity
            self.additionalImageView.image = nil
        }
    }
    
    @IBAction func photoSwipedRight(_ sender: UISwipeGestureRecognizer) {
        guard selectedPhotoIndex >= 1 else { return }
        
        additionalImageView.transform = CGAffineTransform(translationX: -1.3*self.additionalImageView.bounds.width, y: 150).concatenating(CGAffineTransform(scaleX: 1.3, y: 1.3))
        
        let photo = photos[selectedPhotoIndex - 1]
        additionalImageView.kf.setImage(with: URL(string: photo.imageFullURLString))
        
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut, animations: {
            self.bigPhotoImageView.transform = CGAffineTransform(translationX: 1.5*self.bigPhotoImageView.bounds.width, y: -100).concatenating(CGAffineTransform(scaleX: 0.6, y: 0.6))
            self.additionalImageView.transform = .identity
        }) { _ in
            self.selectedPhotoIndex -= 1
            
            let photo = self.photos[self.selectedPhotoIndex]
            self.bigPhotoImageView.kf.setImage(with: URL(string: photo.imageFullURLString))
            
            self.bigPhotoImageView.transform = .identity
            self.additionalImageView.image = nil
        }
    }
    
    @objc func viewPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {
        switch panGestureRecognizer.state {
        case .began:
            print(panGestureRecognizer.translation(in: view).x)
            if panGestureRecognizer.translation(in: view).x > 0 {
                guard selectedPhotoIndex >= 1 else { return }
                
                animationDirection = .right
                // начальная трансформация
                additionalImageView.transform = CGAffineTransform(translationX: -1.3*self.additionalImageView.bounds.width, y: 150).concatenating(CGAffineTransform(scaleX: 1.3, y: 1.3))
                
                let photo = photos[selectedPhotoIndex - 1]
                additionalImageView.kf.setImage(with: URL(string: photo.imageFullURLString))
                
                // создаем аниматор для движения направо
                propertyAnimator = UIViewPropertyAnimator(duration: 0.7, curve: .easeInOut, animations: {
                    self.bigPhotoImageView.transform = CGAffineTransform(translationX: 1.5*self.bigPhotoImageView.bounds.width, y: -100).concatenating(CGAffineTransform(scaleX: 0.6, y: 0.6))
                    self.additionalImageView.transform = .identity
                })
                print("Right animation property animator has been created")
                propertyAnimator.addCompletion { position in
                    switch position {
                    case .end:
                        self.selectedPhotoIndex -= 1
                        self.title = "\(self.selectedPhotoIndex+1) из \(self.photos.count)"
                        let photo = self.photos[self.selectedPhotoIndex]
                        self.bigPhotoImageView.kf.setImage(with: URL(string: photo.imageFullURLString))
                        
                        self.bigPhotoImageView.transform = .identity
                        self.additionalImageView.image = nil
                    case .start:
                        self.additionalImageView.transform = CGAffineTransform(translationX: -1.3*self.additionalImageView.bounds.width, y: 150).concatenating(CGAffineTransform(scaleX: 1.3, y: 1.3))
                    case .current:
                        break
                    @unknown default:
                        break
                    }
                }
            } else {
                // создаем аниматор для движения налево
                guard selectedPhotoIndex + 1 <= photos.count - 1 else { return }
                
                animationDirection = .left
                
                let photo = photos[selectedPhotoIndex + 1]
                additionalImageView.kf.setImage(with: URL(string: photo.imageFullURLString))
                
                // начальная трансформация
                additionalImageView.transform = CGAffineTransform(translationX: 1.3*self.additionalImageView.bounds.width, y: 150).concatenating(CGAffineTransform(scaleX: 1.3, y: 1.3))
                // создаем аниматор для движения направо
                propertyAnimator = UIViewPropertyAnimator(duration: 0.7, curve: .easeInOut, animations: {
                    self.bigPhotoImageView.transform = CGAffineTransform(translationX: -1.5*self.bigPhotoImageView.bounds.width, y: -100).concatenating(CGAffineTransform(scaleX: 0.6, y: 0.6))
                    self.additionalImageView.transform = .identity
                })
                print("Left animation property animator has been created")
                propertyAnimator.addCompletion { position in
                    switch position {
                    case .end:
                        self.selectedPhotoIndex += 1
                        self.title = "\(self.selectedPhotoIndex+1) из \(self.photos.count)"
                        let photo = self.photos[self.selectedPhotoIndex]
                        self.bigPhotoImageView.kf.setImage(with: URL(string: photo.imageFullURLString))
                        
                        self.bigPhotoImageView.transform = .identity
                        self.additionalImageView.image = nil
                    case .start:
                        self.additionalImageView.transform = CGAffineTransform(translationX: 1.3*self.additionalImageView.bounds.width, y: 150).concatenating(CGAffineTransform(scaleX: 1.3, y: 1.3))
                    case .current:
                        break
                    @unknown default:
                        break
                    }
                }
            }
        case .changed:
            guard let propertyAnimator = self.propertyAnimator else { return }
            switch animationDirection {
            case .right:
                let percent = min(max(0, panGestureRecognizer.translation(in: view).x / 200), 1)
                propertyAnimator.fractionComplete = percent
            case .left:
                let percent = min(max(0, -panGestureRecognizer.translation(in: view).x / 200), 1)
                propertyAnimator.fractionComplete = percent
            }
        case .ended:
            guard let propertyAnimator = self.propertyAnimator else { return }
            if propertyAnimator.fractionComplete > 0.33 {
                propertyAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0.5)
            } else {
                propertyAnimator.isReversed = true
                propertyAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0.5)
            }
        default:
            break
        }
    }
}
