//
//  DataService.swift
//  Forum
//
//  Created by Alexandra Legent on 05/12/2017.
//  Copyright © 2017 Alexandre Legent. All rights reserved.
//

import Foundation

class DataService {
    static let shared = DataService()
    
    func get<T: Decodable>(request: URLRequest, for type: T.Type, completion: @escaping (T?) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            guard let result = try? JSONDecoder().decode(T.self, from: data) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            DispatchQueue.main.async { completion(result) }
        }.resume()
    }
}
