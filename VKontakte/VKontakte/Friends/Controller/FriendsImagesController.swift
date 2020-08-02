//
//  FriendsImagesController.swift
//  VKontakte
//
//  Created by Maxim Safronov on 20/09/2019.
//  Copyright © 2019 Maxim Safronov. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class FriendsImagesController: UICollectionViewController {
    
    private let networkService = NetworkService(token: Session.shared.token)

    var likeControl: LikeControl = LikeControl()
    
    var userId = Int()
    var photos: [Photo]? = [Photo]()
    public var selectedFriend: User? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let friend = selectedFriend {
            networkService.loadPhotos(userId: friend.id) { result in
                switch result {
                case let .success(photos):
                    self.photos = photos
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                case let .failure(error):
                    print(error)
                }
            }
        }
        
        likeControl.addTarget(self, action: #selector(likedChanged), for: .valueChanged)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Big Photo" {
            if let destinationVC = segue.destination as? BigPhotoController,
                let indexPath = collectionView.indexPathsForSelectedItems,
                let selectedPhotoIndexPath = collectionView.indexPathsForSelectedItems?.first,
                let selectFriend = selectedFriend {
                destinationVC.friendID = selectFriend.id
                destinationVC.photos = photos!
                destinationVC.selectedPhotoIndex = selectedPhotoIndexPath.item
                if let photosList = self.photos,
                    photosList.indices.contains(indexPath[0][1])
                {
                    destinationVC.selectedPhotoIndex = indexPath[0][1]
                }
            }
        }
    }
    
    @objc func likedChanged(){
        if likeControl.isLiked{
            print("like +1")
        } else{
            print("like -1")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView,  numberOfItemsInSection section: Int) -> Int {
        return photos!.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,  cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserImageCell", for: indexPath) as! UserImageCell
        cell.configure(witch: photos![indexPath.row])
        cell.likesTextCount.text = "\(likeControl.configureLikes(likes: Int.random(in: 1...555)))"
        return cell
    }
    
}
