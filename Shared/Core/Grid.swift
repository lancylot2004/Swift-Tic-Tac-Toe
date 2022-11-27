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
    }
    
    struct WinInfo {
        var startCell: (Int, Int)
        var endCell: (Int, Int)
        var winner: State
    }
    
    private var grid: Array<Array<State>> = .init(repeating: .init(repeating: .none, count: 3), count: 3)
    
    public init() { }
    
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
    
    public func reset() {
        self.grid = .init(repeating: .init(repeating: .none, count: 3), count: 3)
    }
    
    @discardableResult
    public func check() -> WinInfo {
        // Horizontal Checks
        for i in 0..<3 {
            let result = self.checkSet(grid[i])
            if result != .none {
                return WinInfo(startCell: (i, 0), endCell: (i, 2), winner: result)
            }
        }
        
        // Vertical Checks
        for i in 0..<3 {
            let result = self.checkSet([grid[0][i], grid[1][i], grid[2][i]])
            if result != .none {
                return WinInfo(startCell: (0, i), endCell: (2, i), winner: result)
            }
        }
        
        // Diagonal Checks
        let primaryDiagonalResult = self.checkSet([grid[0][0], grid[1][1], grid[2][2]])
        if primaryDiagonalResult != .none {
            return WinInfo(startCell: (0, 0), endCell: (2, 2), winner: primaryDiagonalResult)
        }
        
        let secondaryDiagonalResult = self.checkSet([grid[2][0], grid[1][1], grid[0][2]])
        if secondaryDiagonalResult != .none {
            return WinInfo(startCell: (2, 0), endCell: (0, 2), winner: secondaryDiagonalResult)
        }
                
        return Grid.emptyWinInfo()
    }
    
    private func checkSet(_ triplet: Array<State>) -> State {
        let set = Array(Set(triplet))
        if set.count == 1 {
            switch set[0] {
                case .nought, .cross: return set[0]
                default: return .none
            }
        }
        
        return .none
    }
    
    static func emptyWinInfo() -> WinInfo {
        return WinInfo(startCell: (-1, -1), endCell: (-1, -1), winner: .none)
    }
}