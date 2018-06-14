//
//  UIColor.swift
//  Forum
//
//  Created by Alexandra Legent on 05/12/2017.
//  Copyright © 2017 Alexandre Legent. All rights reserved.
//

import UIKit

extension UIColor {
    static let forumBlue = UIColor(r: 0, g: 186, b: 188)
    static let forumGray = UIColor(r: 103, g: 103, b: 109)
    static let forumLightGray = UIColor(r: 245, g: 245, b: 245)
    static let forumWhite = UIColor(r: 249, g: 249, b: 249)
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
    }
}
