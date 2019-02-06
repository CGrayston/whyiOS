//
//  Post.swift
//  whyiOS
//
//  Created by Chris Grayston on 2/6/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import Foundation

struct Post {
    let cohort: String
    let name: String
    let reason: String
}

extension Post: Codable {
    
}
