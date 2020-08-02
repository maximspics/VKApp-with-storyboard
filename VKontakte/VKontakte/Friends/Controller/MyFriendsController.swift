//
//  MyFriendsListController.swift
//  VKontakte
//
//  Created by Maxim Safronov on 16/09/2019.
//  Copyright © 2019 Maxim Safronov. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class MyFriendsController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
            searchBar.placeholder = "Поиск среди друзей"
            let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
            textFieldInsideSearchBar?.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
    }
    
    @IBAction func returnToMyFriends(unwindSegue: UIStoryboardSegue) {
    }
    
    fileprivate lazy var configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    fileprivate lazy var realm = try! Realm(configuration: configuration)
    
    private var friends: Results<User> = try! Realm(configuration: RealmService.deleteIfMigration).objects(User.self)
    var filteredFriends: Results<User>!
    var filteredFriendsFirst: Results<User>!
    var isSearching = false
    var isBeginEditingAndIsEmpty = false
    var isHideKeyboardWhenTappedAround = false
    var sections: [String] = []
    
    @IBOutlet weak var friendsListTableView: UITableView!
    
    func saveRealm() {
        try? realm.write {
            realm.add(friends, update: .all)
        }
        print(realm.configuration.fileURL!)
    }
    
    func loadRealm() {
        let friends = realm.objects(User.self)
        friends.forEach { friend in
            print("loadRealm friends: \nИмя:\(friend.fullName) Город:\(friend.homeTown)")
        }
    }
    
    private let networkService = NetworkService(token: Session.shared.token)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveRealm()
        loadRealm()
        
        networkService.loadFriends(token: Session.shared.token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(friendsRealm):
                try? RealmService.save(items: friendsRealm, configuration: RealmService.deleteIfMigration, update: .all)
                self.fillSections()
                self.showFriendsInSections()
                self.hideKeyboardWhenTappedAround()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case let .failure(error):
                print(error)
            }
        }
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        friendsListTableView.dataSource = self
        friendsListTableView.delegate = self
        
        friendsListTableView.register(UINib(nibName: "Header", bundle: nil), forHeaderFooterViewReuseIdentifier: "Header")
    }
    
    // MARK: Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = friendsListTableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as! Header
        
        header.backgroundView = UIView(frame: header.bounds)
        header.backgroundView?.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        header.backgroundView?.alpha = 0.1
        header.headerLabel.alpha = 0.6
        header.headerLabel.text = sections[section]
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section: String = self.sections[indexPath.section]
        if let friendsInSection = filteredFriends?.filter("lastName BEGINSWITH %@", section) {
            print("didSelectRowAt friend lstName: \(friendsInSection[indexPath.row].lastName)")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let section: String = self.sections[section]
        if let friendInSection = filteredFriends?.filter("lastName BEGINSWITH %@", section) {
            return friendInSection.count
        }
        
        return isSearching ? filteredFriends.count : friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendsListTableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! FriendsCell
        
        if indexPath.row % 2 == 0 {
            if isBeginEditingAndIsEmpty {
                cell.backgroundColor = UIColor(red: 0/255, green: 28/255, blue: 41/255, alpha: 0.3)
            } else {
                cell.backgroundColor = UIColor(red: 0/255, green: 28/255, blue: 41/255, alpha: 0.5)
            }
        } else {
            if isBeginEditingAndIsEmpty {
                cell.backgroundColor = UIColor(red: 3/255, green: 29/255, blue: 64/255, alpha: 0.3)
            } else {
                cell.backgroundColor = UIColor(red: 3/255, green: 29/255, blue: 64/255, alpha: 0.5)
            }
        }
        
        let section = sections[indexPath.section]
        let friend = filteredFriends.filter("lastName BEGINSWITH %@", section)[indexPath.row]
        cell.configure(witch: friend)
        return cell
    }
    
    // MARK: Table view delegate
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "forecastSegue",
            let destinationVC = segue.destination as? FriendsImagesController,
            let indexPath = tableView.indexPathForSelectedRow {
            let section: String = self.sections[indexPath.section]
            guard let friendsInSection: Results<User> = self.filteredFriends?.filter("lastName BEGINSWITH %@", section) else { return }
            let friend = friendsInSection[indexPath.row]
            destinationVC.selectedFriend = friend
            destinationVC.userId = friend.id
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = #colorLiteral(red: 0.06274509804, green: 0.06274509804, blue: 0.06274509804, alpha: 1)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.darkGray
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isBeginEditingAndIsEmpty || (filteredFriends.count == friends.count && isBeginEditingAndIsEmpty ) {
            cell.alpha = 0
            UIView.animate(withDuration: 0) {
                 cell.alpha = 0.5
            }
        } else if filteredFriends.count != friends.count && isBeginEditingAndIsEmpty == false {
            cell.alpha = 0
            UIView.animate(withDuration: 0) {
                 cell.alpha = 1.0
            }
            
        } else {
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
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections
    }
    
    func fillSections() {
        /*
         
        if isSearching {
            sections = Array(Set(filteredFriends.map { String($0.lastName.first ?? "A") })).sorted()
        } else {
            sections = Array(Set(friends.map { String($0.lastName.first ?? "A") })).sorted()
        }
         
        */
        
        sections = isSearching ? Array(Set(filteredFriends.map { String($0.lastName.first ?? "A") })).sorted() : Array(Set(friends.map { String($0.lastName.first ?? "A") })).sorted()
    }
    
    func showFriendsInSections() {
        filteredFriends = friends
    }
}

