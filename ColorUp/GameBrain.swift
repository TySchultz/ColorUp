//
//  GameBrain.swift
//  ColorUp
//
//  Created by Ty Schultz on 10/18/14.
//  Copyright (c) 2014 Ty Schultz. All rights reserved.
//

import Foundation

protocol GameBrainProtocol : class {
    
}

class GameBrain: NSObject {

    var correctSide : Int

    init(correctSide side: Int, delegate: GameBrainProtocol) {
        correctSide = 0
    }
    
    func increaseScore(correctSide side :Int){
        correctSide = side
    }
}

