import UIKit
import Foundation
import SwiftUI

class UsersTableViewController: UITableViewController {
    
    private let jsonLoading = JSONLoading()
    private let userLoading = UserLoading()
    var users = [User]()
    let networksManager = NetworksManager()
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        jsonLoading.downloadData(from: networksManager.urlUsers) { (data) in
            if let data = data {
                self.users = self.userLoading.decodeUsers(from: data)
                self.tableView.reloadData()
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
        }
        
        setupSearchBar()
    }
    
    func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    var filteredUser: [User] = []
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredUser.count
        }
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UsersTableViewCell") as? UsersTableViewCell else {return UITableViewCell()}
        
        users.sort {
            $0.firstName < $1.firstName
        }
        
        var user: User
        if isFiltering {
            user = filteredUser[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        
        if indexPath.row % 2 == 0 {
            cell.viewBackground.layer.borderColor = UIColor.greenColor.cgColor
        } else {
            cell.viewBackground.layer.borderColor = UIColor.purpurColor.cgColor
        }
        cell.setup(with: user)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == users.count - 1 {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            
            if jsonLoading.downloadResultLimit + jsonLoading.downloadResultOffset < jsonLoading.downloadResultTotal {
                jsonLoading.downloadData(from: networksManager.urlUsers, pageNumber: jsonLoading.lastPage + 1) { (data) in
                    if let data = data {
                        let newPeople = self.userLoading.decodeUsers(from: data)
                        self.users.append(contentsOf: newPeople)
                        self.tableView.reloadData()
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        }
    }
    
    // go to detailed information about breed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fullUser" {
            guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else { return }
            let user = users[indexPath.row]
            if let userFullViewController: UserFullViewController = segue.destination as? UserFullViewController {
                
                let user: User
                if isFiltering {
                    user = filteredUser[indexPath.row]
                    userFullViewController.user = user
                } else {
                    user = users[indexPath.row]
                    userFullViewController.user = user
                }
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        let user = users
        filteredUser = user.filter({( user : User) -> Bool in
            return user.firstName.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}

extension UsersTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
