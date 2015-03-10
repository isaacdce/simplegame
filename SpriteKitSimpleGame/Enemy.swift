//
//  Enemy.swift
//  SpriteKitSimpleGame
//
//  Created by Isaac Diaz on 2/25/15.
//  Copyright (c) 2015 Isaac Diaz. All rights reserved.
//

import SpriteKit

enum EnemyType : UInt32 {
    case Mine    = 1
    case Ship    = 2
}

class Enemy: SKSpriteNode{
    
    var fireInterval_ = 2.0
    var lastShot_ = NSTimeInterval(0)
    var health_: Int = 2
    var type_: EnemyType
    //convenience init(imageNamed name: String)

    init(ofType type: EnemyType, withTextures textures: [SKTexture]){
        
        type_ = type
        
        var path = CGPathCreateMutable()
        
        var movement = [SKAction]()
        CGPathMoveToPoint(path, nil, 0, 0)
        
        super.init(texture: textures[0], color: UIColor.clearColor(), size: textures[0].size())
        
        switch type_ {
        case EnemyType.Mine:
            health_ = 2
            CGPathAddLineToPoint(path, nil, -1024, 0)
            
            //Calculate random rotation speed and create rotating action
            let rotateDuration = random(min: CGFloat(0.5), max: CGFloat(5.0))
            
            //Determine if rotating clockwise or counter-clockwise and create action
            let radians = (rotateDuration > 3.0) ? -1 * 2 * π : 1 * 2 * π
            let actionRotate = SKAction.repeatActionForever(SKAction.rotateByAngle( radians, duration: NSTimeInterval(rotateDuration * 2)))
            
            movement.append(actionRotate)
            movement.append(SKAction.sequence([SKAction.moveToX(-frame.width, duration: 3), SKAction.removeFromParent()]))
            
        case EnemyType.Ship:
            health_ = 4
            
            let radius:CGFloat = 200
            
            CGPathAddCurveToPoint(path, nil, -200, 200, -200, -200, -400, 0)
            
            zRotation = π / 2
            //movement.append(SKAction.sequence([SKAction.followPath(path, asOffset: true, orientToPath: true, speed: 200)]))
            movement.append(SKAction.sequence([SKAction.moveToX(1024/2, duration: 0.25), SKAction.waitForDuration(0.5), SKAction.moveToX(-frame.width / 2, duration: 1), SKAction.removeFromParent()]))
            
        }
        
        
        let animation = SKAction.animateWithTextures(textures, timePerFrame: 0.1)
        
        
        runAction((SKAction.group(movement)))
        //zRotation = π
        runAction(SKAction.repeatActionForever(animation))
        name = "enemy"
        zPosition = 1
        //super.init(imageNamed: name)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: textures[0].size().width / 2)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Enemy.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.All.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.dynamic = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shoot(){
        let projectile = SKSpriteNode(imageNamed: "Projectile_2.png")
        //let direction = CGVector(dx: cos(rotation), dy: sin(rotation)).normalized()
        projectile.zPosition = 1
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width / 2)
        projectile.physicsBody?.affectedByGravity = false
        projectile.physicsBody?.dynamic = true
        
        
        //let pos = convertPoint
        //projectile.position = self.position
        
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.None.rawValue
        
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.None.rawValue
        
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        projectile.zRotation = 0
        
        projectile.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
       // projectile.runAction(SKAction.sequence([SKAction.waitForDuration(2), SKAction.removeFromParent()]))
        addChild(projectile)
        
    }
    
    func update(currentTime: NSTimeInterval){
        if(currentTime - lastShot_ >= fireInterval_){
            shoot()
            lastShot_ = currentTime
        }
    }
    
    func hit(){
        health_--
        if(health_ == 0){
            kill()
        }
    }
    
    func kill(){
        
        let explosionAnim = SKAction.animateWithTextures([
            SKTexture(imageNamed: "mine_explosion_1"),
            SKTexture(imageNamed: "mine_explosion_2"),
            SKTexture(imageNamed: "mine_explosion_3"),
            SKTexture(imageNamed: "mine_explosion_4"),
            SKTexture(imageNamed: "mine_explosion_5"),
            SKTexture(imageNamed: "mine_explosion_6"),
            SKTexture(imageNamed: "mine_explosion_7")
            ], timePerFrame: 0.06)
        physicsBody?.categoryBitMask = PhysicsCategory.None.rawValue
        removeAllActions()
        runAction(SKAction.sequence([explosionAnim, SKAction.removeFromParent()]))
    }
    
}