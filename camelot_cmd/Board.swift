//
//  Board.swift
//  camelot_cmd
//
//  Created by Matthew Florkiewicz on 12/12/17.
//  Copyright © 2017 Matthew Florkiewicz. All rights reserved.
//

import Foundation

class Board {
    var blackPawns: [Piece]
    var whitePawns: [Piece]
    //Tiles on the board that don't exist
    let emptys: [Piece] = [Piece(x: 0,y: 0, color: "Empty"),Piece(x: 1,y: 0, color: "Empty"), Piece(x: 2,y: 0, color: "Empty"), Piece(x: 5,y: 0, color: "Empty"), Piece(x: 6,y: 0,color: "Empty"), Piece(x: 7,y: 0,color: "Empty"), Piece(x: 0, y: 1, color: "Empty"), Piece(x: 1, y: 1, color: "Empty"), Piece(x: 6, y: 1, color: "Empty"), Piece(x: 7, y: 1, color: "Empty"), Piece(x: 0, y: 2, color: "Empty"), Piece(x: 7, y: 2, color: "Empty"), Piece(x: 0, y: 11, color: "Empty"), Piece(x: 7, y: 11, color: "Empty"), Piece(x: 0, y: 12, color: "Empty"), Piece(x: 1, y: 12, color: "Empty"), Piece(x: 6, y: 12, color: "Empty"), Piece(x: 7, y: 12, color: "Empty"), Piece(x: 0, y: 13, color: "Empty"), Piece(x: 1, y: 13, color: "Empty"), Piece(x: 2, y: 13, color: "Empty"), Piece(x: 5, y: 13, color: "Empty"), Piece(x: 6, y: 13, color: "Empty"), Piece(x: 7, y: 13, color: "Empty")]
    
    //Finding the piece at a certain position
    func pieceAt(posX: Int, posY: Int) -> Piece{
        for blackPawn in blackPawns {
            if blackPawn.x == posX && blackPawn.y == posY {
                return blackPawn
            }
        }
        for whitePawn in whitePawns {
            if whitePawn.x == posX && whitePawn.y == posY {
                return whitePawn
            }
        }
        for empty in emptys {
            if empty.x == posX && empty.y == posY {
                return empty
            }
        }
        return Piece(x: posX, y: posY, color: "Blank")
    }
    
    func prettyPrint() {
        var temp: Piece
        print("     A  B  C  D  E  F  G  H")
        for i in 0...13 {
            if(i >= 9) {
                print(String(i+1)+" ", terminator:"")
            }
            else {
                print(String(i+1)+"  ",terminator:"")
            }
            if(i >= 3 && i <= 10) {
                print("|", terminator:"")
            }
            else {
                print(" ", terminator:"")
            }
            for j in 0...7 {
                temp = pieceAt(posX: j, posY: i)
                if(temp.color == "Black") {
                    print("|X|", terminator:"")
                }
                else if(temp.color == "White") {
                    print("|O|", terminator:"")
                }
                else if(temp.color == "Blank") {
                    print("| |", terminator:"")
                }
                else {
                    print("   ", terminator:"")
                }
            }
            if(i >= 3 && i <= 10) {
                print("|", terminator:"")
            }
            else {
                print(" ", terminator:"")
            }
            print("")
        }
    }
    
    //Finding the index of a piece in its blackPawns/whitePawns array by its position
    func findIndexOfPiece(pieces: [Piece], pieceX: Int, pieceY: Int) -> Int {
        for i in 0...pieces.count-1 {
            if(pieces[i].x == pieceX && pieces[i].y == pieceY) {
                return i
            }
        }
        return -1
    }
    
    init() {
        blackPawns = [Piece(x:3, y:8, color:"Black"), Piece(x:4, y:8, color:"Black"), Piece(x:2, y:9, color:"Black"), Piece(x:3, y:9, color:"Black"), Piece(x:4, y:9, color:"Black"), Piece(x:5, y:9, color:"Black")]
        whitePawns = [Piece(x:3, y:5, color:"White"), Piece(x:4, y:5, color:"White"), Piece(x:2, y:4, color:"White"), Piece(x:3, y:4, color:"White"), Piece(x:4, y:4, color:"White"), Piece(x:5, y:4, color:"White")]
    }
    
    init(blacks: [Piece], whites: [Piece]) {
        blackPawns = blacks
        whitePawns = whites
    }
    
}
