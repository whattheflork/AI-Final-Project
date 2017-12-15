//
//  main.swift
//  camelot_cmd
//
//  Created by Matthew Florkiewicz on 11/28/17.
//  Copyright © 2017 Matthew Florkiewicz. All rights reserved.


//CS 4613 - Artificial Intelligence
//Fall 2017
//Professor Wong

import Foundation

var initialState = CamelotState()
initialState.prettyPrint()
var currentState = CamelotState()
var currentBoard = currentState.boardSet
var depthCut: Int

var flag: Bool = false
while(!flag) {
    print("Pick a difficulty (1, 2, or 3)")
    let difficulty = readLine()
    let intDiff = Int(difficulty!)
    if(intDiff == 1) {
        depthCut = 2
        flag = true
    }
    else if(intDiff == 2) {
        depthCut = 3
        flag = true
    }
    else if(intDiff == 3) {
        depthCut = 4
        flag = true
    }
    else {
        print("That's not an option.")
    }
}

print("Would you like to go first? (Y/N)")
let first: String = readLine()!
if(first == "N") {
    currentState = alphaBetaSearch(initState: &currentState)
    currentState.prettyPrint()
    currentBoard = currentState.boardSet
}

while(true) {
        print("Pick the piece to move - alphanumeric coordinates")
        let prompt1 = readLine()
        let decodeInitPos = decodeCoord(coord:prompt1!)
        let selectedPiece = currentBoard.pieceAt(posX: decodeInitPos.0, posY: decodeInitPos.1)
        print("Pick the space to move it to")
        let prompt2 = readLine()
        let decodedPrompt = decodeCoord(coord: prompt2!)
        let selectedCell = currentBoard.pieceAt(posX: decodedPrompt.0, posY: decodedPrompt.1)
        if(!isLegalMove(initState: selectedPiece, finalState: selectedCell, board: currentBoard, whosTurn: "White")) {
            print("That is not a valid move!")
            continue
        }
        selectedCell.color = "White"
        if(abs(selectedCell.x - selectedPiece.x) == 2 || abs(selectedCell.y - selectedPiece.y) == 2) {
            let tempPawn = currentBoard.pieceAt(posX: selectedPiece.x + (selectedCell.x - selectedPiece.x)/2, posY: selectedPiece.y + (selectedCell.y - selectedPiece.y)/2)
            if(tempPawn.color == "Black") {
                currentBoard.blackPawns.remove(at: currentBoard.findIndexOfPiece(pieces: currentBoard.blackPawns, pieceX: tempPawn.x, pieceY: tempPawn.y))
            }
        }
        currentBoard.whitePawns[currentBoard.findIndexOfPiece(pieces: currentBoard.whitePawns, pieceX: selectedPiece.x, pieceY: selectedPiece.y)] = selectedCell
        currentState = CamelotState(currBoard: currentBoard, depth: 0, value: 0, whosTurn: "Black")
        if(currentState.terminalTest()) {
            if(currentState.value == 1000) {
                print("Skynet wins; you lose")
                exit(0)
            }
            if(currentState.value == -1000) {
                print("You win, but Skynet still also wins")
                exit(0)
            }
            else {
                print("Draw")
                exit(0)
            }
        }
        currentState.prettyPrint()
        currentState = alphaBetaSearch(initState: &currentState)
        print("Comp turn done")
        if(currentState.terminalTest()) {
            if(currentState.value == 1000) {
                print("Skynet wins; you lose")
                exit(0)
            }
            if(currentState.value == -1000) {
                print("You win, but Skynet still also wins")
                exit(0)
            }
            else {
                print("Draw")
                exit(0)
            }
        }
        currentBoard = currentState.boardSet
        currentState.prettyPrint()
}




