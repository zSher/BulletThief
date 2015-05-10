//
//  Player.swift
//  BulletThief
//
//  Created by Zachary on 4/24/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import UIKit
import SpriteKit

@IBDesignable class Player: SKSpriteNode {
    
    let MAX_SPEED = 100
    var gun:Gun!
    
    override init(){
        var texture = SKTexture(imageNamed: "player")
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())

    }
    
    //Init from sks file
    init(node: SKSpriteNode){
        super.init(texture: node.texture, color: node.color, size:node.texture!.size())
        self.position = node.position
        self.shader = node.shader
        
        self.physicsBody = SKPhysicsBody(texture: self.texture, size: self.size)
        self.name = "player"
        self.physicsBody?.dynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = false
        self.physicsBody?.categoryBitMask = CollisionCategories.Player
        self.physicsBody?.contactTestBitMask = CollisionCategories.EnemyBullet
        self.physicsBody?.collisionBitMask = CollisionCategories.EdgeBody
        self.physicsBody?.allowsRotation = false
        
        var bulletEffects: [BulletEffectProtocol] = [TextureBulletEffect(textureName: "pelletBullet"), FireDelayBulletEffect(delay: 2), SpeedBulletEffect(speed: 8), LinePathBulletEffect(), StandardSpawnBulletEffect()]
        
        self.gun = Gun(initialEffects: bulletEffects, owner: self)
        self.gun.setPhysicsBody(CollisionCategories.PlayerBullet, contactBit: CollisionCategories.Enemy, collisionBit: CollisionCategories.None)
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
        gun.shoot()
    }
    
    func update(deltaTime: CFTimeInterval){
        gun.update(deltaTime)
        if gun.canShoot {
            gun.shoot()
        }
    }
    

}
