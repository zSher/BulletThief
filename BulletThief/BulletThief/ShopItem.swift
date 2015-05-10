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
    var action: (data:PlayerData) -> ()
    
    override init() {
        action = {(data) in }
        super.init()
    }
    
    init(name:String, detail:String, cost:UInt, action: (data:PlayerData) -> ()) {
        self.itemName = name
        self.detailText = detail
        self.cost = cost
        self.action = action

    }
    
    func applyItemEffect(data:PlayerData) {
        self.action(data: data) //function pointers, cooool
    }
}

//Singleton to hold all item effects
class ItemEffectLibrary {
    
    //increase movement speed by 10%
    func increaseMovementSpeed(data:PlayerData) {
        data.player!.speed += data.player!.speed * 0.10
    }
    
    //increase bullet fire rate by 10%
    func increaseFireRate(data:PlayerData) {
        data.player!.gun!.fireDelay -= data.player!.gun!.fireDelay * 0.10
    }
    
    //increase bullet damage
    func increaseBulletDamage(data:PlayerData) {
        //TODO: Bullet damage
        println("Bullet Damage Not Completed yet")
    }
    
    //increase number of shots per fire
    func increaseBulletNumber(data:PlayerData){
        data.player!.gun!.numberOfBulletsToFire += 1
    }
}