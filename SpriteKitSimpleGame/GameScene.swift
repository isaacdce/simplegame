//
//  Player.swift
//  SpriteKitSimpleGame
//
//  Created by Isaac Diaz on 2/12/15.
//  Copyright (c) 2015 Isaac Diaz. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //let delegate = SKPhysics
   // self.physicsWorld.contactDelegate =
    // 1
    var gameEnding = false
    var player: Player
    let enemySpawner = EnemySpawner()
    var shooting = false
    var touchLocation = CGPoint()
    var direction = CGVector(dx: 0, dy: 0)
    let circle = SKShapeNode(circleOfRadius: 50)
    var lastShotTime: CFTimeInterval = 0
    var spawnStartTimer: CFTimeInterval = 0
    var redFlashTimer: CFTimeInterval = 0
    var flashStart = false

  //  let player = SKShapeNode(points: <#UnsafeMutablePointer<CGPoint>#>, count: <#UInt#>)
    
    override init(size: CGSize){
       
        
        player = Player()
        super.init(size: size)
        circle.fillColor = SKColor.blueColor()
        circle.hidden = true
        addChild(circle)
        addChild(player)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody?.categoryBitMask = PhysicsCategory.Frame.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.All.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        
        // 2b
        backgroundColor = SKColor.blackColor()
        
        let starEmitterPath: NSString = NSBundle.mainBundle().pathForResource("Stars", ofType: "sks")!
    
        let starEmitter = NSKeyedUnarchiver.unarchiveObjectWithFile(starEmitterPath) as SKEmitterNode
        
        starEmitter.position = CGPointMake(self.frame.size.width, self.frame.size.height/2)
        starEmitter.name = "starEmitter"
        starEmitter.zPosition = 0
        starEmitter.targetNode = self
        starEmitter.advanceSimulationTime(5)
        starEmitter.name = "starEmitter"
        self.addChild(starEmitter)
        
        self.addChild(enemySpawner)
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if(firstBody.node == nil || secondBody.node == nil){
            return
        }
        
        if(firstBody.categoryBitMask & PhysicsCategory.Enemy.rawValue != 0
            && secondBody.categoryBitMask & PhysicsCategory.Bullet.rawValue != 0){
                
            let explosionPath: NSString = NSBundle.mainBundle().pathForResource("Explosion", ofType: "sks")!
            let exEmitter = NSKeyedUnarchiver.unarchiveObjectWithFile(explosionPath) as SKEmitterNode
                
            // Not sure why this is necessary. It seems that contacts are being detected between nodes that have been
            // deleted. Might be a result of multithreading. LOL IDUNNO
                
            let bulletNode = secondBody.node as SKSpriteNode
            
            let enemyNode = firstBody.node as Enemy
            exEmitter.position = CGPoint(x: bulletNode.position.x - 10, y: bulletNode.position.y)
            exEmitter.zPosition = 2
            
            enemyNode.hit()
                
            self.addChild(exEmitter)
            
            bulletNode.removeFromParent()
            exEmitter.runAction(SKAction.sequence([SKAction.waitForDuration(1), SKAction.removeFromParent()]))
            
        }
        else if(firstBody.categoryBitMask & PhysicsCategory.Enemy.rawValue != 0
            && secondBody.categoryBitMask & PhysicsCategory.Player.rawValue != 0){
                let enemyNode = firstBody.node as Enemy
                let playerNode = secondBody.node as Player
                flashStart = true
                enemyNode.health_ = 1
                enemyNode.hit()
                playerNode.hit()
        }
        
    }

        
    override func update(currentTime: NSTimeInterval) {
        
        if(spawnStartTimer == 0){
            spawnStartTimer = currentTime
        }
        
        if(currentTime - spawnStartTimer > 3 && enemySpawner.spawning_ == false){
            enemySpawner.startSpawning()
        }
        
        if(flashStart == true){
            flashStart = false
            redFlashTimer = currentTime
            backgroundColor = SKColor.redColor()
        }else if(redFlashTimer != 0 && currentTime - redFlashTimer > 0.1){
            backgroundColor = SKColor.blackColor()
            redFlashTimer = 0
        }
        self.enumerateChildNodesWithName("enemy", usingBlock: {(node: SKNode!, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            
            (node as Enemy).update(currentTime)
        })
        
        enemySpawner.update(currentTime)
       player.update(currentTime)
        if(player.health_ <= 0 && gameEnding == false){
            for child in self.children{
                child.removeFromParent()
            }
            gameEnding = true
            let gameOver = GameOverScene(size: self.size)
            view?.presentScene(gameOver)
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        //let scene = self.parent as SKScene
        let touch = touches.anyObject() as UITouch
        let location = touch.locationInNode(self)
        
        
        player.processTouchAt(location)
        circle.hidden = false
        circle.position = location
        //shooting_ = true
        //updateDirectionFromSelected(toPoint: location)
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        self.touchesBegan(touches, withEvent: event)
        //player.handleTouch(touch)
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        circle.hidden = true
    }
    
    

}

