//
//  BulletSet.swift
//  BulletThief
//
//  Created by Zachary on 5/17/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import UIKit

//Base Protocol for bullet sets (essentially weapons)
//Shop is where players can buy "base" weapons that they start out with and can expand on when in game
@objc protocol BulletSet {
    var baseFireRate:CGFloat {get set}
    var bulletSpeed: CGFloat {get set}
    var numberOfStoredBullets: UInt {get set}

    var bulletEffects: [BulletEffectProtocol] {get set}
    
    func recalculateBulletEffects(data:PlayerData)
}
