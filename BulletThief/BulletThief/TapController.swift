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
    
    //Ref to "newest" touch
    //This prevents movement from stopping if 2 fingers are tapped
    var focusedTouch:UITouch?
    
    init(size:CGSize) {
        sizeOfScreen = size
        middleLine = size.width / 2
    }
    
    
    func touchBegan(location: CGPoint, touch:UITouch) {
        isSideTapped = true
        side = location.x < middleLine ? 0 : 1
        focusedTouch = touch //set the touch we are currently watching
    }
    
    func touchesEnded(location: CGPoint, touch:UITouch) {
        if touch == focusedTouch {
            isSideTapped = false //only stop if the touch was lifted
        }
    }
    
    func update(deltaTime: CFTimeInterval) {
        if isSideTapped {
            delegate?.directionTapped(self, deltaTime: deltaTime, direction: side)
        }
    }
}