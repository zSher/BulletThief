//
//  ShopScene.swift
//  BulletThief
//
//  Created by Zachary on 4/30/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import UIKit
import SpriteKit

//Middle scene player deals with to upgrade their player
//Shop has multiple pages of items
class ShopScene: SKScene {
    var table:UITableView!
    var currentShopIndex = 0
    var shopItems:[ShopItem] = []
    var shopDetailLbl: SKLabelNode!
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.blackColor()
        
        //Create a main set of items that scale off of character's current upgrades
        shopItems = [
            ShopItem(name: "Thrusters +", detail: "Movement speed +10%", cost: 5, costChange: 10, costLevel: playerData.speedLevel, action: itemEffectLibrary.increaseMovementSpeed),
            ShopItem(name: "Coolant +", detail: "Fire rate +10%", cost: 10, costChange: 10, costLevel: playerData.bulletDelayLevel, action: itemEffectLibrary.increaseFireRate),
            ShopItem(name: "Velocity +", detail: "Bullet Speed +1", cost: 20, costChange: 20, costLevel: playerData.bulletDamage, action: itemEffectLibrary.increaseBulletDamage),
            ShopItem(name: "Barrel +", detail: "Bullets fired 1+", cost: 30, costChange: 30, costLevel: playerData.bulletNumber, action: itemEffectLibrary.increaseBulletNumber),
            ShopItem(name: "Basic Gun", detail: "Good Ol' gun", cost: 0, costChange: 0, costLevel: 0, action: itemEffectLibrary.equipDefaultSet, equippable: true),
            ShopItem(name: "DblX Gun", detail: "Split Cross", cost: 100, costChange: 0, costLevel: 0, action: itemEffectLibrary.equipDoubleCrossSet, equippable: true),
            ShopItem(name: "Hyper Gun", detail: "You want bullets?!?", cost: 100, costChange: 0, costLevel: 0, action: itemEffectLibrary.equipHyperRapidSet, equippable: true),
            ShopItem(name: "Ship Mini", detail: "Dodge more, hit less", cost: 10000, costChange: 50000, costLevel: 1, action: itemEffectLibrary.increaseMovementSpeed),
            ShopItem(name: "Yamato Gun", detail: "And everything died", cost: 99999, costChange: 50000, costLevel: 1, action: itemEffectLibrary.increaseMovementSpeed)
        ]
        

        shopDetailLbl = childNodeWithName("shopLbl1") as SKLabelNode
        shopDetailLbl.text = "What would you like"
        
