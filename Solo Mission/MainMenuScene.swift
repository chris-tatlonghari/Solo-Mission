//
//  MainMenuScene.swift
//  Solo Mission
//
//  Created by Christopher Tatlonghari on 11/18/22.
//

import Foundation
import SpriteKit

class MainMenuScene : SKScene {
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        let name = SKLabelNode(fontNamed: "The Bold Font")
        name.text = "Three Kings Dev's"
        name.fontSize = 50
        name.fontColor = SKColor.white
        name.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.65)
        name.zPosition = 1
        self.addChild(name)
        
        let gameName1 = SKLabelNode(fontNamed: "The Bold Font")
        gameName1.text = "Solo"
        gameName1.fontSize = 150
        gameName1.fontColor = SKColor.white
        gameName1.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.575)
        gameName1.zPosition = 1
        self.addChild(gameName1)
        
        let gameName2 = SKLabelNode(fontNamed: "The Bold Font")
        gameName2.text = "Mission"
        gameName2.fontSize = 150
        gameName2.fontColor = SKColor.white
        gameName2.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.5)
        gameName2.zPosition = 1
        self.addChild(gameName2)
        
        let startGame = SKLabelNode(fontNamed: "The Bold Font")
        startGame.text = "Start Game"
        startGame.fontSize = 150
        startGame.fontColor = SKColor.white
        startGame.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.35)
        startGame.zPosition = 1
        startGame.name = "startButton"
        self.addChild(startGame)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            
            let nodeTapped = atPoint(pointOfTouch)
            
            if nodeTapped.name == "startButton" {
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let transition = SKTransition.crossFade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: transition)
            }
            
        }
    }
}
