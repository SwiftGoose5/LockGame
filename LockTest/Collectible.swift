//
//
//
// Created by Swift Goose on 8/11/22.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import SpriteKit

class Collectible: SKSpriteNode {
    
    let spriteRadius: CGFloat!
    let adjustedRadius: CGFloat!
    
    var lastAngle: CGFloat = 270
    var currentAngle: CGFloat = 270
    
    init() {
        let texture = SKTexture(imageNamed: "Orange")
        spriteRadius = texture.size().width/2
        adjustedRadius = 200 - 19 - spriteRadius
        
        super.init(texture: texture, color: .white, size: texture.size())
        
        name = "collectible"
        position = CGPoint(x: 0, y: 0)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        zPosition = 1
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        physicsBody?.categoryBitMask = CollisionType.collectible.rawValue
        physicsBody?.collisionBitMask = 0
        physicsBody?.contactTestBitMask = CollisionType.player.rawValue
        physicsBody?.isDynamic = false
        physicsBody?.affectedByGravity = false
        physicsBody?.allowsRotation = false
        
        setRandomPosition()
    }
    
    func setRandomPosition() {
        lastAngle = currentAngle
        currentAngle = CGFloat.random(in: 0...360)
        
        let adjustedAngle = currentAngle * .pi / 180
        
        let x = cos(adjustedAngle) * adjustedRadius
        let y = sin(adjustedAngle) * adjustedRadius
        
        position = CGPoint(x: x, y: y)
    }
    
    func setOppositePosition() {
        lastAngle = currentAngle
        currentAngle = lastAngle + 180
        
        let adjustedAngle = currentAngle * .pi / 180

        let x = cos(adjustedAngle) * adjustedRadius
        let y = sin(adjustedAngle) * adjustedRadius
        
        position = CGPoint(x: x, y: y)
    }
    
    func setClosePosition(playerVelocity: CGFloat) {
        lastAngle = currentAngle
        
        let randNextAngle = CGFloat.random(in: 60...180)
        
        if playerVelocity == -1 {
            // Clockwise
            currentAngle = lastAngle - randNextAngle
            
        } else {
            // Counter Clockwise
            currentAngle = lastAngle + randNextAngle
        }
        
        let adjustedAngle = currentAngle * .pi / 180
        
        let x = cos(adjustedAngle) * adjustedRadius
        let y = sin(adjustedAngle) * adjustedRadius
        
        position = CGPoint(x: x, y: y)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
