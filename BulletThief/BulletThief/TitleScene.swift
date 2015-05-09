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

    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            let touchLocation = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(touchLocation)
            if touchedNode.name == playButton.name {
                if let scene = ShopScene.unarchiveFromFile("ShopScene") as? ShopScene {
                    // Configure the view.
                    let skView = self.view! as SKView
                    
                    /* Set the scale mode to scale to fit the window */
                    scene.scaleMode = SKSceneScaleMode.AspectFill
                    
                    skView.presentScene(scene)
                }
            }
        }
        
    }
}
