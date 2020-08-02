//
//  NewsCell.swift
//  VKontakte
//
//  Created by Maxim Safronov on 06/10/2019.
//  Copyright © 2019 Maxim Safronov. All rights reserved.
//

import UIKit

//class NewsCell: UITableViewCell {
//    var newsListPhotos: News? {
//        didSet {
//            // обновляем коллекцию при получении данных
//            collectionNewsImages.reloadData()
//        }
//    }
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var newsDescription: UILabel!
//    @IBOutlet weak var newsImage: UIImageView!
//    @IBOutlet weak var likesTextCount: UILabel!
//    @IBOutlet weak var commentLabel: UILabel!
//    @IBOutlet weak var shareLabel: UILabel!
//    @IBOutlet weak var viewsLabel: UILabel!
//    @IBOutlet weak var collectionNewsImages: UICollectionView! {
//        didSet {
//            collectionNewsImages.delegate = self
//            collectionNewsImages.dataSource = self
//        }
//    }
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        titleLabel.text = nil
//        newsDescription.text = nil
//        newsImage.image = nil
//        likesTextCount.text = nil
//        commentLabel.text = nil
//        shareLabel.text = nil
//        viewsLabel.text = nil
//    }
//}
//
//extension NewsCell: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView,  numberOfItemsInSection section: Int) -> Int {
//        return newsListPhotos?.photos.count ?? 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsImagesCell", for: indexPath) as! NewsImagesCell
//        cell.newsImages.image = newsListPhotos!.photos[indexPath.item].photo
//
//        return cell
//    }
//}
//
