//
//  Topic.swift
//  Forum
//
//  Created by Alexandra Legent on 05/12/2017.
//  Copyright © 2017 Alexandre Legent. All rights reserved.
//

import Foundation

struct Topic: Decodable {
    let id: Int
    let name: String
    let author: Student
    let createdAt: String
    
    private enum CodingKeys: CodingKey, String {
        case id, name, author
        case createdAt = "created_at"
    }
    
    static func ==(_ left: Topic, _ right: Topic) -> Bool {
        return left.id == right.id
    }
}

struct SendableTopic: Encodable {
    let topic: Subtopic

    enum TopicKind: String, Encodable {
        case normal
        case survey
        case stackOverflow = "stack_overflow"
    }

    enum Language: Int, Encodable {
        case french = 1
    }
    
    enum Tags: Int, Encodable {
        case wtf = 8
    }
    
    enum Cursus: Int, Encodable {
        case main = 1
    }

    struct Subtopic: Encodable {
        let name: String
        let kind: TopicKind
        let languageId: Language
        let tagIds: [Tags]
        let cursusIds: [Cursus]
        let messagesAttributes: [MessagesAttributes]

        struct MessagesAttributes: Encodable {
            let content: String
            let authorId: Int

            private enum CodingKeys: String, CodingKey {
                case content
                case authorId = "author_id"
            }
        }

        private enum CodingKeys: String, CodingKey {
            case name, kind
            case languageId = "language_id"
            case tagIds = "tag_ids"
            case cursusIds = "cursus_ids"
            case messagesAttributes = "messages_attributes"
        }
    }

    init(name: String, content: String, language: Language = .french, kind: TopicKind = .normal) {
        let message = Subtopic.MessagesAttributes(content: content, authorId: LoginService.shared.user?.id ?? 0)
        topic = Subtopic(name: name, kind: kind, languageId: language, tagIds: [.wtf], cursusIds: [.main], messagesAttributes: [message])
    }
}

struct PatchableTopic: Encodable {
    let topic: PatchableSubtopic
    
    struct PatchableSubtopic: Encodable {
        let name: String
    }
    
    init(name: String) {
        topic = PatchableSubtopic(name: name)
    }
}
