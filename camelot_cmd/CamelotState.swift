//
//  CamelotState.swift
//  camelot_cmd
//
//  Created by Matthew Florkiewicz on 12/4/17.
//  Copyright © 2017 Matthew Florkiewicz. All rights reserved.
//

import Foundation

class CamelotState {
    var depth: Int
    var value: Int
    var successors: [CamelotState]
    var boardSet: Board
    var whosTurn: String
    
    
    
    //Evaluation function
    func getUtility() -> Int {
        var whiteDist: Double = 100.0
        var blackDist: Double = 100.0
        
        //Minimum distance of black piece from goal
        for i in 0...boardSet.blackPawns.count-1 {
            blackDist = min(blackDist, Double(abs(13 - boardSet.blackPawns[i].x) + abs(boardSet.blackPawns[i].y-3)))
        }
        
        //Minimum distance of white piece from goal
        for i in 0...boardSet.whitePawns.count-1 {
            whiteDist = min(whiteDist, Double(abs(boardSet.whitePawns[i].x)+abs(boardSet.whitePawns[i].y-3)))
        }
        
        //To account for divide by zero errors in the next step
        if(whiteDist == 0) {
            whiteDist = 1
        }
        else if (blackDist == 0) {
            blackDist = 1
        }
        
        //Actual eval function = distance component + capture component
        let captureComp = 0.4 * (Double(boardSet.blackPawns.count) - Double(boardSet.whitePawns.count))
        
        let distanceComp =  0.2 * (1/blackDist) + 0.2 * (-1/whiteDist)
        
        let utility = 1000 * (captureComp + distanceComp)
        
        self.value = Int(utility)
        return Int(utility)
    }
    
    
    //Generating the successor states
    func genPossibleMoves() -> [CamelotState] {
        var possible_moves = [CamelotState]()
        var tempState: CamelotState
        var tempBlacks: [Piece] = boardSet.blackPawns
        var tempWhites: [Piece] = boardSet.whitePawns
        var tempPiece: Piece
        var pieces: [Piece]
        var moves: [(Int, Int)]

        var pieceAfterCap: Piece
    
        if(whosTurn == "Black") {
            pieces = boardSet.blackPawns
        }
        else {
            pieces = boardSet.whitePawns
        }
        
        for i in 0...pieces.count-1 {
            if(i == 0) {
                moves = [(0,1), (1,1), (1,0), (0, -1), (1, -1)]
            }
            else if(i == 7) {
                moves = [(0,1), (-1, 1), (-1, 0), (-1, -1), (0, -1)]
            }
            else {
                moves = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]
            }
            
            for move in moves {
                let nextTurn: String
                if whosTurn == "Black" {
                    nextTurn = "White"
                }
                else {
                    nextTurn = "Black"
                }
                tempPiece = boardSet.pieceAt(posX: pieces[i].x+move.0, posY: pieces[i].y+move.1)
                //Capturing moves - White piece
                if(whosTurn == "White" && tempPiece.color == "Black") {
                    pieceAfterCap = boardSet.pieceAt(posX: pieces[i].x+move.0+move.0, posY: pieces[i].y+move.1+move.1)
                    if(!(tempPiece.x==0 && pieces[i].x == 1) && !(tempPiece.x==7 && pieces[i].x==6) && isLegalMove(initState: pieces[i], finalState: pieceAfterCap, board: boardSet, whosTurn: whosTurn)) {
                        pieceAfterCap.color = whosTurn
                        tempWhites[i] = pieceAfterCap
                        tempBlacks.remove(at: boardSet.findIndexOfPiece(pieces: tempBlacks, pieceX: tempPiece.x, pieceY: tempPiece.y))
                        tempState = CamelotState(blackPieces: tempBlacks, whitePieces: tempWhites, depth: depth+1, value: 0, whosTurn: nextTurn)
                        possible_moves = [tempState]
                        return possible_moves
                    }
                }
                //Capturing moves - Black Piece
                else if(whosTurn == "Black" && boardSet.pieceAt(posX: tempPiece.x, posY: tempPiece.y).color == "White") {
                    pieceAfterCap = boardSet.pieceAt(posX: pieces[i].x+move.0+move.0, posY: pieces[i].y+move.1+move.1)
                    if(!(tempPiece.x==0 && pieces[i].x == 1) && !(tempPiece.x==7 && pieces[i].x==6) && isLegalMove(initState: pieces[i], finalState: pieceAfterCap, board: boardSet, whosTurn: whosTurn)) {
                        pieceAfterCap.color = whosTurn
                        tempBlacks[i] = pieceAfterCap
                        tempWhites.remove(at: boardSet.findIndexOfPiece(pieces: tempWhites, pieceX: tempPiece.x, pieceY: tempPiece.y))
                        tempState = CamelotState(blackPieces: tempBlacks, whitePieces: tempWhites, depth: depth+1, value: 0, whosTurn: nextTurn)
                        possible_moves = [tempState]
                        return possible_moves
                    }
                }
                //Cantering moves - White piece
                else if(whosTurn == "White" && boardSet.pieceAt(posX: tempPiece.x, posY: tempPiece.y).color == "White") {
                    pieceAfterCap = boardSet.pieceAt(posX: pieces[i].x+move.0+move.0, posY: pieces[i].y+move.1+move.1)
                    if(!(tempPiece.x==0 && pieces[i].x == 1) && !(tempPiece.x==7 && pieces[i].y==6) && isLegalMove(initState: pieces[i], finalState: pieceAfterCap, board: boardSet, whosTurn: whosTurn)) {
                        pieceAfterCap.color = whosTurn
                        tempWhites[i] = pieceAfterCap
                        tempState = CamelotState(blackPieces: tempBlacks, whitePieces: tempWhites, depth: depth+1, value: 0, whosTurn: "Black")
                        possible_moves.append(tempState)
                    }
                }
                //Cantering moves - Black piece
                else if(whosTurn == "Black" && boardSet.pieceAt(posX: tempPiece.x, posY: tempPiece.y).color == "Black") {
                    pieceAfterCap = boardSet.pieceAt(posX: pieces[i].x+move.0+move.0, posY: pieces[i].y+move.1+move.1)
                    if(!(tempPiece.x==0 && pieces[i].x == 1) && !(tempPiece.x==7 && pieces[i].x==6) && isLegalMove(initState: pieces[i], finalState: pieceAfterCap, board: boardSet, whosTurn: whosTurn)) {
                        pieceAfterCap.color = whosTurn
                        tempBlacks[i] = pieceAfterCap
                        tempState = CamelotState(blackPieces: tempBlacks, whitePieces: tempWhites, depth: depth+1, value: 0, whosTurn: "Black")
                        possible_moves.append(tempState)
                    }
                }
                //Regular move - White piece
                else if(isLegalMove(initState: pieces[i], finalState: tempPiece, board: boardSet, whosTurn: whosTurn) && whosTurn == "White") {
                    tempPiece.color = whosTurn
                    tempWhites[i] = tempPiece
                    tempState = CamelotState(blackPieces: tempBlacks, whitePieces: tempWhites, depth: depth+1, value: 0, whosTurn: "Black")
                    possible_moves.append(tempState)
                }
                //Regular move - Black piece
                else if(isLegalMove(initState: pieces[i], finalState: tempPiece, board: boardSet, whosTurn: whosTurn) && whosTurn == "Black") {
                    tempPiece.color = whosTurn
                    tempBlacks[i] = tempPiece
                    tempState = CamelotState(blackPieces: tempBlacks, whitePieces: tempWhites, depth: depth+1, value: 0, whosTurn: "Black")
                    possible_moves.append(tempState)
                }
                tempState = self
                tempBlacks = boardSet.blackPawns
                tempWhites = boardSet.whitePawns
            }
        }
        return possible_moves
    }
    
    //testing for terminal state
    func terminalTest() -> Bool {
        if((boardSet.whitePawns.count == 0 && boardSet.blackPawns.count >= 2) || (boardSet.pieceAt(posX: 3, posY: 0).color == "Black" && boardSet.pieceAt(posX: 4, posY: 0).color == "Black")) {
            self.value = 1000
            return true
        }
        else if((boardSet.blackPawns.count == 0 && boardSet.whitePawns.count >= 2) || (boardSet.pieceAt(posX: 3, posY: 13).color == "White") && boardSet.pieceAt(posX: 4, posY: 13).color == "White") {
            self.value = -1000
            return true
        }
        else {
            return false
        }
    }
    
    func prettyPrint() {
        boardSet.prettyPrint()
    }
    
    init() {
        self.boardSet = Board()
        self.depth = 0
        self.value = 0
        self.successors = [CamelotState]()
        self.whosTurn = "Black"
    }
    
    
    
    //Initializer functions
    init (blackPieces: [Piece], whitePieces: [Piece], depth: Int, value: Int, whosTurn: String) {
        self.boardSet = Board(blacks: blackPieces, whites: whitePieces)
        self.depth = depth
        self.value = value
        self.successors = [CamelotState]()
        self.whosTurn = whosTurn
    }
    
    init (currBoard: Board, depth: Int, value: Int, whosTurn: String) {
        self.boardSet = currBoard
        self.depth = depth
        self.value = value
        self.successors = [CamelotState]()
        self.whosTurn = whosTurn
    }
}
