//
//  TapController.swift
//  BulletThief
//
//  Created by Zachary on 5/3/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import Foundation
import SpriteKit

@objc protocol TapControllerProtocol {
    func directionTapped(tapController: TapController, deltaTime: CFTimeInterval, direction: Int)
}

class TapController: NSObject {
//    var leftSide:SKNode, rightSide:SKNode
    var delegate: TapControllerProtocol?
    var sizeOfScreen:CGSize!
    var middleLine:CGFloat!
    
    var isSideTapped = false
    var side = 0
    
    init(size:CGSize) {
        sizeOfScreen = size
        middleLine = size.width / 2
    }
    
    func touchBegan(location: CGPoint) {
        isSideTapped = true
        side = location.x < middleLine ? 0 : 1
    }
    
    func touchesEnded(location: CGPoint) {
        isSideTapped = false
    }
    
    func update(deltaTime: CFTimeInterval) {
        if isSideTapped {
            delegate?.directionTapped(self, deltaTime: deltaTime, direction: side)
        }
    }
}