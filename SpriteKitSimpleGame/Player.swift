//
//  Player.swift
//  SpriteKitSimpleGame
//
//  Created by Isaac Diaz on 2/12/15.
//  Copyright (c) 2015 Isaac Diaz. All rights reserved.
//

import SpriteKit

import Foundation

class Player: SKSpriteNode {
    
    var shooting_ = false
    var lastShotTime_: CFTimeInterval = 0
    var nextPosition_ = CGPoint()
    var speed_ = Double(300.0)
    var lastUpdateTime_: CFTimeInterval = 0
    var trailEmitter_: SKEmitterNode
    var health_ = 3
    // '?' means this variable is optional; when an instance of this class is created, this variable
    // will be nil until the user selects a node. Make sure to check if nil whenever used
    
    override init() {
        
        var textures = [SKTexture]()
        
        for i in 1...26 {
            textures.append(SKTexture(imageNamed: "ship_\(i)"))
            
        }
        
        let trailEmitterPath: NSString = NSBundle.mainBundle().pathForResource("projectile_trail", ofType: "sks")!
        
        trailEmitter_ = NSKeyedUnarchiver.unarchiveObjectWithFile(trailEmitterPath) as SKEmitterNode
        
        super.init(texture: textures[0], color: UIColor.clearColor(), size: textures[0].size())
        //weapons_[0].position = CGPoint(x: 40, y: (size.height / 2))
        
        position = CGPoint(x: 30, y: 0)
        zRotation = 0
        
        lightingBitMask = 1
        

        
        trailEmitter_.position = CGPoint(x: -10, y: 0)
        
        //bot_.fillColor = SKColor.greenColor()
        
        
        

        
        let shipAnim = SKAction.animateWithTextures(textures,
            timePerFrame: 0.04)
        
        //selector_.colorBlendFactor = 1.0
        

        physicsBody = SKPhysicsBody(circleOfRadius: frame.width/2)
        physicsBody?.affectedByGravity = false
        physicsBody?.dynamic = true
        
        
        //let pos = convertPoint
        //projectile.position = self.position
        
        physicsBody?.categoryBitMask = PhysicsCategory.Player.rawValue
        
        physicsBody?.contactTestBitMask = PhysicsCategory.All.rawValue
        
        physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        /*
        bot_.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        bot_.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        bot_.physicsBody?.affectedByGravity = false
        bot_.physicsBody?.dynamic = true
        bot_.physicsBody?.linearDamping = 0.7
        
        bot_.physicsBody?.categoryBitMask = PhysicsCategory.Player.rawValue
        
        bot_.physicsBody?.contactTestBitMask = PhysicsCategory.All.rawValue
        
        bot_.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        
        addChild(bot_)

*/
        zPosition = 2
        runAction(SKAction.repeatActionForever(shipAnim))
        name = "weapon"
    
        addChild(trailEmitter_)
        //weapon.userInteractionEnabeled = false
    }
    
    /*
    func boostBot(toDestination destination: CGVector) {
        let origin = CGVector(dx: bot_.position.x, dy: bot_.position.y)
        let direction = (destination - origin)
        let force = direction.normalized()
        
        bot_.physicsBody!.velocity = direction * 3
        
        if(direction.length() < 5){
            bot_.physicsBody!.velocity = CGVector(dx: 0.0, dy: 0.0)
        }
    }
   */

    
    func processTouchAt(touchLocation: CGPoint) {
            
            /*{
            
            let currentTouch = CGVector(dx:touch.locationInNode(self).x,
                                            dy:touch.locationInNode(self).y)
            
            if currentTouch.dx < sceneSize_.width / 2{
                circles_[0].position.x = currentTouch.dx
                circles_[0].position.y = currentTouch.dy
            } else if currentTouch.dx > sceneSize_.width / 2{
                circles_[1].position.x = currentTouch.dx
                circles_[1].position.y = currentTouch.dy
            }
            
            
        }
        */
        //let scene = self.parent as SKScene
        
        nextPosition_ = touchLocation
        
        
        //println("touch location in player: \(location)")
        
        /*
        //println("selector frame \(selector_.frame)")
        if(node.name == "weapon"){
        println("node position in player: \(node.position)")
        println("node frame: \(node.frame)")
        //println("node frame: \(node.frame)")
        selectNode(node as SKSpriteNode)
        }*/
        
        shooting_ = true
        
        
        //parent!.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        shooting_ = false
    }
    
    
    func hit(){
        health_--
    }
    
