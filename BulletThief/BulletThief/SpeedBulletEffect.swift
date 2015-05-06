//
//  SpeedBulletEffect.swift
//  BulletThief
//
//  Created by Zachary on 5/4/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import Foundation
import SpriteKit

class SpeedBulletEffect: NSObject, BulletEffectProtocol {
    var speed: CGFloat = 0
    
    init(speed:CGFloat) {
        self.speed = speed
    }
    
    func applyEffect(gun: Gun) {
        for bullet in gun.bulletPool {
            bullet.speed = speed
        }
    }
}