        updateShopDisplay()
    }
    
    //TODO: Fix up, clean up
    //Update the costs of items after you purchase them.
    func updateCosts(){
        shopItems[0].calculateCost(playerData.speedLevel)
        shopItems[1].calculateCost(playerData.bulletDelayLevel)
        shopItems[2].calculateCost(playerData.bulletDamage)
        shopItems[3].calculateCost(playerData.bulletNumber)
        shopItems[5].calculateEquipmentCost(playerData.purchasedBulletSetFlags[shopItems[5].itemName]!)
        shopItems[6].calculateEquipmentCost(playerData.purchasedBulletSetFlags[shopItems[6].itemName]!)
        //TODO: other items
    }
    
    //Refresh the shop display based on current shop index
    func updateShopDisplay(){
        //Update UI with Shop content
        for i in 0..<4 {
            var node = childNodeWithName("item\(i + 1)")
            var itemNumber = i + (currentShopIndex * 4)
            var nameLbl = node?.childNodeWithName("itemName") as SKLabelNode
            var detailLbl = node?.childNodeWithName("detailText") as SKLabelNode
            var costLbl = node?.childNodeWithName("cost") as SKLabelNode
            var buySprite = node?.childNodeWithName("buyButton") as SKSpriteNode
            
            if itemNumber < shopItems.count {
                var item = shopItems[itemNumber]
                nameLbl.text = item.itemName
                detailLbl.text = item.detailText
                costLbl.text =  (item.equippable && item.cost == 0) ? "Equip" : "Cost: \(item.cost)"
            } else {
                nameLbl.text = "Not available"
                detailLbl.text = "Not available"
                costLbl.text = "Cost: XXX"
            }
        }
        
        var goldNode = childNodeWithName("goldLbl") as SKLabelNode
        goldNode.text = "Gold: \(playerData.gold)"
    }
    
    //MARK: - touches -
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let touchLocation = touch.locationInNode(self)  
            let touchedNode = self.nodeAtPoint(touchLocation)
        
            if touchedNode.name == "buyButton" {
                var parent = touchedNode.parent!
                
                //Figure out what button was pressed and pull the correct shop item out of the list using last character in buttons name
                var lastCharacterString: String = parent.name![4]
                if lastCharacterString.toInt()! - 1 + (currentShopIndex * 4) < shopItems.count {
                    var item = shopItems[lastCharacterString.toInt()! - 1 + (currentShopIndex * 4)]
                    if playerData.gold >= item.cost{
                        item.applyItemEffect(playerData)
                        playerData.gold -= item.cost
                        
                        //Player now owns this bulletset, don't need to buy anymore
                        if item.equippable && playerData.purchasedBulletSetFlags[item.itemName] == 1{
                            playerData.purchasedBulletSetFlags[item.itemName] = 2 //Purchased
                        }
                        
                        if !item.equippable{
                            displayThankYouMessage("Thank you for your purchase")
                        } else {
                            displayThankYouMessage("Your gun is equipped, good luck")
                        }
                        
                        updateCosts()
                        playerData.savePlayerData()
                        self.updateShopDisplay()
                    } else {
                        displayErrorMessage()
                    }
                }
            } else if touchedNode.name == "start" {
                if let scene = GameScene.unarchiveFromFile("BattleScene") as? GameScene {
                    // Configure the view.
                    playerData.bulletSet?.recalculateBulletEffects(playerData)
                    let skView = self.view! as SKView
                    scene.scaleMode = SKSceneScaleMode.AspectFill
                    
                    skView.presentScene(scene)
                }
            } else if touchedNode.name == "nextPage" {
                if (currentShopIndex + 1) * 4 < shopItems.count{
                    currentShopIndex++
                    updateShopDisplay()
                }

            } else if touchedNode.name == "backPage" {
                if currentShopIndex > 0 {
                    currentShopIndex--
                    updateShopDisplay()
                }
            } else if touchedNode.name == "cheatLbl" {
                playerData.gold = 10000
                for (key, value) in playerData.purchasedBulletSetFlags {
                    playerData.purchasedBulletSetFlags[key] = 2
                }
                self.updateCosts()
                self.updateShopDisplay()
            } else if touchedNode.name == "resetLbl" {
                playerData = PlayerData()
                playerData.savePlayerData()
            }
            
        }
    }
    
    //Show error that pulses size and changes color to red
    func displayErrorMessage(){
        shopDetailLbl.text = "You don't have enough Gold!"
        var growAction = SKAction.scaleTo(1.25, duration: 0.25)
        var shrinkAction = SKAction.scaleTo(1, duration: 0.25)
        var sequenceAction = SKAction.sequence([growAction, shrinkAction])
        shopDetailLbl.fontColor = UIColor.redColor()
        shopDetailLbl.runAction(sequenceAction)
    }
    
    //Show a thank you message for a purchase
    func displayThankYouMessage(msg: String){
        shopDetailLbl.text = msg
        var growAction = SKAction.scaleTo(1.25, duration: 0.25)
        var shrinkAction = SKAction.scaleTo(1, duration: 0.25)
        var sequenceAction = SKAction.sequence([growAction, shrinkAction])
        shopDetailLbl.fontColor = UIColor.greenColor()
        shopDetailLbl.runAction(sequenceAction)
    }
    
    deinit {
    }

}
