//
//  Utilities.swift
//  SpaceInvaders
//
//  Created by Zachary on 4/20/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

//MARK: - Extensions -
extension Array {
    func randomElement() -> T {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

//Exension to get character from string
//From StackOverflow http://stackoverflow.com/questions/24092884/get-nth-character-of-a-string-in-swift-programming-language
extension String {
    
    subscript (i: Int) -> Character {
        return self[advance(self.startIndex, i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
    }
}

//Extension to find distance between spritenodes
extension SKSpriteNode {
    func distanceBetween(other: SKSpriteNode) -> CGFloat {
        var xVal = other.position.x - self.position.x
        var yVal = other.position.y - self.position.y
        return hypot(xVal, yVal)
    }
}

//MARK: - Collision Category -
struct CollisionCategories{
    static let None : UInt32 = 0x0
    static let Enemy : UInt32 = 0x1
    static let Player: UInt32 = 0x1 << 1
    static let EnemyBullet: UInt32 = 0x1 << 2
    static let PlayerBullet: UInt32 = 0x1 << 3
    static let EdgeBody: UInt32 = 0x1 << 4
    static let Gold: UInt32 = 0x1 << 5

}

//MARK: - Helper functions -
// Return a random range
func randomRange(min: CGFloat, max: CGFloat) -> CGFloat {
    assert(min
        < max)
    return CGFloat(arc4random()) / 0xFFFFFFFF * (max - min) + min
}

//Helper to find index of item in arrays
func findIndex<T: Equatable>(array: [T], valueToFind: T) -> Int? {
    for (index, value) in enumerate(array) {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

//Convert degrees to radians
func degreesToRad(x:CGFloat) -> CGFloat {
    return CGFloat(M_PI) * x / CGFloat(180.0)
}

//MARK: - Enums -
enum Directions: Int {
    case Left = 0
    case Right
    case Up
    case Down
}

//enum for control types
enum ControlSchemes: Int {
    case Tap = 0
    case Buttons
}

//MARK: - File IO -
var documentDirectories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
var documentDirectory = documentDirectories[0] as String

