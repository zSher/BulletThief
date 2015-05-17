//
//  CrossPathBulletEffect.swift
//  BulletThief
//
//  Created by Zachary on 5/17/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//


import UIKit
import SpriteKit

/// This bullet effect...
///
/// * angles bullet paths so they shoot in a cross
class CrossPathBulletEffect: NSObject, NSCoding, BulletEffectProtocol {
    var leftRotation = CGAffineTransformMakeRotation(degreesToRad(15))
    var rightRotation = CGAffineTransformMakeRotation(degreesToRad(-15))

    
    override init(){
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
    }
    
    func applyEffect(gun: Gun) {
        var isRight = false
        for bullet in gun.bulletPool {
            var augBullet = bullet.path!.copy() as UIBezierPath
            if isRight {
                augBullet.applyTransform(leftRotation)
            } else {
                augBullet.applyTransform(rightRotation)
            }
            
            bullet.path = augBullet
            
            isRight = !isRight
        }
    }
}
