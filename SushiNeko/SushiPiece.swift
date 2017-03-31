//
//  SushiPiece.swift
//  SushiNeko
//
//  Created by Cappillen on 3/31/17.
//  Copyright © 2017 Cappillen. All rights reserved.
//

import SpriteKit

class SushiPiece: SKSpriteNode {
    
    //Chopstick objects
    var rightChopstick: SKSpriteNode!
    var leftChopstick: SKSpriteNode!
    
    //Sushi type
    var side: Side = .None {
        
        didSet {
            switch side {
            case .Left:
                //Show left chopstick
                leftChopstick.isHidden = false
            case .Right:
                //Show right chopstick
                rightChopstick.isHidden = false
            case .None:
                //Hide all chopsticks
                leftChopstick.isHidden = true
                rightChopstick.isHidden = true
            }
        }
    }
    
    func  connectChopsticks() {
        //Connect the child chopsticks nodes 
        
        rightChopstick = childNode(withName: "rightChopstick") as! SKSpriteNode
        leftChopstick = childNode(withName: "leftChopstick") as! SKSpriteNode
        
        //Set the default side 
        side = .None
    }
    
    func flip(side: Side) {
        //Flip the sushi out of the screen
        
        var actionName: String = ""
        
        if side == .Left {
            actionName = "FlipRight"
        } else if side == .Right {
            actionName = "FlipLeft"
        }
        
        //Load appropriate action
        let flip = SKAction(named: actionName)!
        
        //Create a node removal action
        let remove = SKAction.removeFromParent()
        
        //Build sequence, flip the remove from scene
        let sequence = SKAction.sequence([flip, remove])
        run(sequence)
        
    }
    //You are required to implement this for your subclass to work
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    //You are required to implement this for youy subclass to workk
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
