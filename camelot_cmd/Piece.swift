//
//  Piece.swift
//  camelot_cmd
//
//  Created by Matthew Florkiewicz on 12/4/17.
//  Copyright © 2017 Matthew Florkiewicz. All rights reserved.
//

import Foundation

class Piece {
    var x: Int
    var y: Int
    var color: String
    
    init (x: Int, y: Int, color: String) {
        self.x = x
        self.y = y
        self.color = color
    }
    
    func equals(otherPiece: Piece) -> Bool {
        if (self.x == otherPiece.x && self.y == otherPiece.y) {
            return true
        }
        else {
            return false
        }
    }
}
