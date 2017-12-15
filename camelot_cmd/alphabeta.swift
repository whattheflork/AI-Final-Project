//
//  alphabeta.swift
//  camelot_cmd
//
//  Created by Matthew Florkiewicz on 11/30/17.
//  Copyright © 2017 Matthew Florkiewicz. All rights reserved.
//

import Foundation

//Stats to keep track of and print after every turn
var total_nodes: Int = 0
var max_depth: Int = 0
var min_prunes: Int = 0
var max_prunes: Int = 0
    
    func alphaBetaSearch(initState: inout CamelotState) -> CamelotState {
        var alpha: Int = -1000
        var beta: Int = 1000
        let val = maxSearch(curr_state: &initState, alpha: &alpha, beta: &beta)
        var nextMove = initState.successors[0]
        for i in 0...initState.successors.count-1 {
            if(initState.successors[i].value == val) {
                nextMove = initState.successors[i]
            }
        }
        statCheck()
        return nextMove
    }

    func statCheck() {
        print("Total number of nodes generated: \(total_nodes)")
        print("Maximum depth of tree: \(max_depth)")
        print("Number of max branches pruned: \(max_prunes)")
        print("Number of min branches pruned: \(min_prunes)")
        total_nodes = 0
        max_depth = 0
        min_prunes = 0
        max_prunes = 0
    }
    
    func maxSearch(curr_state: inout CamelotState, alpha: inout Int, beta: inout Int) -> Int {
        curr_state.successors = curr_state.genPossibleMoves()
        total_nodes += curr_state.successors.count
        
        //Test for leaf nodes
        if(curr_state.terminalTest() || curr_state.successors.count == 0) {
            return curr_state.value
        }
        
        //Cutoff test
        if(curr_state.depth >= depthCut) {
            return curr_state.getUtility()
        }
        
        var val: Int = -1000
        for i in 0..<curr_state.successors.count {
            let v = minSearch(curr_state:&curr_state.successors[i], alpha: &alpha, beta: &beta)
            val = max(val, v)
            if(val >= beta) {
                max_prunes = max_prunes + 1
                return val
            }
            if(curr_state.successors[i].depth > max_depth) {
                max_depth = curr_state.successors[i].depth
            }
            alpha = max(alpha, val)
        }
        curr_state.value = val
        return val
    }
    
    func minSearch(curr_state: inout CamelotState, alpha: inout Int, beta: inout Int) -> Int {
        curr_state.successors = curr_state.genPossibleMoves()
        total_nodes += curr_state.successors.count
        
        //Test for leaf node
        if(curr_state.terminalTest() || curr_state.successors.count == 0) {
            return curr_state.value
        }
        
        //Cutoff test
        if(curr_state.depth >= depthCut) {
            return curr_state.getUtility()
        }
        
        var val = 1000
        for i in 0..<curr_state.successors.count {
            let v = maxSearch(curr_state: &curr_state.successors[i], alpha: &alpha, beta: &beta)
            val = min(val, v)
            if(val <= alpha) {
                min_prunes = min_prunes + 1
                return val
            }
            if(curr_state.successors[i].depth > max_depth) {
                max_depth = curr_state.successors[i].depth
            }
            beta = min(val, beta)
        }
        curr_state.value = val
        return val
        
    }

