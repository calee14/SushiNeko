//
//  GameScene.swift
//  SushiNeko
//
//  Created by Cappillen on 3/31/17.
//  Copyright © 2017 Cappillen. All rights reserved.
//

import SpriteKit

//Tracking enum for use with character and sushi side
enum Side {
    case Left, Right, None
}

//Tracking enum for game state
enum GameState {
    case Title, Ready, Playing, GameOver
}

class GameScene: SKScene {
    
    //Game objects
    var sushiBasePiece: SushiPiece!
    var character: Character!
    
    //Sushi tower array
    var sushiTower: [SushiPiece] = []
    
    //Game management
    var state: GameState = .Title
    
    //UI GameObjects
    var playButton: MSButtonNode!
    var healthBar: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    //health
    var health: CGFloat = 1.0 {
        didSet {
            //Scale health bar between 0.0 -> 1.0 e.g -> 100%
            healthBar.xScale = health
            
            //Cap Health
            if health > 1.0 { health = 1.0 }
            
        }
    }
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = String(score)
        }
    }
    override func didMove(to view: SKView) {
        //Setup your scene here
        
        //Connect game objects
        sushiBasePiece = childNode(withName: "sushiBasePiece") as! SushiPiece
        character = childNode(withName: "character") as! Character
        
        //UI game objects
        playButton = childNode(withName: "playButton") as! MSButtonNode
        healthBar = childNode(withName: "healthBar") as! SKSpriteNode
        scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode
        
        //Setup play button selection handler
        playButton.selectedHandler = {
            
            //Start game
            self.state = .Ready
        }
        //Setup chopstick connections
        sushiBasePiece.connectChopsticks()
        
        //Manually stack the start of the tower
        addTowerPiece(side: .None)
        addTowerPiece(side: .Right)
        
        //Randomize tower to just outside of the screen
        addRandomPieces(total: 10)
    }
    
    func addTowerPiece(side: Side) {
        //Add a new sushi piece to the sushi tower
        
        //Copy original sushi piece
        let newPiece = sushiBasePiece.copy() as! SushiPiece
        newPiece.connectChopsticks()
        
        //Access last piece properties
        let lastPiece = sushiTower.last
        
        //Add on top of last piece, default on first piece
        let lastPosition = lastPiece?.position ?? sushiBasePiece.position
        newPiece.position = lastPosition + CGPoint(x: 0, y: 55)
        
        //Increment Z to ensure it's on top of the last piece, default on first piece
        let lastZPosition = lastPiece?.zPosition ?? sushiBasePiece.zPosition
        newPiece.zPosition = lastZPosition + 1
        
        //Set side
        newPiece.side = side
        
        //Add sushi to scene
        addChild(newPiece)
        
        //Add sushiPiece to the sushi tower
        sushiTower.append(newPiece)
    }
    
    func addRandomPieces(total: Int) {
        //Add random sushi pieces to the sushi tower
        
        for _ in 1...total {
            
            //Need to acess last piece properties 
            let lastPiece = sushiTower.last as SushiPiece!
            
            //Need to ensure we don't create impossible sushi sturctures
            if lastPiece!.side != .None {
                addTowerPiece(side: .None)
            } else {
                
                //Random Number Generator
                let rand = CGFloat.random(min: 0, max: 1.0)
                
                if rand < 0.45 {
                    //45% chance of a left peice
                    addTowerPiece(side: .Left)
                } else if rand < 0.9 {
                    //45% chance of a right piece
                    addTowerPiece(side: .Right)
                } else {
                    //10% chance of an empty piece 
                    addTowerPiece(side: .None)
                }
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Called when touch begins
        
        //Game not ready to play
        if state == .GameOver || state == .Title { return }
        
        //Game begins on first touch
        if state == .Ready {
            state = .Playing
        }
        
        for touch in touches {
            //Get touch position in scene
            let location = touch.location(in: self)
            
            //Was touch on left/right hand side of screen
            if location.x > size.width / 2 {
                character.side = .Right
            } else {
                character.side = .Left
            }
            
            //Grab sushi on top of the base sushi piece, it will always be 'first'
            let firstPiece = sushiTower.first as SushiPiece!
            
            //Check character side against sushi piece side (this is a death collision check)
            if character.side == firstPiece?.side {
                
                //Drop all the the sushi down a place (visually)
                for node: SushiPiece in sushiTower {
                    node.run(SKAction.move(by: CGVector(dx: 0, dy: -55), duration: 0.10))
                }
                
                gameOver()
                
                //No need to continue as player dead 
                return
                
            }
            
            //Increment Health
            health += 0.1
            
            //Increment Score
            score += 1
            
            //Remove from sushi tower array
            sushiTower.removeFirst()
            
            //Animate the punched sushi piece
            firstPiece?.flip(side: character.side)
            
            //Add a new sushi piece to the top of the tower
            addRandomPieces(total: 1)
            
            for node: SushiPiece in sushiTower {
                node.run(SKAction.move(by: CGVector(dx: 0 , dy: -55), duration: 0.10))
                
                //Reduce xPosition to stop xPosition climbling over UI
                node.zPosition -= 1
            }
            
        }
    }
    
    func gameOver() {
        //Game Over
        
        state = .GameOver
        
        //Turn all the sushi pieces red
        for node: SushiPiece in sushiTower {
            node.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 0.50))
        }
        
        //Make the player turn red
        character.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 0.50))
        
        //Change play button selection handler
        playButton.selectedHandler = {
            
            //Grab reference to the SpriteKit view 
            let skView = self.view as SKView!
            
            //Load Game Scene
            let scene = GameScene(fileNamed: "GameScene")! as GameScene
            
            //Ensure correct aspect mode
            scene.scaleMode = .aspectFill
            
            //Resart GameScene
            skView?.presentScene(scene)
        }
    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if state != .Playing { return }
        
        //Decrease Health
        health -= 0.01
        
        //Has the player run out of health
        if health < 0 { gameOver() }
        
    }
}
