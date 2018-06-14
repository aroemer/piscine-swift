//
//  Message.swift
//  Forum
//
//  Created by Alexandra Legent on 14/12/2017.
//  Copyright © 2017 Alexandre Legent. All rights reserved.
//

import Foundation

struct Message: Decodable {
    let id: Int
    let author: Student
    let content: String
    let createdAt: String
    let replies: [Message]
    let votes: Vote
    let isReply: Bool?
    
    private enum CodingKeys: CodingKey, String {
        case author, content, replies, isReply, id
        case createdAt = "created_at"
        case votes = "votes_count"
    }
    
    static func ==(_ left: Message, _ right: Message) -> Bool {
        return left.id == right.id
    }
}

struct SendableMessage: Encodable {
    let message: Submessage
    
    struct Submessage: Encodable {
        let authorId: Int
        let content: String
        
        private enum CodingKeys: String, CodingKey {
            case content
            case authorId = "author_id"
        }
    }
    
    init(author: Int, content: String) {
        message = Submessage(authorId: author, content: content)
    }
}

struct PatchableMessage: Encodable {
    let message: PatchableSubmessage
    
    struct PatchableSubmessage: Encodable {
        let content: String
    }
    
    init(content: String) {
        message = PatchableSubmessage(content: content)
    }
}
