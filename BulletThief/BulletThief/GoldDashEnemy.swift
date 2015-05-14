//
//  GoldDashEnemy.swift
//  BulletThief
//
//  Created by Zachary on 5/13/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import UIKit
import SpriteKit

///Very fast enemy that dives across the screen.
///If player can kill and absorb it, it gives gold
class GoldDashEnemy: Enemy {
   
    init(){
        var bulletEffects: [BulletEffectProtocol] = []
        super.init(textureName: "goldDashEnemy", bulletEffects: bulletEffects, bulletCount: 0, speed: 28, name: "goldDashEnemy")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willDie() {
        //Become "Disabled" and able to be stolen
        self.speed = 6
        self.weakened = true
        self.physicsBody?.categoryBitMask = CollisionCategories.None //become unhittable
//        self.removeAllActions()
        var colorizeAction = SKAction.colorizeWithColor(UIColor.grayColor(), colorBlendFactor: 1, duration: 5.0)
        var rotateAction = SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(-M_PI * 2), duration: 10.0))
        var groupAction = SKAction.group([rotateAction, colorizeAction])
        self.runAction(groupAction)
    }
    
    override func steal(){
        playerData.gold += 10 //absorbing gives 10 hold
        self.removeAllActions()
        self.removeFromParent()
    }
    
    override func addToScene(scene: SKScene) {
        var moveAction = SKAction.followPath(movementPath!.CGPath, asOffset: true, orientToPath: false, speed: self.speed)
        var removeAction = SKAction.removeFromParent()
        var onScreenActionGrp = SKAction.sequence([moveAction, removeAction])
        scene.addChild(self)
        self.runAction(onScreenActionGrp)
    }
}
