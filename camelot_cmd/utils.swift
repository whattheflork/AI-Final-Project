//
//  utils.swift
//  camelot_cmd
//
//  Created by Matthew Florkiewicz on 12/12/17.
//  Copyright © 2017 Matthew Florkiewicz. All rights reserved.
//

import Foundation


//Decoding from alphanumeric to array representation
func decodeCoord(coord: String) -> (Int, Int) {
    var decode: (Int, Int)
    var temp: String
    var alphaDict: [String: Int] = ["A":0, "B":1, "C":2, "D":3, "E":4, "F":5, "G":6, "H":7]
    if (coord.count > 3 || alphaDict[String(coord[coord.startIndex])] == nil) {
        print("ERROR - Coord provided is not correct")
        return (-1, -1)
    }
    else {
        decode.0 = alphaDict[String(coord[coord.startIndex])]!
        temp = String(coord[coord.index(after: coord.startIndex)])
        if(coord.count == 3) {
            temp.append(coord[coord.index(coord.startIndex, offsetBy: 2)])
        }
        decode.1 = Int(temp)! - 1
        return decode
    }
}

//Encoding from alphanumeric to array representation
func encodeCoord(coord: Int) -> String {
    var indDict: [Int: String] = [0:"A",1:"B",2:"C",3:"D",4:"E",5:"F",6:"G",7:"H"]
    
    let row = Int(coord/8) + 1
    let col = indDict[coord%8]
    
    return String(describing: col) + String(describing: row)
}

//Determinining if the move is legal
func isLegalMove(initState: Piece, finalState: Piece, board: Board, whosTurn: String) -> Bool {
    if(finalState.x < 0 || finalState.x > 7 || finalState.y < 0 || finalState.y > 13) {
        return false
    }
    else if(initState.color != whosTurn) {
        return false
    }
    else if(finalState.color != "Blank") {
        return false
    }
    //Capturing/Cantering moves
    else if((abs(finalState.x - initState.x) == 2 && abs(finalState.y - initState.y) == 0) || (abs(finalState.x - initState.x) == 0 && abs(finalState.y - initState.y) == 2) || (abs(finalState.x - initState.x) == 2 && abs(finalState.y - initState.y) == 2)) {
        let jumpedPiece = board.pieceAt(posX: initState.x + (finalState.x - initState.x)/2, posY: initState.y + (finalState.y - initState.y)/2)
        if(jumpedPiece.color == "Empty" || jumpedPiece.color == "Blank") {
            return false
        }
        else {
            return true
        }
    }
    else if(abs(finalState.x - initState.x) >= 2 || abs(finalState.y - initState.y) >= 2) {
        return false
    }
    return true
}
