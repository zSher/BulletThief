//
//  SpeedBulletEffect.swift
//  BulletThief
//
//  Created by Zachary on 5/4/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import Foundation
import SpriteKit

/// This bullet effect...
///
/// * Sets the speed which a bullets moves
class SpeedBulletEffect: NSObject, NSCoding, BulletEffectProtocol {
    var speed: CGFloat = 0
    
    init(speed:CGFloat) {
        self.speed = speed
    }
    
    required init(coder aDecoder: NSCoder) {
        self.speed = aDecoder.decodeObjectForKey("speed") as CGFloat
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(speed, forKey: "speed")
    }

    
    func applyEffect(gun: Gun) {
        for bullet in gun.bulletPool {
            bullet.speed = speed
        }
    }
}