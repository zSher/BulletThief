//
//  Bullet.swift
//  BulletThief
//
//  Created by Zachary on 4/28/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import UIKit
import SpriteKit

//Base for all bullets, bullets behave differently based on bullet effects
class Bullet: SKSpriteNode {
    var damage: UInt = 0
    var path: UIBezierPath?
    
    //MARK - init -
    convenience init(name:String){
        var tex = SKTexture(imageNamed: name)
        self.init(texture: tex, dmg: 1)
        
        setPhysicsBody(0, contactBit: 0, collisionBit: 0)
    }
    
    init(texture:SKTexture, dmg:UInt) {
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.damage = dmg
        
    }

    //Set the physics for this bullet
    func setPhysicsBody(category:UInt32, contactBit:UInt32, collisionBit:UInt32){
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width)
        self.physicsBody?.dynamic = true
        self.physicsBody?.categoryBitMask = category
        self.physicsBody?.contactTestBitMask = contactBit
        self.physicsBody?.collisionBitMask = collisionBit
        self.physicsBody?.usesPreciseCollisionDetection = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
