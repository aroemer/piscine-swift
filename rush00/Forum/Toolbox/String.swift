//
//  String.swift
//  Forum
//
//  Created by Alexandra Legent on 05/12/2017.
//  Copyright © 2017 Alexandre Legent. All rights reserved.
//

import Foundation

extension String {
    func matches(pattern: String) -> [String]? {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
        let range = NSRange(location: 0, length: count)
        
        return regex.matches(in: self, range: range).flatMap { Range($0.range, in: self).map { String(self[$0]) } }
    }
}
