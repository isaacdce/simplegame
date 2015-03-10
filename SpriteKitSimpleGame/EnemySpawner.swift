//
//  EnemySpawner.swift
//  SpriteKitSimpleGame
//
//  Created by Isaac Diaz on 3/3/15.
//  Copyright (c) 2015 Isaac Diaz. All rights reserved.
//

import SpriteKit


class EnemySpawner: SKNode {
    var enemies_ = [Enemy]()
    var animations_ = [[SKTexture]](count: 2, repeatedValue: [SKTexture]())
    var lastSpawn_ =  NSTimeInterval(0)
    var spawning_ = false
    override init(){
            for(var i = 1; i <= 10; i++){
                animations_[0].append(SKTexture(imageNamed: "mine_\(i)"))
                animations_[1].append(SKTexture(imageNamed: "enemy1_\(i)"))
            }
        
        super.init()
    }
    
    func spawnEnemy() {
        
        // Determine where to spawn the monster along the X axis
        let actualY = random(min: 50 + (frame.height / 2), max: parent!.frame.height  - 50 - (frame.height / 2))
        var enemyRand = Int(arc4random_uniform(10))
        var enemyType: EnemyType
        
        if(enemyRand > 1){
            enemyRand = 1
        }
        
        switch enemyRand{
        case 0:
            enemyType = EnemyType.Mine
        case 1:
            enemyType = EnemyType.Ship
        default:
            enemyType = EnemyType.Mine
        }
        
        // Position the monster slightly off-screen along the top edge,
        // and along a random position along the X axis as calculated above
        var position = CGPoint(x: parent!.frame.width, y: actualY)
        
        let enemy = Enemy(ofType: enemyType , withTextures: animations_[enemyRand])
        
        enemy.position = position
        
        addChild(enemy)
        
        //var velocity = random(min: -300.0, max: -100.0)
        
        //enemy.physicsBody?.velocity = CGVector(dx: velocity, dy: 0)
        

        
        

        //CGPathAddArc(path, nil, 0, 0, radius, 0, π, false)
        
        
        
        
        /*
        var circle = CGPathCreateMutable()
        CGPathAddArc(circle, nil, position.x, position.y, 18, 0.0, 2 * CGFloat(π), true)
        var object: SKSpriteNode
        var animation: SKAction
        
        var velocity = random(min: -300.0, max: -100.0)
        
        if(velocity > -120){
        object = SKSpriteNode(imageNamed: "ring_1.png")
        animation = SKAction.animateWithTextures([
        SKTexture(imageNamed: "ring_1"),
        SKTexture(imageNamed: "ring_2"),
        SKTexture(imageNamed: "ring_3"),
        SKTexture(imageNamed: "ring_4"),
        SKTexture(imageNamed: "ring_5"),
        SKTexture(imageNamed: "ring_6"),
        SKTexture(imageNamed: "ring_7"),
        SKTexture(imageNamed: "ring_8"),
        SKTexture(imageNamed: "ring_9"),
        SKTexture(imageNamed: "ring_10"),
        SKTexture(imageNamed: "ring_11"),
        SKTexture(imageNamed: "ring_12"),
        SKTexture(imageNamed: "ring_13")
        ], timePerFrame: 0.04)
        
        object.physicsBody = SKPhysicsBody(circleOfRadius: object.size.width / 4)
        object.physicsBody!.categoryBitMask = PhysicsCategory.PowerUp.rawValue
        object.runAction(SKAction.repeatActionForever(animation))
        }else{
        object = SKSpriteNode(imageNamed: "mine_1.png")
        animation = SKAction.animateWithTextures([
        SKTexture(imageNamed: "mine_1"),
        SKTexture(imageNamed: "mine_2"),
        SKTexture(imageNamed: "mine_3"),
        SKTexture(imageNamed: "mine_4"),
        SKTexture(imageNamed: "mine_5"),
        SKTexture(imageNamed: "mine_6"),
        SKTexture(imageNamed: "mine_7"),
        SKTexture(imageNamed: "mine_8"),
        SKTexture(imageNamed: "mine_9"),
        SKTexture(imageNamed: "mine_10")
        ], timePerFrame: 0.1)
        
        object.physicsBody = SKPhysicsBody(circleOfRadius: object.size.width / 4)
        object.physicsBody!.categoryBitMask = PhysicsCategory.Enemy.rawValue
        object.runAction(SKAction.repeatActionForever(animation))
        }
        
        
        object.position = position
        object.zPosition = 1
        
        
        object.physicsBody?.affectedByGravity = false
        object.physicsBody?.dynamic = true
        
        
        object.physicsBody?.velocity = CGVectorMake(velocity, 0)
        
        object.physicsBody?.contactTestBitMask = PhysicsCategory.All.rawValue
        object.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        
        object.runAction(SKAction.sequence([SKAction.waitForDuration(10), SKAction.removeFromParent()]))
        
        addChild(object)
        
        //Calculate random rotation speed and create rotating action
        let rotateDuration = random(min: CGFloat(0.5), max: CGFloat(5.0))
        
        //Determine if rotating clockwise or counter-clockwise and create action
        let radians = (rotateDuration > 3.0) ? -1 * 2 * π : 1 * 2 * π
        let actionRotate = SKAction.repeatActionForever(SKAction.rotateByAngle( radians, duration: NSTimeInterval(rotateDuration * 2)))
        
        //Enemy will rotate at a random speed across the screen and be removed after 10 secs
        object.runAction(SKAction.group([actionRotate, SKAction.sequence([SKAction.waitForDuration(10), SKAction.removeFromParent()])]))
        
        */
        
    }
    
    func startSpawning(){
    
        spawning_ = true
    }
    
    func update(currentTime: NSTimeInterval){
        if(currentTime - lastSpawn_ > 0.5 && spawning_ == true){
            spawnEnemy()
            lastSpawn_ = currentTime
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

