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
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.blackColor()
        shopText = UILabel()
        shopText.text = "Welcome to the shop, Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc orci tellus, rhoncus nec pellentesque ut, bibendum a justo. In hac habitasse platea dictumst. Donec bibendum, magna eu luctus consectetur, erat ex egestas massa, id dapibus nunc ex quis sem. Duis condimentum, sem quis fringilla cursus, odio felis porta elit, vel consectetur odio elit a mauris. Suspendisse hendrerit urna eu elementum egestas. Nulla eu sollicitudin mi, consectetur faucibus urna. Curabitur venenatis nisi in dapibus maximus. Ut non nunc mauris. Donec dui diam, vulputate vel fermentum fermentum, imperdiet quis purus."
        shopText.textAlignment = NSTextAlignment.Left
        shopText.center.x = 10
        shopText.center.y = 5
        
        shopText.frame.size.height = 100
        shopText.frame.size.width = 200
        shopText.lineBreakMode = NSLineBreakMode.ByWordWrapping
        shopText.numberOfLines = 3
        shopText.textColor = UIColor.blueColor()
        self.view?.addSubview(shopText)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let touchLocation = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(touchLocation)
            if touchedNode.name == "start" {
                if let scene = GameScene.unarchiveFromFile("BattleScene") as? GameScene {
                    // Configure the view.
                    let skView = self.view! as SKView
                    scene.scaleMode = SKSceneScaleMode.AspectFill
                    
                    skView.presentScene(scene)
                }
            }
        }
    }
    
    deinit {
        shopText.removeFromSuperview()
    }
}
