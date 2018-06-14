//
//  Model.swift
//  d04
//
//  Created by Audrey ROEMER on 3/30/18.
//  Copyright © 2018 Audrey ROEMER. All rights reserved.
//

import UIKit

struct Tweet {
    let name: String
    let date: String
    let text: String
}

extension Tweet : CustomStringConvertible
{
    var description: String {
        return "(\(name) tweeted: \(text) at \(date)"
    }
}

