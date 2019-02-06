//
//  Post.swift
//  Post
//
//  Created by Ben Huggins on 2/4/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

struct Post: Codable {
    var text: String
    var timestamp: TimeInterval 
    var username: String
    
    
    init(text: String, timestamp: TimeInterval = Date().timeIntervalSince1970, username: String) {
        self.text = text
        self.timestamp = timestamp
        self.username = username
    }
    // Computer Property
    var queryTimestamp: TimeInterval {
        return self.timestamp - 0.00001
    }
    var date: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: Date(timeIntervalSince1970: timestamp))
    }

 
}
let postOne = Post(text: "Ben", username: "Huggins")

