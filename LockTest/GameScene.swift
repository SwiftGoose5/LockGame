//
//
//
// Created by Swift Goose on 8/11/22.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var currentLevel: Int = 1
    var remainingCollectibles: Int = 1
    
    var startingTime = Date()
    var endingTime = Date()
    
    var timeInterval: TimeInterval = 0
    var lastEndContactTime: Double = 0.0
    var lastEndContact: Date = Date.now
    
    let label = Label()
    let labelBg = LabelBackground()
    let player = Player()
    let lockTop = LockTop()
    let lockBase = LockBase()
    var collectible = Collectible()
    
    let victory = SKLabelNode(text: "Victory Achieved!")
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        label.updateLabel(currentLevel)
        
        lockBase.addChild(label)
        lockBase.addChild(labelBg)
        lockBase.addChild(player)
        lockBase.addChild(collectible)
        
        addChild(lockTop)
        addChild(lockBase)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if player.ready {
            clearPin()
            
        } else {
            restartLevel()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        switch currentLevel {
        case 1...4:
            player.zRotation += 0.02 * player.velocity
            
        case 5...9:
            player.zRotation += 0.03 * player.velocity
            
        case 10...14:
            player.zRotation += 0.04 * player.velocity
            
        case 15...20:
            player.zRotation += 0.05 * player.velocity
            
        default:
            player.zRotation += 0.03 * player.velocity
        }
        
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {

        player.ready = true
        
        startingTime = Date.now
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
        lastEndContactTime = Date().timeIntervalSince(lastEndContact)
        
        if lastEndContactTime < 1 { return }

        player.ready = false
        
        endingTime = Date.now
        
        timeInterval = endingTime.timeIntervalSince(startingTime)

        if timeInterval > 0.22 {
            restartLevel()
        } else {
            run(.sequence([.wait(forDuration: 0.12),
                           .run {
                               self.restartLevel()
                           }
            ]))
        }
        
        lastEndContact = Date.now
    }
}

extension GameScene {
    func spawnCollectible(close: Bool = false) {
        if close {
            collectible.setClosePosition(playerVelocity: player.velocity)
        } else {
            collectible.setOppositePosition()
        }
        
        lockBase.addChild(collectible)
        
        collectible.run(.sequence([
            .scale(to: 1, duration: 0.1),
            .fadeAlpha(to: 1, duration: 0.1)
        ]))
    }
    
    func nextLevel() {
        
        if currentLevel >= 2 {
            endGame()
        }
        
        let lockMoveDown = SKAction.moveTo(y: 20, duration: 0.2)
        lockMoveDown.timingMode = .easeInEaseOut
        
        let lockMoveUp = SKAction.moveTo(y: 180, duration: 0.3)
        lockMoveUp.timingMode = .easeInEaseOut
        
        lockTop.run(.sequence([.wait(forDuration: 0.5), .playSoundFileNamed("unlock.mp3", waitForCompletion: false), lockMoveDown, lockMoveUp]))
        
        let lockBaseMoveOut = SKAction.moveTo(x: -600, duration: 0.8)
        lockBaseMoveOut.timingMode = .easeInEaseOut
        
        let lockTopMoveOut = SKAction.moveTo(x: -600, duration: 0.8)
        lockTopMoveOut.timingMode = .easeInEaseOut
        
        let lockBaseMoveIn = SKAction.moveTo(x: 0, duration: 0.8)
        lockBaseMoveIn.timingMode = .easeInEaseOut
        
        let lockTopMoveIn = SKAction.moveTo(x: 0, duration: 0.8)
        lockTopMoveIn.timingMode = .easeInEaseOut
        
        lockBase.run(.sequence([.wait(forDuration: 1), lockBaseMoveOut, .moveTo(x: 600, duration: 0), lockBaseMoveIn]))
        
        lockTop.run(.sequence([.wait(forDuration: 1), lockTopMoveOut, .moveTo(y: 100, duration: 0), .moveTo(x: 600, duration: 0), lockTopMoveIn]))
        
        currentLevel += 1
        remainingCollectibles = currentLevel
        label.updateLabel(remainingCollectibles)
        labelBg.updateLabelBg(currentLevel)
        player.ready = false
        
        spawnCollectible()
    }
    
    func restartLevel() {
        remainingCollectibles = currentLevel
        label.updateLabel(remainingCollectibles)
        player.ready = false
        
        collectible.removeFromParent()
        spawnCollectible()
    }
    
    func clearPin() {
        player.ready = false
        player.velocity *= -1
        
        collectible.run(.sequence([
            .scale(to: 0, duration: 0.1),
            .playSoundFileNamed("pop.m4a", waitForCompletion: false),
            .fadeAlpha(to: 0, duration: 0.1)
        ]))
        
        lockBase.removeChildren(in: [collectible])

        remainingCollectibles -= 1
        label.updateLabel(remainingCollectibles)
        
        if remainingCollectibles == 0 {
            nextLevel()
        } else {
            spawnCollectible(close: true)
        }
    }
    
    func endGame() {
        run(.sequence([.playSoundFileNamed("unlock.mp3", waitForCompletion: false),
                       .wait(forDuration: 0.3),
                       .playSoundFileNamed("unlock.mp3", waitForCompletion: false),
                       .wait(forDuration: 0.5),
                       .playSoundFileNamed("unlock.mp3", waitForCompletion: false),
                       .wait(forDuration: 0.4),]))
        
        lockBase.run(.fadeAlpha(to: 0, duration: 2))
        lockTop.run(.fadeAlpha(to: 0, duration: 2))
        
        lockBase.removeAllChildren()
        lockTop.removeAllChildren()
        removeAllChildren()
        
        victory.fontSize = 50
        victory.fontName = "Futura Bold"
        addChild(victory)
        
        let particle = SKEmitterNode(fileNamed: "Fireworks")!
        particle.position.y = -700
        particle.alpha = 0.2
        particle.setScale(8)
        addChild(particle)
    }
}
