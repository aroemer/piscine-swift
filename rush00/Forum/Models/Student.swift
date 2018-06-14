//
//  Student.swift
//  Forum
//
//  Created by Alexandra Legent on 05/12/2017.
//  Copyright © 2017 Alexandre Legent. All rights reserved.
//

import Foundation

struct Student: Decodable {
    let id: Int
    let login: String
    var imageUrl: String {
        return "https://cdn.intra.42.fr/users/medium_\(login).jpg"
    }
}
