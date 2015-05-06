//
//  PelletTextureBulletEffect.swift
//  BulletThief
//
//  Created by Zachary on 5/4/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import Foundation
import SpriteKit

class TextureBulletEffect: NSObject, BulletEffectProtocol {
    var texture: SKTexture!
    
    init(textureName: String){
        super.init()
        self.texture = SKTexture(imageNamed: textureName)
    }
    
    func applyEffect(gun: Gun) {
        for bullet in gun.bulletPool {
            bullet.texture = self.texture
            bullet.size = self.texture.size()
            //TODO: Determine if physics need to be recalculated
        }
    }
}