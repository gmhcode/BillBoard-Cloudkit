//
//  MessageController.swift
//  BullitinBoard
//
//  Created by Greg Hughes on 12/31/18.
//  Copyright © 2018 Greg Hughes. All rights reserved.
//

import Foundation
import CloudKit


class MessageController {
    
    static let shared = MessageController()
    
    
    func saveMessageToCloudKit(text: String, completion: @escaping (Message?) -> Void){
        
        let message = Message(text: text)
        let record = message.cloudKitRecord
        
        
        CKContainer.default().publicCloudDatabase.save(record) { (record, error) in
            if let error = error {
                print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            
            guard let record = record else {completion(nil) ; return}
            
            let message = Message(cloudKitRecord: record)
            completion(message)
            
        }
    }
    
    
    func fetchAllMessagesFromCloudKit(completion: @escaping ([Message]?) -> Void){
        
       let predicate = NSPredicate(value: true)
        
       let query = CKQuery(recordType: Message.RecordType, predicate: predicate)
        
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            
            guard let records = records else {completion(nil) ; return}
            let messages = records.compactMap{Message(cloudKitRecord: $0)}
            completion(messages)
        }
    }
    
    func fetchMessagesFromUserWith(email: String, completion: @escaping ([Message]?) -> ()){
        
        CKContainer.default().discoverUserIdentity(withEmailAddress: email) { (identity, error) in
            if let error = error {
                print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let identity = identity, let userRecordID = identity.userRecordID else {completion(nil) ; return}
            
            let predicate = NSPredicate(format: "%K == %@", "creatorUserRecordID", userRecordID)
            
            let query = CKQuery(recordType: Message.RecordType, predicate: predicate)
            CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
                if let error = error {
                    print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                guard let records = records else {completion(nil) ; return}
                let messages = records.compactMap{Message(cloudKitRecord: $0)}
                completion(messages)
            })
            
        }
    }
    
    func subscribeToNewMessages(completion: @escaping (Bool)->()){
        
        let predicate = NSPredicate(value: true)
        
        let subscription = CKQuerySubscription(recordType: Message.RecordType, predicate: predicate, subscriptionID: UUID().uuidString, options: .firesOnRecordCreation)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        
        notificationInfo.title = "newPost on the Bulletin Board"
        notificationInfo.alertBody = "WootWoot"
        //setting what the notification does
        subscription.notificationInfo = notificationInfo
        //setting our notification info to our subscription instance
        
        
        CKContainer.default().publicCloudDatabase.save(subscription) { (subscription, error) in
            
            if let error = error {
                print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard subscription != nil else {completion(false) ; return}
            completion(true)
            
        }
    }
}
