//
//  StandardSpawnBulletEffect.swift
//  BulletThief
//
//  Created by Zachary on 5/5/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import Foundation
import SpriteKit

/// This bullet effect...
///
/// * Sets the spawn point of a gun to the middle of an actor
class StandardSpawnBulletEffect: NSObject, NSCoding, BulletEffectProtocol {
    
    override init() {
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
    }

    
    func applyEffect(gun: Gun) {
        var spawnPoint:CGPoint = CGPointZero
        if let player = gun.owner as? Player {
            spawnPoint = CGPointMake(0, player.size.height/2) //Offset from center of player
        }
        //TODO: Add code for enemy
        gun.bulletSpawnPoints.append(spawnPoint)
    }
}