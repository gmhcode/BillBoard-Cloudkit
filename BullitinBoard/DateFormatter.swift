//
//  DateFormatter.swift
//  BullitinBoard
//
//  Created by Greg Hughes on 12/31/18.
//  Copyright © 2018 Greg Hughes. All rights reserved.
//

import Foundation

extension Date{
    
    var asString: String{
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
    
}
