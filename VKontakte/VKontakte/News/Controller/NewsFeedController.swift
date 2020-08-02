//
//  NewsFeedController.swift
//  VKontakte
//
//  Created by Maxim Safronov on 21.01.2020.
//  Copyright © 2020 Maxim Safronov. All rights reserved.
//

import UIKit
import Kingfisher

class NewsFeedController: UITableViewController {
    
    private let networkService = NetworkService(token: Session.shared.token)
    
    var newsFeed = [NewsFeedItem]()
    var newsFeedProfiles = [NewsFeedProfiles]()
    var newsFeedGroups = [NewsFeedGroup]()
    var newsFeedAttachments = [NewsFeedAttachments]()
    var nextFrom = ""
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkService.loadNewsFeedItems { result in
            switch result {
            case let .success(news, profiles, groups, nextFrom):
                self.newsFeed = news
                self.newsFeedGroups = groups
                self.newsFeedProfiles = profiles
                self.nextFrom = nextFrom
                
                guard !news.isEmpty else { return }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case let .failure(error):
                print(error)
            }
        }
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        tableView.register(UINib(nibName: "NewsTableCell", bundle: nil
        ), forCellReuseIdentifier: "NewsTableCell")
        
        tableView.register(UINib(nibName: "NewsImageCell", bundle: nil
        ), forCellReuseIdentifier: "NewsImageCell")
        
        tableView.register(UINib(nibName: "NewsShareCell", bundle: nil), forCellReuseIdentifier: "NewsShareCell")
        
        tableView.prefetchDataSource = self
        
        setupRefreshControl()
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .systemGreen
        refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }
    
    @objc private func refreshNews() {
        let startTime = newsFeed.first?.date ?? Date().timeIntervalSince1970
        networkService.loadNewsFeedItems(startTime: startTime + 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(news, profiles, groups, _):
                self.newsFeed = news + self.newsFeed
                self.newsFeedGroups.append(contentsOf: groups)
                self.newsFeedProfiles.append(contentsOf: profiles)
                self.tableView.reloadData()
            case .failure(let error):
                self.show(message: error.localizedDescription)
            }
            self.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return newsFeed.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableCell", for: indexPath) as! NewsTableCell
            
            let news = newsFeed[indexPath.section]
            
            let humanDate = Date(timeIntervalSince1970: news.date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMMM-yyyy'T'HH:mm:ssZ"
            dateFormatter.locale = Locale(identifier: "ru_RU")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = DateFormatter.Style.full
            dateFormatter.timeZone = .current
            let localDate = dateFormatter.string(from: humanDate)
            
            if let group = newsFeedGroups.first(where: { $0.newsFeedGroupId == -news.newsFeedItemSourceId }) {
                cell.newsText.text = news.newsFeedItemText
                cell.newsSourceName.text = group.newsFeedGroupName
                cell.newsSourceAvatar.kf.setImage(with: URL(string: group.newsFeedGroupPhoto))
                
                cell.newsDate.text = localDate
                if let attachmentTitle = news.newsFeedItemTitle.first?.newsFeedAttachmentsTitle {
                    cell.newsTitle.text = attachmentTitle
                } else {
                    cell.newsTitle.text = ""
                }
                
                return cell
                
            } else if let profile = newsFeedProfiles.first(where: { $0.newsFeedProfilesId == news.newsFeedItemSourceId }) {
                cell.newsText.text = news.newsFeedItemText
                cell.newsSourceName.text = profile.newsFeedProfilesFullName
                cell.newsSourceAvatar.kf.setImage(with: URL(string: profile.newsFeedProfilesAvatar))
                
                cell.newsDate.text = localDate
                
                if let attachmentTitle = news.newsFeedItemTitle.first?.newsFeedAttachmentsTitle {
                    cell.newsTitle.text = attachmentTitle
                } else {
                    cell.newsTitle.text = ""
                }
                return cell
            }
            
            return cell
            
        } else if indexPath.row == 1 {
            // Second cell is always photo cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsImageCell", for: indexPath) as! NewsImageCell
            
            let news = newsFeed[indexPath.section]
            
            cell.newsImage.kf.setImage(with: news.photos.first?.url)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsShareCell", for: indexPath) as! NewsShareCell
            
            let news = newsFeed[indexPath.section]
            
            if let _ = newsFeedGroups.first(where: { $0.newsFeedGroupId == -news.newsFeedItemSourceId }),
                let data = newsFeed.first(where: { $0.newsFeedItemViews == news.newsFeedItemViews }) {
                cell.commentsCount.text = String(data.newsFeedItemComments)
                cell.repostCount.text = String(data.newsFeedItemReposts)
                cell.viewsCount.text = String(data.newsFeedItemViews)
                return cell
                
            } else if let _ = newsFeedProfiles.first(where: { $0.newsFeedProfilesId == news.newsFeedItemSourceId }),
                let data = newsFeed.first(where: { $0.newsFeedItemViews == news.newsFeedItemViews }) {
                cell.commentsCount.text = String(data.newsFeedItemComments)
                cell.repostCount.text = String(data.newsFeedItemReposts)
                cell.viewsCount.text = String(data.newsFeedItemViews)
                return cell
            }
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 50, 25, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        UIView.animate(withDuration: 0.75) {
            cell.alpha = 1.0
        }
        UIView.animate(withDuration: 0.25) {
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 1:
            let newsItem = newsFeed[indexPath.section]
            let aspectRatio = newsItem.photos.first?.aspectRatio ?? 0
            return tableView.bounds.width * aspectRatio
        default:
            return UITableView.automaticDimension
        }
    }
}

extension NewsFeedController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxSection = indexPaths.map({ $0.section }).max() else { return }
        if maxSection > newsFeed.count - 3,
            !isLoading {
            isLoading = true
            networkService.loadNewsFeedItems(startFrom: nextFrom) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(news, profiles, groups, nextFrom):
                    let startIndex = self.newsFeed.count
                    let endIndex = self.newsFeed.count + news.count
                    let indexSet = IndexSet(integersIn: startIndex ..< endIndex)
                    
                    self.newsFeed.append(contentsOf: news)
                    self.newsFeedGroups.append(contentsOf: groups)
                    self.newsFeedProfiles.append(contentsOf: profiles)
                    self.nextFrom = nextFrom
                    
                    self.tableView.insertSections(indexSet, with: .none)
                case .failure(let error):
                    self.show(message: error.localizedDescription)
                }
                self.isLoading = false
            }
        }
    }
}
