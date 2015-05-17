//
//  WavePathBulletEffect.swift
//  BulletThief
//
//  Created by Zachary on 5/16/15.
//  Copyright (c) 2015 Zachary. All rights reserved.
//

import UIKit
import Foundation

var upWavePath:UIBezierPath?
var downWavePath:UIBezierPath?

/// This bullet effect...
///
/// * Changes bullet paths to follow a wave pattern
class WavePathBulletEffect: NSObject, NSCoding, BulletEffectProtocol {
    var chosenPath:UIBezierPath?
    
    override init(){
        super.init()
        if upWavePath == nil {
            createWavePaths()
        }
    }
    
    convenience init(dir:Directions) {
        self.init()
        if dir == Directions.Up {
            chosenPath = upWavePath
        } else {
            chosenPath = downWavePath
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        self.chosenPath = aDecoder.decodeObjectForKey("path") as? UIBezierPath
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(chosenPath, forKey: "path")
    }

    
    //Create the "static" wave paths
    func createWavePaths(){
        var yPos: [CGFloat] = []
        upWavePath = UIBezierPath()
        
        upWavePath?.moveToPoint(CGPointZero)
        
        var x:CGFloat = CGFloat(100);
        var yc:CGFloat = CGFloat(50);
        var w:CGFloat = CGFloat(100);
        while w <= 900 {
            upWavePath?.addQuadCurveToPoint(CGPointMake(w, 0), controlPoint: CGPointMake(w - 50, yc))
            w += x
            upWavePath?.addQuadCurveToPoint(CGPointMake(w, 0), controlPoint: CGPointMake(w - 50, -yc))
            w += x
        }
        
        downWavePath =  upWavePath?.copy() as? UIBezierPath
        var rotatePath = CGAffineTransformMakeRotation(degreesToRad(90))
        upWavePath?.applyTransform(rotatePath)
        
        var rotateDownPath = CGAffineTransformMakeRotation(degreesToRad(-90))
        downWavePath?.applyTransform(rotateDownPath)
    }
    
    func applyEffect(gun: Gun) {
        for bullet in gun.bulletPool {
            bullet.path = chosenPath
        }
    }
}
