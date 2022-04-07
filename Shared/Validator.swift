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
    private var grid: Array<Array<squareState>> = [[.none, .none, .none],[.none, .none, .none],[.none, .none, .none]]
    func setGrid(_ grid: Array<Array<squareState>>) {
        // No safety checks - stupid, yes.
        self.grid = grid
    }
    
    func processSet(_ set: Array<squareState>) -> gridState? {
            if set.count == 1 {
                return set[0] == .cross ? .crossVictory : .noughtVictory
            }
        
            return nil
        }
    
    func checkGrid() -> gridState {
        // Horizontal Checks
        for row in grid {
            let rowSet = Array(Set(row))
            if let result = self.processSet(rowSet) { return result }
        }
        
        // Vertical Checks
        for i in 0..<3 {
            let columnSet = Array(Set([grid[0][i], grid[1][i], grid[2][i]]))
            if let result = self.processSet(columnSet) { return result }
        }
        
        // Diagonal Checks
        let leftToRightSet = Array(Set([grid[0][0], grid[1][1], grid[2][2]]))
        if let result = self.processSet(leftToRightSet) { return result }
        
        let rightToLeftSet = Array(Set([grid[2][0], grid[1][1], grid[0][2]]))
        if let result = self.processSet(rightToLeftSet) { return result }
        
        let allSet = Array(grid[0] + grid[1] + grid[2])
        if !allSet.contains(.none) { return .draw }
        
        return .ongoing
    }
    
    static let global = Validator()
    private init() {}
}
