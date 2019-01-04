//
//  EmailSearchTableViewController.swift
//  BullitinBoard
//
//  Created by Greg Hughes on 1/1/19.
//  Copyright © 2019 Greg Hughes. All rights reserved.
//

import UIKit

class EmailSearchTableViewController: UITableViewController {

    var messages : [Message] = []
    
    @IBOutlet weak var emailSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailSearchBar.delegate = self
        
        
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userMessageCell", for: indexPath)
        let message = messages[indexPath.row]
        cell.textLabel?.text = message.text
        cell.detailTextLabel?.text = message.timestamp.asString

        // Configure the cell...

        return cell
    }
 
}

extension EmailSearchTableViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {return}
        
        MessageController.shared.fetchMessagesFromUserWith(email: searchText.lowercased()) { (messages) in
           
            DispatchQueue.main.async {
                
                guard let messages = messages else {return}
                
                self.messages = messages
                
                self.tableView.reloadData()
            }
        }
    }
}
