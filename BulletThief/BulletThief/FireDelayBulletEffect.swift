//
//  FireDelayBulletEffect.swift
//  BulletThief
//
//  Created by Zachary on 5/4/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import Foundation
import SpriteKit

/// This bullet effect...
///
/// * Sets how long to wait until another bullet can be fired
class FireDelayBulletEffect: NSObject, BulletEffectProtocol {
    var delayAmount: CFTimeInterval
    
    init(delay:CFTimeInterval){
        self.delayAmount = delay
    }
    
    func applyEffect(gun: Gun) {
        gun.fireDelay = delayAmount
    }
}