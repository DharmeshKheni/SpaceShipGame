//
//  GameScene.swift
//  SpaceShip
//
//  Created by Anil on 07/05/15.
//  Copyright (c) 2015 Variya Soft Solutions. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var play : SKSpriteNode!
    var playButtonFrames : [SKTexture]!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        addBG()
        addPlay()
    }
    
    func addBG() {
        
        let bg = SKSpriteNode(imageNamed: "bg")
        bg.position = CGPointMake(self.size.width/2, self.size.height/2)
        bg.size = view!.bounds.size
        addChild(bg)
    }
    
    func addPlay() {
        
        let playAnimatedAtlas = SKTextureAtlas(named: "PlayButton")
        var playFramese = [SKTexture]()
        let numImages = playAnimatedAtlas.textureNames.count
        for var i=1; i<=numImages; i++ {
            let playTextureName = "\(i)"
            playFramese.append(playAnimatedAtlas.textureNamed(playTextureName))
        }
        playButtonFrames = playFramese
        
        let firstFrame = playButtonFrames[0]
        play = SKSpriteNode(texture: firstFrame)
        play.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        addChild(play)
        
        playAnimation()
    }
    
    func playAnimation() {
        
        play.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(playButtonFrames, timePerFrame: 0.1, resize: false, restore: true)), withKey:"playAnimation")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            
            let location = touch.locationInNode(self)
            if self.nodeAtPoint(location) == self.play {
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let letsPlay = playScene(size: self.size)
                play.removeAllActions()
                self.view?.presentScene(letsPlay, transition: reveal)
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
