//
//  NetworkService.swift
//  VKontakte
//
//  Created by Maxim Safronov on 02.12.2019.
//  Copyright © 2019 Maxim Safronov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CommonCrypto

class NetworkService {
    static let session: Alamofire.Session = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 20
        let session = Alamofire.Session(configuration: config)
        return session
    }()
    
    private let baseUrl = "https://api.vk.com"
    private let versionAPI = "5.92"
    
    private let token: String
    
    init(token: String) {
        self.token = token
    }
    
    func loadFriends(token: String, completion: ((Swift.Result<[User], Error>) -> Void)? = nil) {
        //  let baseUrl = "https://api.vk.com"
        let path = "/method/friends.get"
        let params: Parameters = [
            "access_token": token,
            "fields": "first_name, last_name, photo_200, home_town, universities",
            "v": versionAPI
        ]
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case let .success(token):
                let json = JSON(token)
                let friendJSONs = json["response"]["items"].arrayValue
                let universities = friendJSONs.flatMap { friendJson in
                    friendJson["universities"].arrayValue.compactMap { universityJson in
                        University(from: universityJson)
                    }
                }
                let universitiesNames = universities.map { $0.name }
                let uniqueUniversities = Set(universitiesNames)
                print(uniqueUniversities)
                let friends = friendJSONs.compactMap { User(from: $0) }
                completion?(.success(friends))
            case let .failure(error):
                completion?(.failure(error))
            }
        }
    }
    
    func loadPhotos(userId: Int, completion: ((Result<[Photo], Error>) -> Void)? = nil) {
        let path = "/method/photos.getAll"
        let params: Parameters = [
            "access_token": token,
            "owner_id": userId,
            "extended": 1,
            "v": versionAPI
        ]
        
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case let .success(data):
                let json = JSON(data)
                let friendJSONs = json["response"]["items"].arrayValue
                let photos = friendJSONs.compactMap { Photo(from: $0) }
                completion?(.success(photos))
            case let .failure(error):
                completion?(.failure(error))
            }
        }
    }
    
    func loadFavoriteGroups(userId: Int, completion: ((Result<[Group], Error>) -> Void)? = nil) {
        let path = "/method/groups.get"
        let params: Parameters = [
            "access_token": token,
            "extended": 1,
            "v": versionAPI
        ]
        
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case let .success(data):
                let json = JSON(data)
                let groupJSONs = json["response"]["items"].arrayValue
                let groups = groupJSONs.map { Group(from: $0) }
                completion?(.success(groups))
            case let .failure(error):
                completion?(.failure(error))
            }
        }
    }
    
    func loadGroups(userId: Int, search: String, completion: ((Result<[Group], Error>) -> Void)? = nil) {
        let path = "/method/groups.search"
        let params: Parameters = [
            "access_token": token,
            "q": search,
            "count": 20,
            "type": "group, page",
            "v": versionAPI
        ]
        
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case let .success(data):
                let json = JSON(data)
                let groupJSONs = json["response"]["items"].arrayValue
                let groups = groupJSONs.map { Group(from: $0) }
                completion?(.success(groups))
            case let .failure(error):
                completion?(.failure(error))
            }
        }
    }
    
    func loadNewsFeedItems(
        startTime: Double? = nil,
        startFrom: String? = nil,
        completion: ((Result<([NewsFeedItem], [NewsFeedProfiles], [NewsFeedGroup], String), Error>) -> Void)? = nil
    ) {
        let path = "/method/newsfeed.get"
        var params: Parameters = [
            "access_token": token,
            "filters": "post",
            "count": 20,
            "v": versionAPI,
            "items": "text"
        ]
        if let startTime = startTime { params["start_time"] = startTime }
        if let startFrom = startFrom { params["start_from"] = startFrom }
        
        NetworkService.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case let .success(data):
                let json = JSON(data)
                let newsFeedItemsJSONs = json["response"]["items"].arrayValue
                let newsFeedItems = newsFeedItemsJSONs.map { NewsFeedItem(from: $0) }
                let newsFeedProfilesJSONs = json["response"]["profiles"].arrayValue
                let newsFeedProfiles = newsFeedProfilesJSONs.map { NewsFeedProfiles(from: $0)}
                let newsFeedGroupsJSONs = json["response"]["groups"].arrayValue
                let newsFeedGroups = newsFeedGroupsJSONs.map { NewsFeedGroup(from: $0)}
                
                let attachments = newsFeedItemsJSONs.flatMap { newsFeedItemsJson in
                    newsFeedItemsJson["attachments"].arrayValue.compactMap { attachmentsJson in
                        NewsFeedAttachments(from: attachmentsJson)
                    }
                }
                let attachmentsNames = attachments.map { $0.newsFeedAttachmentsDescription }
                let uniqueAttachments = Set(attachmentsNames)
                let nextFrom = json["response"]["next_from"].stringValue
                print("Новости newsFeedAttachmentsDescription \(uniqueAttachments)")
                
                completion?(.success((newsFeedItems, newsFeedProfiles, newsFeedGroups, nextFrom)))
            case let .failure(error):
                completion?(.failure(error))
            }
        }
    }
    
    func newsSendRequest(startTime: Double? = nil, startFrom: String? = nil, completion: @escaping ([NewsFeedItem], String) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = "/method/newsfeed.get"
        components.queryItems = [
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "v", value: "5.52"),
            URLQueryItem(name: "filters", value: "post")
        ]
        if let startTime = startTime {
            components.queryItems?.append(URLQueryItem(name: "start_time", value: String(startTime)))
        }
        if let startFrom = startFrom {
            components.queryItems?.append(URLQueryItem(name: "start_from", value: startFrom))
        }
        let request = URLRequest(url: components.url!)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data,
                let json = try? JSON(data: data) else { return }
            let newsJSON = json["response"]["items"].arrayValue
            let news = newsJSON.map { NewsFeedItem(from: $0) }
            let nextFrom = json["response"]["next_from"].stringValue
            
            DispatchQueue.main.async {
                completion(news, nextFrom)
            }
            
        }
        task.resume()
    }
}
