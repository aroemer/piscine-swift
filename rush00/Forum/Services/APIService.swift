//
//  APIService.swift
//  Forum
//
//  Created by Alexandra Legent on 05/12/2017.
//  Copyright © 2017 Alexandre Legent. All rights reserved.
//

import Foundation

class APIService {
    static let shared = APIService()
    private var topicUrl: String {
      return "\(API_URL)/topics"
    }
    
    private var userUrl: String {
        return "\(API_URL)/users"
    }
    
    func getUser(_ user: String = "me", completion: @escaping (Student?) -> Void) {
        guard let token = LoginService.shared.token else { return }
        guard let url = URL(string: user == "me" ? "\(API_URL)/me" : "\(userUrl)/\(user)") else { return }
        var request = URLRequest(url: url)
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        DataService.shared.get(request: request, for: Student.self, completion: completion)
    }
    
    func getTopics(completion: @escaping ([Topic]?) -> Void) {
        guard let token = LoginService.shared.token else { return }
        guard let url = URL(string: topicUrl) else { return }
        var request = URLRequest(url: url)
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        DataService.shared.get(request: request, for: [Topic].self, completion: completion)
    }
    
    func getMessage(for topic: Topic, completion: @escaping ([Message]?) -> Void) {
        guard let token = LoginService.shared.token else { return }
        guard let url = URL(string: "\(topicUrl)/\(topic.id)/messages") else { return }
        var request = URLRequest(url: url)
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        DataService.shared.get(request: request, for: [Message].self, completion: completion)
    }
    
    func add(topic name: String, message: String, kind: SendableTopic.TopicKind = .normal, completion: @escaping (Topic?) -> Void) {
        guard let token = LoginService.shared.token else { return }
        guard let url = URL(string: topicUrl) else { return }
        var request = URLRequest(url: url)
        let body = SendableTopic(name: name, content: message, kind: kind)
        
        // Try to encode
        guard let encoded = try? JSONEncoder().encode(body) else { return }
        request.httpMethod = "POST"
        request.httpBody = encoded
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        DataService.shared.get(request: request, for: Topic.self, completion: completion)
    }
    
    func add(message: String, to topic: Int, completion: @escaping (Message?) -> Void) {
        guard let token = LoginService.shared.token else { return }
        guard let url = URL(string: "\(API_URL)/topics/\(topic)/messages") else { return }
        var request = URLRequest(url: url)
        let body = SendableMessage(author: LoginService.shared.user?.id ?? 0, content: message)
        
        // Try to encode
        guard let encoded = try? JSONEncoder().encode(body) else { return }
        request.httpMethod = "POST"
        request.httpBody = encoded
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        DataService.shared.get(request: request, for: Message.self, completion: completion)
    }
    
    func update(topic: Int, with name: String, completion: @escaping () -> Void) {
        guard let token = LoginService.shared.token else { return }
        guard let url = URL(string: "\(topicUrl)/\(topic)") else { return }
        var request = URLRequest(url: url)
        let body = PatchableTopic(name: name)
        
        // Try to encode
        guard let encoded = try? JSONEncoder().encode(body) else { return }
        request.httpMethod = "PATCH"
        request.httpBody = encoded
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { _, _, _ in
            completion()
        }.resume()
    }
    
    func update(message: Int, with content: String, completion: @escaping () -> Void) {
        guard let token = LoginService.shared.token else { return }
        guard let url = URL(string: "\(API_URL)/messages/\(message)") else { return }
        var request = URLRequest(url: url)
        let body = PatchableMessage(content: content)
        
        // Try to encode
        guard let encoded = try? JSONEncoder().encode(body) else { return }
        request.httpMethod = "PATCH"
        request.httpBody = encoded
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { _, _, _ in
            completion()
        }.resume()
    }
    
    func remove(topic: Int) {
        guard let token = LoginService.shared.token else { return }
        guard let url = URL(string: "\(topicUrl)/\(topic)") else { return }
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { _, _, _ in
        }.resume()
    }
    
    func remove(message: Int) {
        guard let token = LoginService.shared.token else { return }
        guard let url = URL(string: "\(API_URL)/messages/\(message)") else { return }
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { _, _, _ in
        }.resume()
    }
}
