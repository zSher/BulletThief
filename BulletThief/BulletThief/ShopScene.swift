//
//  ShopScene.swift
//  BulletThief
//
//  Created by Zachary on 4/30/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import UIKit
import SpriteKit

class ShopScene: SKScene {
    var shopText:UILabel!
    var battleButton:SKShapeNode!
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.blackColor()
        shopText = UILabel()
        shopText.text = "Welcome to the shop, Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc orci tellus, rhoncus nec pellentesque ut, bibendum a justo. In hac habitasse platea dictumst. Donec bibendum, magna eu luctus consectetur, erat ex egestas massa, id dapibus nunc ex quis sem. Duis condimentum, sem quis fringilla cursus, odio felis porta elit, vel consectetur odio elit a mauris. Suspendisse hendrerit urna eu elementum egestas. Nulla eu sollicitudin mi, consectetur faucibus urna. Curabitur venenatis nisi in dapibus maximus. Ut non nunc mauris. Donec dui diam, vulputate vel fermentum fermentum, imperdiet quis purus."
        shopText.textAlignment = NSTextAlignment.Left
        shopText.center.x = 10
        shopText.center.y = 10
        
        shopText.frame.size.height = 100
        shopText.frame.size.width = 250
        shopText.lineBreakMode = NSLineBreakMode.ByWordWrapping
        shopText.numberOfLines = 3
        shopText.textColor = UIColor.blueColor()
        self.view?.addSubview(shopText)
        
        var bottomGuide = SKShapeNode()
        var pathToDraw = CGPathCreateMutable()
        CGPathMoveToPoint(pathToDraw, nil, 0, self.size.height - 100)
        CGPathAddLineToPoint(pathToDraw, nil, self.size.width, self.size.height - 100)
        bottomGuide.path = pathToDraw
        bottomGuide.strokeColor = UIColor.redColor()
        bottomGuide.fillColor = UIColor.redColor()
        bottomGuide.position = CGPointMake(0, 0)
        addChild(bottomGuide)
        
        var rect = CGRectMake(0, 0, 100, 50)
        var corners = CGFloat(5.0)
        var path = CGPathCreateWithRoundedRect(rect, corners, corners, nil)
        battleButton = SKShapeNode(path: path, centered: true)
        battleButton.position.x = self.size.width - rect.width - 10
        battleButton.position.y = 0
        battleButton.fillColor = UIColor.redColor()
        battleButton.strokeColor = UIColor.redColor()

        battleButton.name = "battle"
        addChild(battleButton)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let touchLocation = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(touchLocation)
            if touchedNode.name == battleButton.name {
                //go to store/menu screen
                let transition = SKTransition.pushWithDirection(SKTransitionDirection.Up, duration: NSTimeInterval(0.25))
                let scene = GameScene(size: view!.bounds.size)
                self.view?.presentScene(scene, transition: transition)
            }
        }
    }
    
    deinit {
        shopText.removeFromSuperview()
    }
}
