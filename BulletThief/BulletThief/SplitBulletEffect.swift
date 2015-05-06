//
//  SplitBulletEffect.swift
//  BulletThief
//
//  Created by Zachary on 5/3/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import Foundation
import SpriteKit

/// This bullet effect...
///
/// * doubles the current number of bullets shot
/// * Adds a spawn point per bullet to create a line of shots based on the gun owner's size'
class SplitBulletEffect: NSObject, BulletEffectProtocol {
    func applyEffect(gun:Gun) {
        gun.bulletSpawnPoints.removeAll(keepCapacity: false)
        gun.numberOfBulletsToFire *= 2
        var dividedWidth = gun.owner!.size.width / CGFloat(gun.numberOfBulletsToFire)
        var firstHalfCount = gun.numberOfBulletsToFire/2
        for i in 1...firstHalfCount {
            var leftSpawnPt = CGPointMake(-dividedWidth * CGFloat(i), gun.owner!.size.height/2)
            gun.bulletSpawnPoints.append(leftSpawnPt)
        }
        for i in 1...firstHalfCount{
            var rightSpawnPt = CGPointMake(dividedWidth * CGFloat(i), gun.owner!.size.height/2)
            gun.bulletSpawnPoints.append(rightSpawnPt)
        }
    }
}