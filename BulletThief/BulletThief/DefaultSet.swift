//
//  DefaultSet.swift
//  BulletThief
//
//  Created by Zachary on 5/17/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import UIKit

///This item set gives that player...
/// * the default shot style
class DefaultSet: NSObject, BulletSet, NSCoding {
    var baseFireRate:CGFloat = 2
    var bulletSpeed: CGFloat = 8
    var numberOfStoredBullets: UInt = 700

    var bulletEffects: [BulletEffectProtocol] = []
    
    
    //MARK: - init -
    override init() {
        super.init()

    }
    
    //Initialize
    init(data:PlayerData) {
        super.init()
        self.recalculateBulletEffects(data)
    }
    
    //When about to go into game screen, recalculate all the effects if player data changed
    func recalculateBulletEffects(data:PlayerData) {
        var bulletDecrease = CGFloat(data.bulletDelayLevel - 1) * (baseFireRate * 0.1)
        var fireDelay = baseFireRate - bulletDecrease
        
        bulletEffects = [TextureBulletEffect(textureName: "pelletBullet"), FireDelayBulletEffect(delay: CFTimeInterval(fireDelay)), SpeedBulletEffect(speed: bulletSpeed), LinePathBulletEffect(), StandardSpawnBulletEffect()]
    }
    
    required init(coder aDecoder: NSCoder) {
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
    }
    
}
