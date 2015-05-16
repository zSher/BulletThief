//
//  LinePathBulletEffect.swift
//  BulletThief
//
//  Created by Zachary on 5/4/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import Foundation
import SpriteKit

/// This bullet effect...
///
/// * Sets the path of the bullet to be a stright line up or down
class LinePathBulletEffect: NSObject, BulletEffectProtocol {
    var path: UIBezierPath!
    
    override init() {
        var linePath = UIBezierPath()
        linePath.moveToPoint(CGPointZero) //MoveOnPath action is relative to object using it, start 0,0
        linePath.addLineToPoint(CGPointMake(0, 550))
        self.path = linePath
    }
    
    // directional initializer.
    init(direction: Directions) {
        if direction == Directions.Down {
            var linePath = UIBezierPath()
            linePath.moveToPoint(CGPointZero) //MoveOnPath action is relative to object using it, start 0,0
            linePath.addLineToPoint(CGPointMake(0, -650))
            self.path = linePath
        } else {
            var linePath = UIBezierPath()
            linePath.moveToPoint(CGPointZero) //MoveOnPath action is relative to object using it, start 0,0
            linePath.addLineToPoint(CGPointMake(0, 550))
            self.path = linePath
        }
    }
    
    func applyEffect(gun: Gun) {
        for bullet in gun.bulletPool {
            bullet.path = self.path
        }
    }
}
