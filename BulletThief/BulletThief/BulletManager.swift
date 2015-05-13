//
//  BulletManager.swift
//  BulletThief
//
//  Created by Zachary on 5/3/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import Foundation
import SpriteKit

class BulletManager: NSObject {
    var inactivePool: [Bullet] = []
    
    
    init(bulletCount:UInt) {
        for i in 0...bulletCount {
            inactivePool.append(Bullet(name: "pelletBullet"))
        }
    }
    
    func requestBullets(numberOfBullets: UInt) -> [Bullet] {
        var bulletPack: [Bullet] = []
        for i in 0...numberOfBullets {
            bulletPack.append(self.inactivePool.removeAtIndex(0))
        }
        return bulletPack
    }
    
    func returnBullets(bullets: [Bullet]) {
        self.inactivePool += bullets
    }
}

var bulletManager:BulletManager = BulletManager(bulletCount: 10000)