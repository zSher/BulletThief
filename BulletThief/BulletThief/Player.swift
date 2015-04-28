//
//  Player.swift
//  BulletThief
//
//  Created by Zachary on 4/24/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import UIKit
import SpriteKit

class Player: SKSpriteNode {
    
    let MAX_SPEED = 100
    
    override init(){
        var texture = SKTexture(imageNamed: "player")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.physicsBody = SKPhysicsBody(texture: self.texture, size: self.size)
        self.name = "player"
        self.physicsBody?.dynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = false
        self.physicsBody?.categoryBitMask = CollisionCategories.Player
//        self.physicsBody?.contactTestBitMask = CollisionCategories.Enemy
        self.physicsBody?.collisionBitMask = CollisionCategories.EdgeBody
        self.physicsBody?.allowsRotation = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //direction: false is left | true is right
    func move(direction:Directions, deltaTime: CFTimeInterval) {
        
        var amount = direction == .Left ? CGFloat(MAX_SPEED * -1) : CGFloat(MAX_SPEED)
        
//        self.parent?.scene?.
        
        self.position.x += amount * CGFloat(deltaTime)
    }
    
    func shoot(deltaTime:CFTimeInterval){
        //TODO: figure out bullet mechanics
    }
    
    func update(deltaTime: Float){
        
    }
    

}