    func shootProjectile() {
        
        /*
        let projectileAnim = SKAction.animateWithTextures([
        SKTexture(imageNamed: "sprite_1"),
        SKTexture(imageNamed: "sprite_2"),
        SKTexture(imageNamed: "sprite_3"),
        SKTexture(imageNamed: "sprite_4"),
        SKTexture(imageNamed: "sprite_5"),
        SKTexture(imageNamed: "sprite_6"),
        SKTexture(imageNamed: "sprite_7"),
        SKTexture(imageNamed: "sprite_8"),
        SKTexture(imageNamed: "sprite_9"),
        SKTexture(imageNamed: "sprite_10")
        ], timePerFrame: 0.04)
        
        let animate = SKAction.repeatActionForever(projectileAnim)
        */
        
        //Set up initial location of projectile
        //let projectiles = [SKSpriteNode](count: 3, repeatedValue: (SKSpriteNode)(imageNamed: "projectile_4.png"))
        
        
        /*
        let projectileAnim = SKAction.animateWithTextures([
        SKTexture(imageNamed: "projectile_1"),
        SKTexture(imageNamed: "projectile_2"),
        SKTexture(imageNamed: "projectile_3"),
        SKTexture(imageNamed: "projectile_4"),
        SKTexture(imageNamed: "projectile_5"),
        SKTexture(imageNamed: "projectile_6"),
        SKTexture(imageNamed: "projectile_7"),
        SKTexture(imageNamed: "projectile_8"),
        SKTexture(imageNamed: "projectile_9"),
        SKTexture(imageNamed: "projectile_10"),
        SKTexture(imageNamed: "projectile_11"),
        SKTexture(imageNamed: "projectile_12"),
        SKTexture(imageNamed: "projectile_13"),
        SKTexture(imageNamed: "projectile_14"),
        SKTexture(imageNamed: "projectile_15"),
        SKTexture(imageNamed: "projectile_16"),
        SKTexture(imageNamed: "projectile_17"),
        SKTexture(imageNamed: "projectile_18"),
        SKTexture(imageNamed: "projectile_19"),
        SKTexture(imageNamed: "projectile_20"),
        SKTexture(imageNamed: "projectile_21"),
        SKTexture(imageNamed: "projectile_22"),
        SKTexture(imageNamed: "projectile_23"),
        SKTexture(imageNamed: "projectile_24"),
        SKTexture(imageNamed: "projectile_25"),
        SKTexture(imageNamed: "projectile_26"),
        SKTexture(imageNamed: "projectile_27")
        ], timePerFrame: 0.04)
        */
        //projectile.runAction(animate)
        
        var i: CGFloat = 0.0
        
        for(; i < 1; i++){
            
            let projectile = SKSpriteNode(imageNamed: "projectile_4.png")
            //let direction = CGVector(dx: cos(rotation), dy: sin(rotation)).normalized()
            projectile.zPosition = 1
            
            projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width / 4)
            projectile.physicsBody?.affectedByGravity = false
            projectile.physicsBody?.dynamic = true
            
            
            projectile.position = CGPoint(x: position.x + 10, y: position.y)

            
            projectile.physicsBody?.categoryBitMask = PhysicsCategory.Bullet.rawValue
            
            projectile.physicsBody?.contactTestBitMask = PhysicsCategory.All.rawValue
            
            projectile.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
            projectile.zRotation = 0
            
            
            /*
            let light = SKLightNode()
            light.enabled = true
            light.lightColor = SKColor(hue: 0.81 , saturation: 0.8, brightness: 1.0, alpha: 0.6)
            light.falloff = 1.0
            
            light.ambientColor = SKColor(hue: 0.0 , saturation: 0.4, brightness: 1.0, alpha: 0.4)
            light.position = projectile.position
            projectile.addChild(light)
            */
            
            // 5 - OK to add now - you've double checked position
            
            
            let trailPath: NSString = NSBundle.mainBundle().pathForResource("projectile_trail", ofType: "sks")!
            let trailEmitter = NSKeyedUnarchiver.unarchiveObjectWithFile(trailPath) as SKEmitterNode
            trailEmitter.position = CGPoint(x: projectile.size.width / 2, y: 0)
            trailEmitter.zPosition = 2
            trailEmitter.targetNode = self
            trailEmitter.emissionAngle = projectile.zRotation
            //projectile.addChild(trailEmitter)
            
            
            let actionMoveDone = SKAction.removeFromParent()
            //projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
            
            projectile.physicsBody?.velocity = CGVector(dx: 1000, dy: 0)
            
            parent?.addChild(projectile)
            //let circleAction = SKAction.waitForDuration(1)
            //circle.runAction(SKAction.sequence([circleAction, actionMoveDone]))
            
            
            projectile.runAction(SKAction.sequence([SKAction.waitForDuration(2), SKAction.removeFromParent()]))
        }
    }
    
    func update(currentTime: NSTimeInterval) {
        
        
        /*
        if(currentTouch_ != nil){
            boostBot(toDestination: currentTouch_!)
        }*/
        
        let shotDelta = currentTime - lastShotTime_
        
        let timeDelta = currentTime - lastUpdateTime_
        let direction: CGFloat = nextPosition_.y < position.y ? -1: 1
        
        let distToPoint = abs(nextPosition_.y - position.y)
        
        let distToTravel = CGFloat(speed_ * timeDelta)
        
        if(direction > 0){
            trailEmitter_.emissionAngle = (5 * π)/4
        }else{
            trailEmitter_.emissionAngle = (3 * π)/4
        }
        
        if(distToPoint < distToTravel){
            position.y = nextPosition_.y
            trailEmitter_.emissionAngle = π
        }else{
            position.y += (distToTravel * direction)
        }
        
        if(shooting_ == true){
            
            var i = 0
            
            if(shotDelta > 0.25){
                lastShotTime_ = currentTime
                
                shootProjectile()
            }
        }
        
        lastUpdateTime_ = currentTime
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}