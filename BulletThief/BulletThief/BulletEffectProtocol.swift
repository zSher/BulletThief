//
//  BulletEffect.swift
//  BulletThief
//
//  Created by Zachary on 5/3/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import UIKit
import SpriteKit

@objc protocol BulletEffectProtocol {
    func applyEffect(gun:Gun)
}