//
//  Shape.swift
//  d06
//
//  Created by Audrey ROEMER on 4/3/18.
//  Copyright © 2018 Audrey ROEMER. All rights reserved.
//

import UIKit

class Shape: UIView {
    
    var x: CGFloat?
    var y: CGFloat?
    var isCircle: Bool = false
    let shapeWidth: CGFloat = 100.0
    let shapeHeight: CGFloat = 100.0
    
    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
        let rectangle = CGRect(x: x - shapeWidth / 2, y: y - shapeHeight / 2, width: shapeWidth, height: shapeHeight)
        super.init(frame: rectangle)
        randomShape()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var shapeColors : [UIColor] = [.green, .red, .yellow, .blue, .orange, .magenta]
    var shapeForms : [String] = ["circle", "rectangle"]
    
    func randomShape() {
        let colorsToGetRandomly = shapeColors
        let index = Int(arc4random_uniform(UInt32(colorsToGetRandomly.count)))
        self.backgroundColor = colorsToGetRandomly[index]
        self.clipsToBounds = true
        let formsToGetRandomly = shapeForms
        let indexbis = Int(arc4random_uniform(UInt32(formsToGetRandomly.count)))
        if formsToGetRandomly[indexbis] == "circle"
        {
            self.isCircle = true
            self.layer.cornerRadius = self.shapeWidth / 2
        }
    }
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType{
        if self.isCircle == true
        {
            return .ellipse
        }
        return .rectangle
    }
}
