//
//  Validator.swift
//  Simple TicTacToe
//
//  Created by lancylot2004 on 07/04/2022.
//

import Foundation

enum gridState {
    case crossVictory
    case noughtVictory
    case draw
    case ongoing
}

class Validator {
    private var tess: Tesseract = Tesseract.global
    
    private var grid: Array<Array<squareState>> = [[.none, .none, .none],[.none, .none, .none],[.none, .none, .none]]
    func setGrid(_ grid: Array<Array<squareState>>) {
        // No safety checks - stupid, yes.
        self.grid = grid
    }
    
    func resetGrid() {
        tess.locked = true
        var interval: Double = abs(Double(Date().distance(to: tess.start)))
        interval = interval > 60 ? 60 : interval
        let timeAdd: Double = 2.25 * (interval / 60)
        
        let _ = Timer.scheduledTimer(withTimeInterval: 1.75 + timeAdd, repeats: false) { _ in
            self.tess.reset(.grid)
            self.tess.locked = false
        }
        
    }
    
    func processSet(_ set: Array<squareState>) -> Bool {
        if set.count == 1 {
            switch set[0] {
            case .cross: tess.crossScore += 1; resetGrid(); return true
            case .nought: tess.noughtScore += 1; resetGrid(); return true
            case .none: return false
            }
        } else {
            return false
        }
    }
    
    func checkGrid() {
        // Horizontal Checks
        for row in grid {
            let rowSet = Array(Set(row))
            if processSet(rowSet) { return }
        }
        
        // Vertical Checks
        for i in 0..<3 {
            let columnSet = Array(Set([grid[0][i], grid[1][i], grid[2][i]]))
            if processSet(columnSet) { return }
        }
        
        // Diagonal Checks
        let leftToRightSet = Array(Set([grid[0][0], grid[1][1], grid[2][2]]))
        if processSet(leftToRightSet) { return }
        
        let rightToLeftSet = Array(Set([grid[2][0], grid[1][1], grid[0][2]]))
        if processSet(rightToLeftSet) { return }
        
        let allSet = Array(grid[0] + grid[1] + grid[2])
        if !allSet.contains(.none) { tess.drawScore += 1; return }
        
        return
    }
    
    static let global = Validator()
    private init() {}
}
