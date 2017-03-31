//
//  Character.swift
//  SushiNeko
//
//  Created by Cappillen on 3/31/17.
//  Copyright © 2017 Cappillen. All rights reserved.
//

import SpriteKit

class Character: SKSpriteNode {
    
    //Character side
    var side: Side = .Left {
        
        didSet {
            if side == .Left {
                xScale = 1
                position.x = 70
            } else {
                //An easy way to flip an asset horizontally is to invert the X-axis scale
                xScale = -1
                position.x = 252
            }
            
            //Load/run the punch action 
            let punch = SKAction(named: "Punch")!
            run(punch)
        }
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
