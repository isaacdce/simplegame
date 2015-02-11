import SpriteKit

//import Darwin

enum PhysicsCategory : UInt32{
    case All = 0xffffffff
    case None = 0
    case Frame = 0b1
    case Enemy = 0b10
    case Bullet = 0b100
}

let π = CGFloat(M_PI)

func + (left: CGVector, right: CGVector) -> CGVector {
    return CGVector(dx: left.dx + right.dx, dy: left.dy + right.dy)
}

func - (left: CGVector, right: CGVector) -> CGVector {
    return CGVector(dx: left.dx - right.dx, dy: left.dy - right.dy)
}

func * (point: CGVector, scalar: CGFloat) -> CGVector {
    return CGVector(dx: point.dx * scalar, dy: point.dy * scalar)
}

func / (point: CGVector, scalar: CGFloat) -> CGVector {
    return CGVector(dx: point.dx / scalar, dy: point.dy / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGVector) -> CGVEctor {
    return CGVector(sqrtf(Float(a)))
    }
#endif

extension CGVector {
    func length() -> CGFloat {
        return sqrt(dx * dx + dy * dy)
    }
    
    func normalized() -> CGVector {
        return self / length()
    }
}

class Player: SKNode{
    var weapons_ = [SKSpriteNode(imageNamed: "ship_1.png"), SKSpriteNode(imageNamed: "ship_1.png")]
    var shooting_ = false
    var direction_ = CGVector(dx: 0.0, dy: 0.0)
    var lastShotTime_: CFTimeInterval = 0
    var selector_ = SKSpriteNode(imageNamed: "selector_1.png")
    
    // '?' means this variable is optional; when an instance of this class is created, this variable
    // will be nil until the user selects a node. Make sure to check if nil whenever used
    var selected_: SKSpriteNode?
    
    
    init(size: CGSize){
        
        weapons_[0].position = CGPoint(x: 40, y: (size.height / 2))
        weapons_[1].position = CGPoint(x: 40, y: (size.height - 40))
        weapons_.append(SKSpriteNode(imageNamed: "ship_1.png"))
        weapons_[2].position = CGPoint(x: 40, y: 40)
        
        
        
        let shipAnim = SKAction.animateWithTextures([
            SKTexture(imageNamed: "ship_1"),
            SKTexture(imageNamed: "ship_2"),
            SKTexture(imageNamed: "ship_3"),
            SKTexture(imageNamed: "ship_4"),
            SKTexture(imageNamed: "ship_5"),
            SKTexture(imageNamed: "ship_6"),
            SKTexture(imageNamed: "ship_7"),
            SKTexture(imageNamed: "ship_8"),
            SKTexture(imageNamed: "ship_9"),
            SKTexture(imageNamed: "ship_10"),
            SKTexture(imageNamed: "ship_11"),
            SKTexture(imageNamed: "ship_12"),
            SKTexture(imageNamed: "ship_13"),
            SKTexture(imageNamed: "ship_14"),
            SKTexture(imageNamed: "ship_15"),
            SKTexture(imageNamed: "ship_16"),
            SKTexture(imageNamed: "ship_17"),
            SKTexture(imageNamed: "ship_18"),
            SKTexture(imageNamed: "ship_19"),
            SKTexture(imageNamed: "ship_20"),
            SKTexture(imageNamed: "ship_21"),
            SKTexture(imageNamed: "ship_22"),
            SKTexture(imageNamed: "ship_23"),
            SKTexture(imageNamed: "ship_24"),
            SKTexture(imageNamed: "ship_25"),
            SKTexture(imageNamed: "ship_26")
            
            ], timePerFrame: 0.04)
        
        let selectorAnim = SKAction.animateWithTextures([
            SKTexture(imageNamed: "selector_1"),
            SKTexture(imageNamed: "selector_2"),
            SKTexture(imageNamed: "selector_3"),
            SKTexture(imageNamed: "selector_4"),
            SKTexture(imageNamed: "selector_5"),
            SKTexture(imageNamed: "selector_6")
        ], timePerFrame: 0.11)
        
        selector_.runAction(SKAction.repeatActionForever(selectorAnim))
        selector_.hidden = true
        super.init()
        
        self.userInteractionEnabled = true
        position = CGPoint(x: 0, y: 0)
        
        addChild(selector_)
        for weapon in weapons_{
            weapon.zPosition = 2
            weapon.runAction(SKAction.repeatActionForever(shipAnim))
            weapon.name = "weapon"
            
            println("weapon frame: \(weapon.frame)")
            //weapon.userInteractionEnabeled = false
            addChild(weapon)
        }
        
        
    }
   
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        //let scene = self.parent as SKScene
        let touch = touches.anyObject() as UITouch
        let location = touch.locationInNode(self)
        //let node = nodeAtPoint(location)
        
        for weapon in weapons_{
            
            
            let origin = CGVector(dx: weapon.position.x, dy: weapon.position.y)
            let destination = CGVector(dx: location.x, dy: location.y)
            
            let distance = (destination - origin).length()
            
            if(distance < weapon.size.width / 2){
                selectNode(weapon as SKSpriteNode)
                return
            }
        }
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
        updateDirectionFromSelected(toPoint: location)
        parent!.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        self.touchesBegan(touches, withEvent: event)
        parent!.touchesBegan(touches, withEvent: event)
    }
    
    func selectNode(node: SKSpriteNode){
        if(selector_.hidden == true){
            selector_.hidden = false
            selector_.position = node.position
        }
        
        //if user is selecting a different node, animate selector to node
        if(selected_ != node){
            selected_ = node
            selector_.runAction(SKAction.moveTo(selected_!.position, duration: 0.08))
            
            
        }
        
    }
    
    
    func updateDirectionFromSelected(toPoint point: CGPoint){
        if(selected_ != nil){
            let destination = CGVector(dx: point.x, dy: point.y)
            let origin = CGVector(dx: selected_!.position.x, dy: selected_!.position.y)
            
            let offset = destination - origin
            let direction = offset.normalized()
            var nodeRotation = atan(direction.dy/direction.dx)
            
            if(direction.dx < 0){
                nodeRotation += 135
            }
            selected_!.zRotation = nodeRotation
        }
    }
    
    
    func shootProjectile(fromNode weapon: SKSpriteNode){
        
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
        let projectile = SKSpriteNode(imageNamed: "projectile_4.png")
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
        //projectile.runAction(projectileAnim)
        
        let direction = CGVector(dx: cos(weapon.zRotation), dy: sin(weapon.zRotation)).normalized()
        projectile.zPosition = 1
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width / 4)
        projectile.physicsBody?.affectedByGravity = false
        projectile.physicsBody?.dynamic = true
        
        
        let projectile_position = CGVector(dx: weapon.position.x, dy: weapon.position.y) + direction * 10
        projectile.position.x = projectile_position.dx
        projectile.position.y = projectile_position.dy
        
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Bullet.rawValue
        
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.All.rawValue
        
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        projectile.zRotation = weapon.zRotation
        
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
        
        projectile.physicsBody?.velocity = direction * 2500
        addChild(projectile)
        //let circleAction = SKAction.waitForDuration(1)
        //circle.runAction(SKAction.sequence([circleAction, actionMoveDone]))
        
        
        projectile.runAction(SKAction.sequence([SKAction.waitForDuration(1), SKAction.removeFromParent()]))
    }

    func update(currentTime: NSTimeInterval) {
        let timeDelta = currentTime - lastShotTime_
        
        if(timeDelta > 0.5){
            lastShotTime_ = currentTime
            
            for weapon in weapons_{
                shootProjectile(fromNode: weapon)
            }
        }
        
        for weapon in weapons_ {
        println("weapon frame 2: \(weapon.frame)")
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {

 
    
    //let delegate = SKPhysics
   // self.physicsWorld.contactDelegate =
    // 1
    
    var player: Player
    var shooting = false
    var touchLocation = CGPoint()
    var direction = CGVector(dx: 0, dy: 0)
    var lastShotTime: CFTimeInterval = 0
  //  let player = SKShapeNode(points: <#UnsafeMutablePointer<CGPoint>#>, count: <#UInt#>)
    
    override init(size: CGSize){
        player = Player(size: size)
        super.init(size: size)
        player.position = self.position
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
        // 3
        
        
        /* This adds a circle around the player (possible power-up sort of thing)
        let circle = SKShapeNode(circleOfRadius: 15)
        circle.strokeColor = SKColor.redColor()
        circle.fillColor = SKColor(red: 1.0, green: 0.0, blue: 0.6, alpha: 0.5)
        circle.position = player.position
        circle.lineWidth = 1.2
        circle.glowWidth = 1.5
        addChild(circle)
        */
        //let monster = SKSpriteNode(imageNamed: "mine_1.png")
        
        
        //star particle effect
        
        let starEmitterPath: NSString = NSBundle.mainBundle().pathForResource("Stars", ofType: "sks")!
    
        let starEmitter = NSKeyedUnarchiver.unarchiveObjectWithFile(starEmitterPath) as SKEmitterNode
        
        starEmitter.position = CGPointMake(self.frame.size.width, self.frame.size.height/2)
        starEmitter.name = "starEmitter"
        starEmitter.zPosition = 0
        starEmitter.targetNode = self
        starEmitter.advanceSimulationTime(5)
        starEmitter.name = "starEmitter"
        self.addChild(starEmitter)
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addMonster),
                SKAction.waitForDuration(1.0)
                ])
            ))

        
    }
    
    func didBeginContact(contact: SKPhysicsContact){
        

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
        
        if(firstBody.categoryBitMask & PhysicsCategory.Enemy.rawValue != 0
            && secondBody.categoryBitMask & PhysicsCategory.Bullet.rawValue != 0){
                
            let explosionPath: NSString = NSBundle.mainBundle().pathForResource("Explosion", ofType: "sks")!
            let exEmitter = NSKeyedUnarchiver.unarchiveObjectWithFile(explosionPath) as SKEmitterNode
                
            let bulletnode = secondBody.node as SKSpriteNode
            
            
            if(firstBody.node == nil){
                return
            }
            
            let enemyNode = firstBody.node as SKSpriteNode
            exEmitter.position = CGPoint(x: enemyNode.position.x - 20, y: enemyNode.position.y)
                
            enemyNode.removeFromParent()
                
            self.addChild(exEmitter)
            
            exEmitter.runAction(SKAction.sequence([SKAction.waitForDuration(1), SKAction.removeFromParent()]))
            
        }
}

    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(#min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    
    func addMonster() {
        
        
        // Determine where to spawn the monster along the Y axis
        let actualY = random(min: 9, max: size.height - 9)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        var position = CGPoint(x: size.width + 5, y: actualY)
        
        var circle = CGPathCreateMutable()
        CGPathAddArc(circle, nil, position.x, position.y, 18, 0.0, 2 * CGFloat(π), true)
        
        // Create sprite
        let monster = SKSpriteNode(imageNamed: "mine_1.png")
        
        let enemyAnim = SKAction.animateWithTextures([
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
        
        monster.runAction(SKAction.repeatActionForever(enemyAnim))
        
        monster.position = position
        monster.zPosition = 1
        
        monster.physicsBody = SKPhysicsBody(circleOfRadius: monster.size.width / 4)
        monster.physicsBody?.affectedByGravity = false
        monster.physicsBody?.dynamic = true
        
        var velocity = random(min: -300.0, max: -100.0)
        monster.physicsBody?.velocity = CGVectorMake(velocity, 0)
        
        monster.physicsBody?.categoryBitMask = PhysicsCategory.Enemy.rawValue
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.All.rawValue
        monster.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
        
        addChild(monster)
        
        
        //Calculate random rotation speed and create rotating action
        let rotateDuration = random(min: CGFloat(0.5), max: CGFloat(5.0))
        
        //Determine if rotating clockwise or counter-clockwise and create action
        let radians = (rotateDuration > 3.0) ? -1 * 2 * π : 1 * 2 * π
        let actionRotate = SKAction.repeatActionForever(SKAction.rotateByAngle( radians, duration: NSTimeInterval(rotateDuration * 2)))
        
        //Enemy will rotate at a random speed across the screen and be removed after 10 secs
        monster.runAction(SKAction.group([actionRotate, SKAction.sequence([SKAction.waitForDuration(10), SKAction.removeFromParent()])]))
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        player.update(currentTime)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        //let scene = self.parent as SKScene
        let touch = touches.anyObject() as UITouch
        let location = touch.locationInNode(self)
        let node = nodeAtPoint(location)
        println("touch location in scene: \(location)")
        println("scene frame \(self.frame)")
        if(node.name == "weapon"){
            println("node position in scene: \(node.position)")
            //println("node frame: \(node.frame)")
            //selectNode(node as SKSpriteNode)
        }
        
        //shooting_ = true
        //updateDirectionFromSelected(toPoint: location)
    }
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let location = touch.locationInNode(self)
        //player.handleTouch(touch)
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
    }
    
    

}

