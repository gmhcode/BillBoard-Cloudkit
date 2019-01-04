//
//  Message.swift
//  BullitinBoard
//
//  Created by Greg Hughes on 12/31/18.
//  Copyright © 2018 Greg Hughes. All rights reserved.
//

import Foundation
import CloudKit

class Message {

    static let RecordType = "Message"
    
    private let TextKey = "text"
    private let TimeStampKey = "timestamp"
    
    let text : String
    let timestamp : Date
    
    init(text: String, timestamp: Date = Date()) {
        self.text = text
        self.timestamp = timestamp
    }
    
    
     init?(cloudKitRecord: CKRecord) {
        
        //1) get all of the required properties out of the dictionary (CKrecord) guard else {return nil}
        guard let text = cloudKitRecord[TextKey] as? String,
            let timestamp = cloudKitRecord[TimeStampKey] as? Date else { return nil }
        
        //2 initialize the properties with the values you got in step 1
        self.text = text
        self.timestamp = timestamp
    }
    
    
    var cloudKitRecord: CKRecord {
        
        let record = CKRecord(recordType: Message.RecordType)
        record.setValue(text, forKey: TextKey)
        record[TimeStampKey] = timestamp
        
        return record
    }
}
