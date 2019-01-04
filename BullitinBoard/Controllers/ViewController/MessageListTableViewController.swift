//
//  MessageListTableViewController.swift
//  BullitinBoard
//
//  Created by Greg Hughes on 12/31/18.
//  Copyright © 2018 Greg Hughes. All rights reserved.
//

import UIKit
import UserNotifications
class MessageListTableViewController: UITableViewController {

    
    @IBOutlet weak var messageSearchBar: UISearchBar!
    
    var messages: [Message] = []
    
    
    func fetchAndDisplayMessages() {
        MessageController.shared.fetchAllMessagesFromCloudKit { (messages) in
            
            DispatchQueue.main.async {
                guard let messages = messages else {return}
                self.messages = messages
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchAndDisplayMessages()
    }

 
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)

        let message = messages[indexPath.row]
        cell.textLabel?.text = message.text
        cell.detailTextLabel?.text = message.timestamp.asString
        return cell
    }
 
    func postMessageFromSearchBar(){
        guard let text = messageSearchBar.text else { return }
        MessageController.shared.saveMessageToCloudKit(text: text) { (message) in
            DispatchQueue.main.async {
                guard let message = message else {return}
                self.messages.append(message)
                self.tableView.reloadData()
                self.messageSearchBar.text = ""
            }
           
        }
    }
    
    
    @IBAction func postMessageButtonTapped(_ sender: Any) {
        postMessageFromSearchBar()
        
        
    }
    
}

extension MessageListTableViewController: UNUserNotificationCenterDelegate{
    
   
}
