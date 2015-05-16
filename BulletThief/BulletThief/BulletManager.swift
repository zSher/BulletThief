//
//  BulletManager.swift
//  BulletThief
//
//  Created by Zachary on 5/3/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import Foundation
import SpriteKit

//Manager to hold a pool of bullets that can be given out to classes without needing to instantiate more
class BulletManager: NSObject {
    var inactivePool: [Bullet] = []
    
    
    init(bulletCount:UInt) {
        for i in 0...bulletCount {
            inactivePool.append(Bullet(name: "pelletBullet"))
        }
    }
    
    func requestBullets(numberOfBullets: UInt) -> [Bullet] {
        var bulletPack: [Bullet] = []
        if numberOfBullets > 0 {
            for i in 0...numberOfBullets {
                bulletPack.append(self.inactivePool.removeAtIndex(0))
            }
        }
        return bulletPack
    }
    
    func returnBullets(bullets: [Bullet]) {
        //TODO: reset bullets to normal
        self.inactivePool += bullets
    }
}

var bulletManager:BulletManager = BulletManager(bulletCount: 10000) //10,000 should be enough, right?