// MARK: - UISearchBarDelegate
extension MyFriendsController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isBeginEditingAndIsEmpty = true
        isHideKeyboardWhenTappedAround = true
        searchBar.showsCancelButton = true
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isBeginEditingAndIsEmpty = false
        isHideKeyboardWhenTappedAround = false
        searchBar.showsCancelButton = false
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchBarFilter(search: nil)
        } else {
            searchBarFilter(search: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.text = ""
        searchBarFilter(search: nil)
        isBeginEditingAndIsEmpty = false
        isHideKeyboardWhenTappedAround = false
        searchBar.showsCancelButton = false
        tableView.reloadData()
    }
    
    private func searchBarFilter(search text: String?) {
        let searchText = text ?? ""
        guard !searchText.isEmpty else {
            filteredFriends = friends
            isBeginEditingAndIsEmpty = true
            isHideKeyboardWhenTappedAround = true
            searchBar.showsCancelButton = false
            fillSections()
            tableView.reloadData()
            return
        }
        isBeginEditingAndIsEmpty = false
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let searchingWords = trimmed.split(separator: " ", maxSplits: 1)
        guard searchingWords.count != 0 else {
            filteredFriends = friends
            isBeginEditingAndIsEmpty = true
            isHideKeyboardWhenTappedAround = true
            fillSections()
            tableView.reloadData()
            return
        }
        let first = String(searchingWords.first ?? "")
        let last = String(searchingWords.last ?? "")
        
        filteredFriendsFirst = friends.filter("(firstName BEGINSWITH[cd] %@ OR lastName BEGINSWITH[cd] %@) OR (firstName BEGINSWITH[cd] %@ OR lastName BEGINSWITH[cd] %@)", first, last, last, first)
        filteredFriends = filteredFriendsFirst
        
        if  searchingWords.count == 2 {
            filteredFriends = filteredFriendsFirst.filter("(firstName BEGINSWITH[cd] %@ AND lastName BEGINSWITH[cd] %@) OR (firstName BEGINSWITH[cd] %@ AND lastName BEGINSWITH[cd] %@)", first, last, last, first)
        }
        isSearching = true
        isHideKeyboardWhenTappedAround = false
        searchBar.showsCancelButton = true
        fillSections()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
extension MyFriendsController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyFriendsController.dismissKeyboard))
        tap.numberOfTapsRequired = 1
        tap.isEnabled = true
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        switch isHideKeyboardWhenTappedAround {
        case true:
            self.searchBar.endEditing(true)
        case false:
            print("isHideKeyboardWhenTappedAround false")
        }
    }
}

