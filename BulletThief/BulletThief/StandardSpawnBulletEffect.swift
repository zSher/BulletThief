//
//  StandardSpawnBulletEffect.swift
//  BulletThief
//
//  Created by Zachary on 5/5/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import Foundation
import SpriteKit

class StandardSpawnBulletEffect: NSObject, BulletEffectProtocol {
    
    override init() {
        
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