//
//  BulletEffect.swift
//  BulletThief
//
//  Created by Zachary on 5/3/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import UIKit
import SpriteKit

//Bullet effect protocol always have apply effect method
@objc protocol BulletEffectProtocol {
    //Called to change behavior of all bullets in a gun or the gun itself
    func applyEffect(gun:Gun)
}