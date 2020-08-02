//
//  MyGroupsListController.swift
//  VKontakte
//
//  Created by Maxim Safronov on 16/09/2019.
//  Copyright © 2019 Maxim Safronov. All rights reserved.
//

import UIKit
import RealmSwift

class MyGroupsController: UITableViewController {
    
    @IBOutlet var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
            searchBar.placeholder = "Поиск по группам"
            searchBar.showsCancelButton = false
            let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
            textFieldInsideSearchBar?.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
    }
    
    private let networkService = NetworkService(token: Session.shared.token)
    fileprivate lazy var configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    fileprivate lazy var realm = try! Realm(configuration: configuration)
    
    private var groups: Results<Group> = try! Realm(configuration: RealmService.deleteIfMigration).objects(Group.self)
    var filteredGroups: Results<Group>!
    var isSearching = false
    var isBeginEditingAndIsEmpty = false
    var isHideKeyboardWhenTappedAround = false
    var sections: [String] = []
    
    func saveRealm() {
        try? realm.write {
            realm.add(groups, update: .all)
        }
        print(realm.configuration.fileURL!)
    }
    
    func loadRealm() {
        let groups = realm.objects(Group.self)
        groups.forEach { group in
            print("loadRealm friends: \(group.name)")
        }
    }
        
    // MARK: - IBActions
    @IBAction func addSelectedGroup(segue: UIStoryboardSegue) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkService.loadFavoriteGroups(userId: Session.shared.userId) { result in
            switch result {
            case let .success(groups):
                try? RealmService.save(items: groups, configuration: RealmService.deleteIfMigration, update: .all)
                self.showFilteredGroups()
                self.fillSections()
                self.hideKeyboardWhenTappedAround()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case let .failure(error):
                print(error)
            }
        }
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        tableView.register(UINib(nibName: "GroupXibCell", bundle: nil
        ), forCellReuseIdentifier: "GroupXibCell")
        
        tableView.register(UINib(nibName: "Header", bundle: nil), forHeaderFooterViewReuseIdentifier: "Header")
        
    }
    
    private func showFilteredGroups() {
        filteredGroups = groups
    }
    
    // MARK: Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as! Header
        
        header.backgroundView = UIView(frame: header.bounds)
        header.backgroundView?.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        header.backgroundView?.alpha = 0.1
        header.headerLabel.alpha = 0.6
        header.headerLabel.text = sections[section]
        
        return header
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let section: String = self.sections[section]
        if let groupInSection = filteredGroups?.filter("name BEGINSWITH %@", section) {
            return groupInSection.count
        }
        if isSearching {
            return filteredGroups.count
        } else {
            return groups.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "GroupXibCell", for:
                    indexPath) as? GroupXibCell
                else { preconditionFailure("GroupXibCell cannot be dequeued")
            }
            
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor(red: 0/255, green: 28/255, blue: 41/255, alpha: 0.5)
            } else {
                cell.backgroundColor = UIColor(red: 3/255, green: 29/255, blue: 64/255, alpha: 0.5)
            }
            
            let section = sections[indexPath.section]
            let group = filteredGroups.filter("name BEGINSWITH %@", section)[indexPath.row]
            cell.configure(witch: group)
            
            return cell
    }
    
    // MARK: Table view delegate
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections
    }
    
    func fillSections() {
        if isSearching {
            sections = Array(Set(filteredGroups.map { String($0.name.first ?? "A") })).sorted()
        } else {
            sections = Array(Set(groups.map { String($0.name.first ?? "A") })).sorted()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isBeginEditingAndIsEmpty || (filteredGroups.count == groups.count && isBeginEditingAndIsEmpty) {
            cell.alpha = 0
            UIView.animate(withDuration: 0) {
                 cell.alpha = 0.5
            }
        } else if filteredGroups.count != groups.count && isBeginEditingAndIsEmpty == false {
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
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = #colorLiteral(red: 0.06218274112, green: 0.06218274112, blue: 0.06218274112, alpha: 1)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.darkGray
    }
}

// MARK: - UISearchBarDelegate
extension MyGroupsController: UISearchBarDelegate {
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
    private func searchBarFilter(search searchText: String?) {
        let searchText = searchText ?? ""
        guard !searchText.isEmpty else {
            isBeginEditingAndIsEmpty = true
            isHideKeyboardWhenTappedAround = true
            filteredGroups = groups
            fillSections()
            tableView.reloadData()
            return
        }
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedSearchText.count != 0 else {
            isBeginEditingAndIsEmpty = true
            isHideKeyboardWhenTappedAround = true
            filteredGroups = groups
            fillSections()
            tableView.reloadData()
            return
        }
        filteredGroups = groups.filter("name CONTAINS[cd] %@", trimmedSearchText)
        isSearching = true
        isBeginEditingAndIsEmpty = false
        isHideKeyboardWhenTappedAround = false
        searchBar.showsCancelButton = true
        fillSections()
        tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension MyGroupsController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyGroupsController.dismissKeyboard))
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
