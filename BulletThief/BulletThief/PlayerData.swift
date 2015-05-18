//
//  PlayerData.swift
//  BulletThief
//
//  Created by Zachary on 4/25/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import Foundation

///Singleton class that holds all player info
class PlayerData: NSObject, NSCoding {
    var gold: UInt = 0 //Standard currency
    var farthestTraveled: UInt = 0 //"highscore" per say
    var speedLevel: UInt = 1
    var bulletDelayLevel: UInt = 1
    var bulletNumber: UInt = 1
    var bulletDamage: UInt = 1
    var bulletTexture = "pelletBullet"
    var bulletSet: BulletSet?
    var controlScheme: ControlSchemes = ControlSchemes.Tap
    var purchasedBulletSetFlags: [String: UInt] = ["Basic Gun": 2, "DblX Gun":1, "Hyper Gun": 1] //array of flags, >1 means purchased
    
    var path = documentDirectory.stringByAppendingPathComponent("BulletThief.archive")
    
    //MARK - Init -
    override init(){
        super.init()
        bulletSet = DefaultSet(data: self)
    }
    
    convenience init(gold:UInt, farthestTraveled: UInt, controlScheme: ControlSchemes, speed: UInt, bulletDelay: UInt, bulletNum: UInt, bulletDamage: UInt, bulletSet: BulletSet?, bulletSetFlags:[String:UInt]?) {
        self.init()
        self.gold = gold
        self.farthestTraveled = farthestTraveled
        self.controlScheme = controlScheme
        self.speedLevel = speed
        self.bulletDelayLevel = bulletDelay
        self.bulletNumber = bulletNum
        self.bulletDamage = bulletDamage
        self.bulletSet = bulletSet ?? DefaultSet(data: self)
        self.purchasedBulletSetFlags = bulletSetFlags ?? self.purchasedBulletSetFlags
    }
    
    //MARK: - NSCoder -
    required convenience init(coder aDecoder: NSCoder) {
        //Grab data, call convience init
        var gold = aDecoder.decodeObjectForKey("gold") as UInt
        var travel = aDecoder.decodeObjectForKey("travel") as UInt
        var controlScheme = aDecoder.decodeObjectForKey("controlScheme") as Int
        var bullets = aDecoder.decodeObjectForKey("bullets") as? UInt ?? 1
        var speed = aDecoder.decodeObjectForKey("speed") as? UInt ?? 1
        var bulletDelay = aDecoder.decodeObjectForKey("bDelay") as? UInt ?? 1
        var bulletDamage = aDecoder.decodeObjectForKey("bDamage") as? UInt ?? 1
        var bulletSet = aDecoder.decodeObjectForKey("bSet") as? BulletSet
        var bulletSetFlags = aDecoder.decodeObjectForKey("bSetFlags") as? [String:UInt]

        //TODO: BulletEffects
        
        self.init(gold: gold, farthestTraveled: travel, controlScheme: ControlSchemes(rawValue: controlScheme)!, speed: speed, bulletDelay: bulletDelay, bulletNum: bullets, bulletDamage: bulletDamage, bulletSet: bulletSet, bulletSetFlags: bulletSetFlags)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(gold, forKey: "gold")
        aCoder.encodeObject(farthestTraveled, forKey: "travel")
        aCoder.encodeObject(self.controlScheme.rawValue, forKey: "controlScheme")
        aCoder.encodeObject(speedLevel, forKey: "speed")
        aCoder.encodeObject(bulletDelayLevel, forKey: "bDelay")
        aCoder.encodeObject(bulletNumber, forKey: "bullets")
        aCoder.encodeObject(bulletDamage, forKey: "bDamage")
        aCoder.encodeObject(purchasedBulletSetFlags, forKey: "bSetFlags")
    }
    
    func savePlayerData(){
        if NSKeyedArchiver.archiveRootObject(self, toFile: path) {
            println("Success writing to file!")
        }
        else {
            println("Unable to write to file!")
        }
    }
    
    func loadPlayerData() -> PlayerData? {
        if let data = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? PlayerData {
            return data
        }
        else {
            return nil
        }
    }
}

var playerData: PlayerData = PlayerData()