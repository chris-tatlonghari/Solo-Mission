//
//  GameOverScene.swift
//  Solo Mission
//
//  Created by Christopher Tatlonghari on 11/17/22.
//

import Foundation
import SpriteKit

class GameOverScene : SKScene {
    
    let restartLabel = SKLabelNode(fontNamed: "The Bold Font")
    let mainMenuLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    override func didMove(to view: SKView) {
        
        // Set Background
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let gameOverLabel = SKLabelNode(fontNamed: "The Bold Font")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 125
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.7)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        scoreLabel.text = "Score: \(gameScore)"
        scoreLabel.fontSize = 100
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.55)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        let defaults = UserDefaults()
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        if gameScore > highScoreNumber {
            highScoreNumber = gameScore
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
        }
        
        let highScoreLabel = SKLabelNode(fontNamed: "The Bold Font")
        highScoreLabel.text = "High Score: \(highScoreNumber)"
        highScoreLabel.fontSize = 100
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.45)
        highScoreLabel.zPosition = 1
        self.addChild(highScoreLabel)
        
        restartLabel.text = "Tap to Restart"
        restartLabel.fontSize = 75
        restartLabel.fontColor = SKColor.white
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.30)
        restartLabel.zPosition = 1
        self.addChild(restartLabel)
        
        mainMenuLabel.text = "Exit to Main Menu"
        mainMenuLabel.fontSize = 75
        mainMenuLabel.fontColor = SKColor.white
        mainMenuLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.20)
        mainMenuLabel.zPosition = 1
        self.addChild(mainMenuLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            
            if restartLabel.contains(pointOfTouch) {
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let transition = SKTransition.crossFade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: transition)
            }
            
            if mainMenuLabel.contains(pointOfTouch) {
                let sceneToMoveTo = MainMenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let transition = SKTransition.crossFade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: transition)
            }
            
        }
    }
}
