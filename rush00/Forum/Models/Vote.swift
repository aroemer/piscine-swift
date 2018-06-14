//
//  Vote.swift
//  Forum
//
//  Created by Alexandra Legent on 14/12/2017.
//  Copyright © 2017 Alexandre Legent. All rights reserved.
//

import Foundation

struct Vote: Decodable {
    let up: Int
    let down: Int
    let troll: Int
    let problem: Int
    
    private enum CodingKeys: CodingKey, String {
        case problem
        case up = "upvote"
        case down = "downvote"
        case troll = "trollvote"
    }
}
