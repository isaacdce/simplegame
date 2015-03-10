//
//  GameOverScene.swift
//  SpriteKitSimpleGame
//
//  Created by Isaac Diaz on 3/8/15.
//  Copyright (c) 2015 Isaac Diaz. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene{

    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.blackColor()
        let gameOverText = SKLabelNode(text: "Game Over")
        gameOverText.fontSize = 50
        gameOverText.fontColor = SKColor.whiteColor()
        gameOverText.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        addChild(gameOverText)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let gameScene = GameScene(size: self.size)
        view?.presentScene(gameScene)
    }
}
