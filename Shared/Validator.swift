//
//  Validator.swift
//  Simple TicTacToe
//
//  Created by lancylot2004 on 07/04/2022.
//

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
    
    func processSet(_ set: Array<squareState>) {
        if set.count == 1 {
            switch set[0] {
            case .cross: tess.crossScore += 1
            case .nought: tess.noughtScore += 1
            case .none: break
            }
        }
    }
    
    func checkGrid() {
        // Horizontal Checks
        for row in grid {
            let rowSet = Array(Set(row))
            self.processSet(rowSet)
        }
        
        // Vertical Checks
        for i in 0..<3 {
            let columnSet = Array(Set([grid[0][i], grid[1][i], grid[2][i]]))
            self.processSet(columnSet)
        }
        
        // Diagonal Checks
        let leftToRightSet = Array(Set([grid[0][0], grid[1][1], grid[2][2]]))
        self.processSet(leftToRightSet)
        
        let rightToLeftSet = Array(Set([grid[2][0], grid[1][1], grid[0][2]]))
        self.processSet(rightToLeftSet)
        
        let allSet = Array(grid[0] + grid[1] + grid[2])
        // if !allSet.contains(.none) { return .draw }
        
        return
    }
    
    static let global = Validator()
    private init() {}
}
