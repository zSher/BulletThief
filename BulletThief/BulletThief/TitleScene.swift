//
//  TitleScene.swift
//  BulletThief
//
//  Created by Zachary on 4/29/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import UIKit
import SpriteKit

class TitleScene: SKScene {
    var playButton:SKSpriteNode!
    
    //init
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.blackColor()
        
        var titleNode = SKLabelNode(text: "Bullet\n\tThief")
        titleNode.fontSize = 40
        titleNode.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height - titleNode.fontSize - 10)
        addChild(titleNode)
        
        var texture = SKTexture(imageNamed: "titleImage")
        playButton = SKSpriteNode(texture: texture, color: UIColor.clearColor(), size: texture.size())
        playButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        playButton.name = "play"
        addChild(playButton)
        
        var Circle = SKShapeNode(circleOfRadius: 100 ) // Size of Circle
        Circle.position = CGPointMake(frame.midX, frame.midY)  //Middle of Screen
        Circle.strokeColor = SKColor.blackColor()
        Circle.glowWidth = 1.0
        Circle.fillColor = SKColor.orangeColor()
        self.addChild(Circle)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            let touchLocation = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(touchLocation)
            if touchedNode.name == playButton.name {
                //go to store/menu screen
                let transition = SKTransition.pushWithDirection(SKTransitionDirection.Up, duration: NSTimeInterval(0.25))
                let scene = ShopScene(size: view!.bounds.size)
                self.view?.presentScene(scene, transition: transition)
            }
        }
        
    }
}
