/***********************

        UNUSED

***********************/

import Foundation
import SpriteKit

//Hud protocol for on screen controller
@objc protocol HudControllerProtocol {
    func moveDpad(hudController: HudController, deltaTime: CFTimeInterval, direction: Int)
}

class HudController: SKNode {
    
    enum HudNames: String {
        case Left = "Left"
        case Right = "Right"
        case Shoot = "Shoot"
    }
    
    let leftArrow: SKSpriteNode, rightArrow: SKSpriteNode
    var screenSize: CGSize!
    
    let RIGHT_ARROW_OFFSET: CGFloat = 30
    var delegate: HudControllerProtocol?
    var isTouchingControl = false
    var touchedDirection = Directions.Left.rawValue
    
    //MARK: - init -
    init(screenSize: CGSize) {
        self.screenSize = screenSize
        var leftImg = SKTexture(imageNamed: "leftArrow")
        leftArrow = SKSpriteNode(texture: leftImg, color: UIColor.clearColor(), size: leftImg.size())
        leftArrow.name = HudNames.Left.rawValue
        leftArrow.position = CGPointMake(leftArrow.size.width, 0)
        leftArrow.userInteractionEnabled = false
        
        var rightImg = SKTexture(imageNamed: "rightArrow")
        rightArrow = SKSpriteNode(texture: rightImg, color: UIColor.clearColor(), size: rightImg.size())
        rightArrow.name = HudNames.Right.rawValue
        rightArrow.position = CGPointMake(leftArrow.position.x + rightArrow.size.width + RIGHT_ARROW_OFFSET, 0)
        rightArrow.userInteractionEnabled = false
        
        super.init()
        
        self.userInteractionEnabled = true
        addChild(leftArrow)
        addChild(rightArrow)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init with coder not created")
    }
    
    //MARK: - Touches Methods -
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        
        for touch: AnyObject in touches {
            let location: CGPoint = touch.locationInNode(self)
            let touchNode = nodeAtPoint(location)
            
            self.checkDpad(touchNode)
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        
        for touch: AnyObject in touches {
            let location: CGPoint = touch.locationInNode(self)
            let touchNode = nodeAtPoint(location)
            
            if isTouchingControl {
                //don't stop movement when shoot is tapped
                if touchNode.name != HudNames.Shoot.rawValue {
                    isTouchingControl = false
                }
            }
        }
        
    }
    
    //MARK: - Update -
    func update(deltaTime: CFTimeInterval) {
        if isTouchingControl {
            delegate?.moveDpad(self, deltaTime: deltaTime, direction: touchedDirection)
        }
    }
    
    func checkDpad(touchNode:SKNode){

        if touchNode.name == HudNames.Left.rawValue || touchNode.name == HudNames.Right.rawValue {
            isTouchingControl = true
            touchedDirection = touchNode.name == HudNames.Left.rawValue ? Directions.Left.rawValue : Directions.Right.rawValue
        }
    }
    
}