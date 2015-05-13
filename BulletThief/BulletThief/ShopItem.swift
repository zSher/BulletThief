//
//  ShopItem.swift
//  BulletThief
//
//  Created by Zachary on 5/8/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import UIKit

class ShopItem: NSObject {
    var itemName:String = ""
    var detailText:String = ""
    var cost:UInt = 0
    var baseCost:UInt = 0
    var costChange:UInt = 0
    var action: (data:PlayerData) -> ()
    override init() {
        action = {(data) in }
        super.init()
    }
    
    convenience init(name:String, detail:String, cost:UInt, costChange:UInt, costLevel:UInt,  action: (data:PlayerData) -> ()) {
        self.init()
        self.itemName = name
        self.detailText = detail
        self.baseCost = cost
        self.costChange = costChange
        calculateCost(costLevel)
        self.action = action

    }
    
    func calculateCost(costLevel: UInt){
        self.cost = baseCost + costChange * (costLevel - 1)
    }
    
    func applyItemEffect(data:PlayerData) {
        self.action(data: data) //function pointers, cooool
    }
}

//Singleton to hold all item effects
class ItemEffectLibrary {
    
    //increase movement speed by 10%
    func increaseMovementSpeed(data:PlayerData) {
        data.speedLevel += 1
    }
    
    //increase bullet fire rate by 10%
    func increaseFireRate(data:PlayerData) {
        data.bulletDelayLevel += 1
    }
    
    //increase bullet damage
    func increaseBulletDamage(data:PlayerData) {
        //TODO: Bullet damage
        println("Bullet Damage Not Completed yet")
    }
    
    //increase number of shots per fire
    func increaseBulletNumber(data:PlayerData){
        data.bulletNumber += 1
    }
}
var itemEffectLibrary = ItemEffectLibrary()