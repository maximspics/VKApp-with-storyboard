//
//  GlobalGroupsController.swift
//  VKontakte
//
//  Created by Maxim Safronov on 20/09/2019.
//  Copyright © 2019 Maxim Safronov. All rights reserved.
//

import UIKit

class AllGroupsController: UITableViewController {
    
    private let networkService = NetworkService(token: Session.shared.token)
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
            searchBar.placeholder = "Глобальный поиск групп"
            searchBar.showsCancelButton = false
            let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
            textFieldInsideSearchBar?.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
    }
    
    var groups = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        tableView.register(UINib(nibName: "GroupXibCell", bundle: nil), forCellReuseIdentifier: "GroupXibCell")
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: "GroupXibCell", for:
                    indexPath) as? GroupXibCell
                else {
                    preconditionFailure("All GroupXibCell cannot be deueued")
            }
            
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor(red: 0/255, green: 28/255, blue: 41/255, alpha: 0.5)
            } else {
                cell.backgroundColor = UIColor(red: 3/255, green: 29/255, blue: 64/255, alpha: 0.5)
            }
            
            cell.configure(witch: groups[indexPath.row])
            return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "addSelectedGroup", sender: nil)
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
}

// MARK: - UISearchBarDelegate
extension AllGroupsController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarFilter(search: searchText)
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBarFilter(search: "")
    }
    
    private func searchBarFilter(search text: String) {
        networkService.loadGroups(userId: Session.shared.userId, search: text) { result in
            switch result {
            case let .success(groups):
                self.groups = groups
                guard !groups.isEmpty else { return }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case let .failure(error):
                print(error)
            }
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}


