//
//  DefaultSet.swift
//  BulletThief
//
//  Created by Zachary on 5/17/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import UIKit

///This item set gives that player...
/// * Split shot + cross shot to have a crossing pair of bullets
class DoubleCrossSet: NSObject, BulletSet, NSCoding {
    var baseFireRate:CGFloat = 2
    var bulletSpeed: CGFloat = 8
    var numberOfStoredBullets: UInt = 300
    
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
        
        bulletEffects = [TextureBulletEffect(textureName: "pelletBullet"), FireDelayBulletEffect(delay: CFTimeInterval(fireDelay)), SpeedBulletEffect(speed: bulletSpeed), LinePathBulletEffect(), StandardSpawnBulletEffect(), CrossPathBulletEffect(), SplitBulletEffect()]
    }
    
    required init(coder aDecoder: NSCoder) {
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
    }
    
}
