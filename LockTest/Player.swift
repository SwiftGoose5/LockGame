//
//
//
// Created by Swift Goose on 8/11/22.
// Copyright (c) 2022 Swift Goose. All rights reserved.
//
// YouTube: https://www.youtube.com/channel/UCeHYBwcVqOoyyNHiAf3ZrLg
//


import SpriteKit

class Player: SKNode {
    
    let ticker: SKSpriteNode!
    var ready = false
    var velocity = CGFloat(-1) // Clockwise
    
    override init() {
        
        let texture = SKTexture(imageNamed: "Lock_Player")
        ticker = SKSpriteNode(texture: texture, color: .white, size: texture.size())
        
        ticker.name = "player"
        ticker.position = CGPoint(x: 0, y: 150)
        ticker.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        ticker.setScale(0.80)
        ticker.zPosition = 2
        
        ticker.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        ticker.physicsBody?.categoryBitMask = CollisionType.player.rawValue
        ticker.physicsBody?.collisionBitMask = 0
        ticker.physicsBody?.contactTestBitMask = CollisionType.collectible.rawValue
        ticker.physicsBody?.isDynamic = true
        ticker.physicsBody?.affectedByGravity = false
        ticker.physicsBody?.allowsRotation = false
        
        super.init()
        
        addChild(ticker)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
