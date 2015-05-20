//
//  PlayScene.swift
//  SpaceShip
//
//  Created by Anil on 07/05/15.
//  Copyright (c) 2015 Variya Soft Solutions. All rights reserved.
//

import Foundation
import SpriteKit

class playScene : SKScene {
    
    var spaceShip : SKSpriteNode!
    var bg1 : SKSpriteNode!
    var bg2 : SKSpriteNode!
    var stone : SKSpriteNode!
    
    var isFingerOnSpaceShip = false
    var originalPosOfBG1 : CGFloat?
    var originalPosOfBG2 : CGFloat?
    
    var star : SKSpriteNode!
    var starFrames : [SKTexture]!
    
    override func didMoveToView(view: SKView) {
        
        addScrollingBG()
        addSpaceShip()
        
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(addStone), SKAction.waitForDuration(2.0)])))
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(addStar), SKAction.waitForDuration(5.0)])))
    }
    
    func addScrollingBG() {
        
        bg1 = SKSpriteNode(imageNamed: "bgPlayScene")
        bg1.anchorPoint = CGPointZero
        bg1.zPosition = -1
        bg1.position = CGPointMake(0, 0)
        originalPosOfBG1 = bg1.position.y
        bg1.size = CGSize(width: frame.size.width, height: frame.size.height)
        addChild(bg1)
        
        bg2 = SKSpriteNode(imageNamed: "bgPlayScene")
        bg2.anchorPoint = CGPointZero
        bg2.zPosition = -1
        bg2.position = CGPointMake(0, bg1.size.height + 1)
        bg2.size = CGSize(width: frame.size.width, height: frame.size.height)
        self.addChild(bg2)
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        
        scrollBackGround()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            if self.nodeAtPoint(location) == self.spaceShip {
                
                isFingerOnSpaceShip = true
            }
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if isFingerOnSpaceShip {
            
            var touch = touches.first as! UITouch
            var touchLocation = touch.locationInNode(self)
            var previousLocation = touch.previousLocationInNode(self)
            
            var spaceX = spaceShip.position.x + (touchLocation.x - previousLocation.x)
            
            spaceX = max(spaceX, spaceShip.size.width/2)
            spaceX = min(spaceX, size.width - spaceShip.size.width/2)
            
            spaceShip.position = CGPointMake(spaceX, spaceShip.position.y)
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        isFingerOnSpaceShip = false
    }
    
    func scrollBackGround(){
        
        bg1.position = CGPointMake(bg1.position.x, bg1.position.y-5)
        bg2.position = CGPointMake(bg2.position.x, bg2.position.y-5)
        
        if bg1.position.y < -bg1.size.height {
            bg1.position = CGPointMake(bg1.position.x, bg2.position.y + bg2.size.height)
        }
        if bg2.position.y < -bg2.size.height {
            bg2.position = CGPointMake(bg2.position.x, bg1.position.y + bg1.size.height)
        }
    }
    
    func addSpaceShip() {
        
        spaceShip = SKSpriteNode(imageNamed: "spaceship")
        spaceShip.position = CGPointMake(self.size.width/2, spaceShip.size.height / 2)
        spaceShip.zPosition = 1
        addChild(spaceShip)
    }
    
    func addStone() {
        stone = SKSpriteNode(imageNamed: "Stone")
        let actualX = random(min: stone.size.height/2, max: size.width - stone.size.height/2)
        stone.position = CGPoint(x: actualX, y: size.height + stone.size.width / 2)
        stone.zPosition = 1
        addChild(stone)
        
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        let actionMove = SKAction.moveTo(CGPoint(x: actualX, y: -stone.size.width / 2), duration: 5.1)
        let actionMoveDone = SKAction.removeFromParent()
        stone.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    func addStar() {
        
        var abc = randomInt(1, max: 4)
        let starName = "Star\(abc)"
        let starAnimatedAtlas = SKTextureAtlas(named: starName)
        var starFramese = [SKTexture]()
        let numImages = starAnimatedAtlas.textureNames.count
        for var i=1; i<=numImages; i++ {
            let starTextureName = "\(i)"
            starFramese.append(starAnimatedAtlas.textureNamed(starTextureName))
        }
        starFrames = starFramese
        
        let firstFrame = starFrames[0]
        star = SKSpriteNode(texture: firstFrame)
        let actualX = random(min: star.size.height/2, max: size.width - star.size.height/2)
        star.position = CGPoint(x:actualX, y:size.height + star.size.width / 2)
        addChild(star)
        
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        let actionMove = SKAction.moveTo(CGPoint(x: actualX, y: -star.size.width / 2), duration: 5.1)
        let actionMoveDone = SKAction.removeFromParent()
        star.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
        playStarAnimation(abc)
    }
    
    func playStarAnimation(starCount: Int) {
        
        star.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(starFrames, timePerFrame: 0.1, resize: false, restore: true)), withKey:"starAnimation\(starCount)")
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(#min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
}
