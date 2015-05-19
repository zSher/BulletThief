//
//  HyperRapidFireSet.swift
//  BulletThief
//
//  Created by Zachary on 5/17/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import UIKit

///This item set gives that player...
/// * very high rate of fire
class HyperRapidFireSet: NSObject, BulletSet, NSCoding {
    var baseFireRate:CGFloat = 0.10
    var bulletSpeed: CGFloat = 15
    var numberOfStoredBullets: UInt = 1200
    
    var bulletEffects: [BulletEffectProtocol] = []
    
    
    //MARK: - init -
    override init() {
        super.init()
        
    }
    
    init(data:PlayerData) {
        super.init()
        self.recalculateBulletEffects(data)
    }
    
    func recalculateBulletEffects(data:PlayerData) {
        var bulletDecrease = CGFloat(data.bulletDelayLevel - 1) * (baseFireRate * 0.1)
        var fireDelay = baseFireRate - bulletDecrease
        
        bulletEffects = [TextureBulletEffect(textureName: "hyperBullet"), FireDelayBulletEffect(delay: CFTimeInterval(fireDelay)), SpeedBulletEffect(speed: bulletSpeed), LinePathBulletEffect(), StandardSpawnBulletEffect()]
    }
    
    required init(coder aDecoder: NSCoder) {
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
    }
    
}

