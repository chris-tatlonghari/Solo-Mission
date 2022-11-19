//
//  GameScene.swift
//  Solo Mission
//
//  Created by Christopher Tatlonghari on 11/16/22.
//

import SpriteKit
import GameplayKit

var gameScore = 0

let streak1Sound = SKAction.playSoundFileNamed("streak1.wav", waitForCompletion: false)

let streak2Sound = SKAction.playSoundFileNamed("streak2.wav", waitForCompletion: false)

let streak3Sound = SKAction.playSoundFileNamed("streak3.wav", waitForCompletion: false)

let streak4Sound = SKAction.playSoundFileNamed("streak4.wav", waitForCompletion: false)

let streak5Sound = SKAction.playSoundFileNamed("streak5.wav", waitForCompletion: false)

let streak6Sound = SKAction.playSoundFileNamed("streak6.wav", waitForCompletion: false)

let streak7Sound = SKAction.playSoundFileNamed("streak7.wav", waitForCompletion: false)

let streak8Sound = SKAction.playSoundFileNamed("streak8.wav", waitForCompletion: false)

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    var livesNumber = 3
    let livesLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    var levelNumber = 0
    
    // Global declaration so that other methods may access player.position for example.
    let player = SKSpriteNode(imageNamed: "playerShip")
    
    // Create bullet & explosion sound
    let bulletSound = SKAction.playSoundFileNamed("bulletSoundEffect.wav", waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed("explosionSoundEffect.wav", waitForCompletion: false)
    
    var soundToPlay = streak1Sound
    
    // Create pre game start label
    let tapToStartLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    // Game states for controlling main menu, gameplay, etc.
    enum gameState {
        case preGame
        case inGame
        case postGame
    }
    
    var currentGameState = gameState.preGame
    
    // Set physics categories
    struct PhysicsCategories {
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1
        static let Bullet : UInt32 = 0b10
        static let Enemy : UInt32 = 0b100
    }
    
    // Methods for generating random numbers
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 4294967296)
    }
    func random(min:CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    
    
    // Set up game area
    var gameArea: CGRect
    
    override init(size: CGSize) {
        
        let maxAspectRatio: CGFloat = 19.5/9.0 // iPhone 14 aspect ratio
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMove(to view: SKView) {
        
        // Reset score
        gameScore = 0
        
        // Initialize collision detection
        self.physicsWorld.contactDelegate = self
        
        
        for i in 0...1 {

            let background = SKSpriteNode(imageNamed: "background")
            background.size = self.size
            background.anchorPoint = CGPoint(x: 0.5, y: 0)
            background.position = CGPoint(x: self.size.width / 2,
                                          y: self.size.height * CGFloat(i)) // Center of screen
            background.name = "Background"
            background.zPosition = 0
            self.addChild(background)

        }
        
//        let background = SKSpriteNode(imageNamed: "backgroundAlt")
//        background.size = self.size
//        background.anchorPoint = CGPoint(x: 0.5, y: 0)
//        background.position = CGPoint(x: self.size.width / 2,
//                                      y: self.size.height * CGFloat(0)) // Center of screen
//        background.name = "Background"
//        background.zPosition = 0
//        self.addChild(background)
//
//        let background2 = SKSpriteNode(imageNamed: "backgroundAlt2")
//        background2.size = self.size
//        background2.anchorPoint = CGPoint(x: 0.5, y: 0)
//        background2.position = CGPoint(x: self.size.width / 2,
//                                      y: self.size.height * CGFloat(1)) // Center of screen
//        background2.name = "Background"
//        background2.zPosition = 0
//        self.addChild(background2)
        
        player.setScale(1) // Normal size
        player.position = CGPoint(x: self.size.width / 2, y: 0 - player.size.height)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size) // Set physics body
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(player)
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: 0.25 * self.size.width, y: self.size.height + scoreLabel.frame.size.height)
        scoreLabel.zPosition = 100 // Very top
        self.addChild(scoreLabel)
        
        livesLabel.text = "Lives: 3"
        livesLabel.fontSize = 70
        livesLabel.fontColor = SKColor.white
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        livesLabel.position = CGPoint(x: 0.75 * self.size.width, y: self.size.height + livesLabel.frame.size.height)
        livesLabel.zPosition = 100 // Very top
        self.addChild(livesLabel)
        
        let moveOntoScreen = SKAction.moveTo(y: self.size.height * 0.9, duration: 0.3)
        scoreLabel.run(moveOntoScreen)
        livesLabel.run(moveOntoScreen)
        
        tapToStartLabel.text = "Tap to Begin"
        tapToStartLabel.fontSize = 75
        tapToStartLabel.fontColor = SKColor.white
        tapToStartLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        tapToStartLabel.zPosition = 1
        tapToStartLabel.alpha = 0
        self.addChild(tapToStartLabel)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.3)
        tapToStartLabel.run(fadeInAction)
        
        
        
    }
    
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    var amountToMovePerSecond: CGFloat = 500.0
    
    override func update(_ currentTime: TimeInterval) {
        // This method is part of the game loop and will run for every frame
        
        if (lastUpdateTime == 0) {
            lastUpdateTime = currentTime
        }
        else {
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        
        let amountToMoveBackGround = amountToMovePerSecond * CGFloat(deltaFrameTime)
        
        self.enumerateChildNodes(withName: "Background") {
            background, stop in
            
            if self.currentGameState == gameState.inGame {
                background.position.y -= amountToMoveBackGround
            }
            
            if background.position.y < -self.size.height {
                background.position.y += 2 * self.size.height
            }
        }
    }
    
    func startGame() {
        
        currentGameState = gameState.inGame
        
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let deleteAction = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([fadeOutAction, deleteAction])
        
        tapToStartLabel.run(deleteSequence)
        
        let moveShipOntoScreenAction = SKAction.moveTo(y: self.size.height * 0.2, duration: 0.5)
        let startLevelAction = SKAction.run(startNewLevel)
        let startSequence = SKAction.sequence([moveShipOntoScreenAction, startLevelAction])
        
        player.run(startSequence)
        
    }
    
    func addScore() {
        
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        
        if gameScore == 10 || gameScore == 25 || gameScore == 50 {
            startNewLevel()
            amountToMovePerSecond += 200
        }
    }
    
    var streak = 0
    
    func loseALife() {
        
        livesNumber -= 1
        livesLabel.text = "Lives: \(livesNumber)"
        streak = 0
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        livesLabel.run(scaleSequence)
        
        if livesNumber == 0 {
            runGameOver()
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
            
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy {
            // Player and enemy made contact
            
            if (body1.node != nil) {
                // Notice the !. is a force unwrap meaning we require the node to be there to use parameter and thus to use function.
                spawnExplosion(spawnPosition: body1.node!.position, sound: explosionSound)
            }
            
            if (body2.node != nil) {
                spawnExplosion(spawnPosition: body2.node!.position, sound: explosionSound)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            runGameOver()
        }
        
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy {
            // Bullet and enemy made contact

            if body2.node != nil {
                if body2.node!.position.y > self.size.height {
                    // if the out of frame, do nothing
                    return
                }
                else {
                    
                    // Get sound to play
                    soundToPlay = getSoundToPlay()
                    
                    if (body2.node != nil) {
                        spawnExplosion(spawnPosition: body2.node!.position, sound: soundToPlay)
                        
                        streak += 1
                    }
                    
                    body1.node?.removeFromParent()
                    body2.node?.removeFromParent()
                    
                    addScore()
                }
            }
        }
    }
    
    func getSoundToPlay() -> SKAction {
        
        switch streak {
            case 0: return streak1Sound
            case 1: return streak2Sound
            case 2: return streak3Sound
            case 3: return streak4Sound
            case 4: return streak5Sound
            case 5: return streak6Sound
            case 6: return streak7Sound
            default: return streak8Sound
        }
    }
    
    func spawnExplosion(spawnPosition: CGPoint, sound: SKAction) {
        
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3 // Top layer
        explosion.setScale(0)
        self.addChild(explosion)
        
        // Explosion animation with SKActions
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        let explosionSequence = SKAction.sequence([sound, scaleIn, fadeOut, delete])
        explosion.run(explosionSequence)
        
    }
    
    
    func startNewLevel() {
    
        levelNumber += 1
        
        if self.action(forKey: "spawningEnemies") != nil {
            self.removeAction(forKey: "spawningEnemies")
        }
        
        var levelDuration = TimeInterval()
        
        switch levelNumber {
        case 1: levelDuration = 1.2
        case 2: levelDuration = 1.0
        case 3: levelDuration = 0.8
        case 4: levelDuration = 0.5
        default:
            levelDuration = 0.5
            print("Level does not exist.")
            
        }
        
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawningEnemies")
        
    }
    
    func fireBullet() {
        
        // Create bullet
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.name = "Bullet"
        bullet.setScale(1)
        bullet.position = player.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size) // Set physics body
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(bullet)
        
        // Shoot bullet
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])
        bullet.run(bulletSequence)
        
    }
    
    func spawnEnemy() {
        
        // Generate random x coordinates for enemy start and end
        let randomXStart = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        let randomXEnd = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        // Create enemy
        let enemy = SKSpriteNode(imageNamed: "enemyShip")
        enemy.name = "Enemy"
        enemy.setScale(1)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size) // Set physics body
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        self.addChild(enemy)
        
        // Create sequence and run
        let moveEnemy = SKAction.move(to: endPoint, duration: 1.5)
        let deleteEnemy = SKAction.removeFromParent()
        let loseALifeAction = SKAction.run(loseALife)
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy, loseALifeAction])
        
        if currentGameState == gameState.inGame {
            enemy.run(enemySequence)
        }
        
        // Handle title of enemy according to direction
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy, dx)
        enemy.zRotation = amountToRotate
        
        
    }
    
    func runGameOver() {
        
        currentGameState = gameState.postGame
        
        // Freeze the game for 1 second
        self.removeAllActions()
        
        self.enumerateChildNodes(withName: "Bullet"){
            bullet, stop in
            
            bullet.removeAllActions()
        }
        
        self.enumerateChildNodes(withName: "Enemy"){
            enemy, stop in
            
            enemy.removeAllActions()
        }
        
        // Change scene to game over screen
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.run(changeSceneSequence)
        
    }
    
    func changeScene() {
        
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        
        let transition = SKTransition.crossFade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: transition)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if currentGameState == gameState.preGame {
            startGame()
        }
        else if currentGameState == gameState.inGame {
            fireBullet()
        }
        
    
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.location(in: self)
            let prevPointOfTouch = touch.previousLocation(in: self)
            
            let amountDraggedX = pointOfTouch.x - prevPointOfTouch.x
            let amountDraggedY = pointOfTouch.y - prevPointOfTouch.y
            
            if currentGameState == gameState.inGame {
                player.position.x += amountDraggedX
                player.position.y += amountDraggedY
            }
            
            // If we move out of gameArea move back in
            if player.position.x > CGRectGetMaxX(gameArea) - player.size.width/2 {
                player.position.x = CGRectGetMaxX(gameArea) - player.size.width/2
            }
            if player.position.x < CGRectGetMinX(gameArea) + player.size.width/2 {
                player.position.x = CGRectGetMinX(gameArea) + player.size.width/2
            }
            
            
            
        }
        
    }
}
