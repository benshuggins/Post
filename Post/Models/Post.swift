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
    var timestamp: Date
    var username: String
 
}
let postOne = Post(text: "", timestamp: Date(), username: "")

