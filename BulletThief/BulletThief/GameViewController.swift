import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as SKScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = TitleScene(size: view.bounds.size)
        
        if let savedPlayerData = playerData.loadPlayerData() {
            playerData = savedPlayerData
        } else {
            //TODO: New player, maybe show tutorial?
        }
        

        
//        if let scene = GameScene.unarchiveFromFile("BattleScene") as? GameScene {
//            // Configure the view.
//            let skView = self.view as SKView
//            skView.showsFPS = true
//            skView.showsNodeCount = true
//            //            scene.size = skView.bounds.size
//            
//            
//            /* Sprite Kit applies additional optimizations to improve rendering performance */
//            skView.ignoresSiblingOrder = true
//            
//            /* Set the scale mode to scale to fit the window */
//            scene.scaleMode = SKSceneScaleMode.AspectFill
//            
//            skView.presentScene(scene)
//        }

        
        let skView = view as SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}