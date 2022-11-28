//
//  Grid.swift
//  Simple TicTacToe (iOS)
//
//  Created by Lancelot Liu on 26/11/2022.
//

import Foundation

final class Grid {
    
    enum State {
        case none
        case cross
        case nought
        
        func other() -> State {
            if self == .none { return .none }
            return self == .cross ? .nought : .cross
        }
    }
    
    struct WinInfo {
        var startCell: (Int, Int)
        var endCell: (Int, Int)
        var winner: State
    }
    
    private var grid: Array<Array<State>> = .init(repeating: .init(repeating: .none, count: 3), count: 3)
    
    public init() { }
    private init(grid: Array<Array<State>>) {
        if grid.count != 3 { return }
        for row in grid {
            if row.count != 3 { return }
        }
        
        self.grid = grid
    }
    
    public subscript(row: Int, column: Int) -> State {
        get {
            assert(row < 3 && column < 3, "[\(row), \(column)] is out of range!")
            return grid[row][column]
        }
        
        set {
            assert(row < 3 && column < 3, "[\(row), \(column)] is out of range!")
            grid[row][column] = newValue
        }
    }
    
    public func isFull() -> Bool {
        return !self.grid.joined().contains(.none)
    }
    
    public func isEmpty() -> Bool {
        return self.grid.joined().allSatisfy { $0 == .none }
    }
    
    public func reset() {
        self.grid = .init(repeating: .init(repeating: .none, count: 3), count: 3)
    }
    
    public func check() -> WinInfo {
        return Grid.checkGrid(self.grid)
    }
    
    public func copy() -> Grid {
        return Grid(grid: self.grid)
    }
    
    static func checkSet(_ triplet: Array<State>) -> State {
        if triplet.allSatisfy({ $0 == triplet.first }) {
            switch triplet[0] {
                case .nought, .cross: return triplet[0]
                default: return .none
            }
        }
        
        return .none
    }
    
    static func emptyWinInfo() -> WinInfo {
        return WinInfo(startCell: (-1, -1), endCell: (-1, -1), winner: .none)
    }
    
    static func checkGrid(_ grid: Array<Array<State>>) -> WinInfo {
        // Return empty result if less than or equal to five moves.
        if grid.joined().compactMap({ $0 != .none }).count <= 5 { return Grid.emptyWinInfo() }
        
        // Horizontal Checks
        for i in 0..<3 {
            let result = Grid.checkSet(grid[i])
            if result != .none {
                return WinInfo(startCell: (i, 0), endCell: (i, 2), winner: result)
            }
        }
        
        // Vertical Checks
        for i in 0..<3 {
            let result = Grid.checkSet([grid[0][i], grid[1][i], grid[2][i]])
            if result != .none {
                return WinInfo(startCell: (0, i), endCell: (2, i), winner: result)
            }
        }
        
        // Diagonal Checks
        let primaryDiagonalResult = Grid.checkSet([grid[0][0], grid[1][1], grid[2][2]])
        if primaryDiagonalResult != .none {
            return WinInfo(startCell: (0, 0), endCell: (2, 2), winner: primaryDiagonalResult)
        }
        
        let secondaryDiagonalResult = Grid.checkSet([grid[2][0], grid[1][1], grid[0][2]])
        if secondaryDiagonalResult != .none {
            return WinInfo(startCell: (2, 0), endCell: (0, 2), winner: secondaryDiagonalResult)
        }
                
        return Grid.emptyWinInfo()
    }
    
    // Algorithms
    
    public func noobTurn(_ player: State) {
        if self.isFull() { return }
        
        while true {
            let i: Int = Int.random(in: 0...2)
            let j: Int = Int.random(in: 0...2)
            if self[i, j] == .none {
                self[i, j] = player
                return
            }
        }
    }
    
    /// Uses minimax to completely over-engineer tic-tac-toe.
    public func expertTurn(_ player: State) {
        if self.isFull() { return }
        
        // Cheating: Pre-programme first move as cross.
        if self.isEmpty() && player == .cross {
            self[0, 0] = player
            return
        }
        
        var bestScore = -1
        var bestMove = (-1, -1)
        
        for row in 0..<3 {
            for column in 0..<3 {
                if self[row, column] == .none {
                    self[row, column] = player
                    let moveScore = minimax(board: self, isMax: false, player: player, depth: 0, alpha: -10, beta: 10)
                    self[row, column] = .none
                    if moveScore > bestScore {
                        bestScore = moveScore
                        bestMove = (row, column)
                    }
                }
            }
        }
        
        if bestMove != (-1, -1) {
            self[bestMove.0, bestMove.1] = player
        }
    }
    
    private func minimax(board: Grid, isMax: Bool, player: Grid.State, depth: Int, alpha: Int, beta: Int) -> Int {
        let winner = board.check().winner
        if winner != .none { return board.check().winner == player ? 10 - depth : -10 + depth}
        if board.isFull() { return 0 }
        
        var bestScore = 1 * (isMax ? -1 : 1)
        
        outerLoop: for row in 0..<3 {
            for column in 0..<3 {
                if board[row, column] == .none {
                    board[row, column] = isMax ? player : player.other()
                    let minimaxResult = minimax(board: board, isMax: !isMax, player: player, depth: depth + 1, alpha: alpha, beta: beta)
                    bestScore = isMax ? max(bestScore, minimaxResult) : min(bestScore, minimaxResult)
                    if (isMax ? beta : min(beta, bestScore)) <= (isMax ? max(alpha, bestScore) : alpha) { print("a"); break outerLoop }
                    board[row, column] = .none
                }
            }
        }
        
        return bestScore
    }
}
