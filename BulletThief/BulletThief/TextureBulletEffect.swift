//
//  PelletTextureBulletEffect.swift
//  BulletThief
//
//  Created by Zachary on 5/4/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import Foundation
import SpriteKit

/// This bullet effect...
///
/// * Sets the texture of the bullet (which also effects its size)
class TextureBulletEffect: NSObject, NSCoding, BulletEffectProtocol {
    var texture: SKTexture!
    
    init(textureName: String){
        super.init()
        self.texture = SKTexture(imageNamed: textureName)
    }
    
    required init(coder aDecoder: NSCoder) {
        self.texture = aDecoder.decodeObjectForKey("texture") as SKTexture
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(texture, forKey: "texture")
    }
    
    func applyEffect(gun: Gun) {
        for bullet in gun.bulletPool {
            bullet.texture = self.texture
            bullet.size = self.texture.size()
            //TODO: Determine if physics need to be recalculated
        }
    }
    
}