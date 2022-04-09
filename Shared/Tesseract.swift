//
//  Tesseract.swift
//  Simple TicTacToe
//
//  Created by lancylot2004 on 04/04/2022.
//

import SwiftUI
import UIKit

enum state {
    case none
    case cross
    case nought
}

enum gridState {
    case crossVictory
    case noughtVictory
    case draw
    case ongoing
}

enum resetOption {
    case grid
    case score
}

class Tesseract: ObservableObject {
    /// Variables
    @Published var grid: Array<Array<state>> = [[.none, .none, .none],[.none, .none, .none],[.none, .none, .none]]
    @Published var player: state = .cross
    
    @Published var crossScore: Int = 0
    @Published var noughtScore: Int = 0
    @Published var drawScore: Int = 0
    
    @Published var locked: Bool = false
    @Published var resetCountdown: Double = 0
    
    /// Haptics
    public let generator = UIImpactFeedbackGenerator(style: .heavy)
    
    public func haptic() {
        generator.impactOccurred()
    }
    
    /// Resets
    private func resetScore() {
        crossScore = 0
        noughtScore = 0
    }
    
    private func resetGrid() {
        grid = [[.none, .none, .none],[.none, .none, .none],[.none, .none, .none]]
        player = .cross
    }
    
    func animatedResetGrid() {
        player = .none
        locked = true
        resetCountdown = 3.5
        
        let _ = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [self] timer in
            resetCountdown -= 0.01
            if resetCountdown <= 0 {
                timer.invalidate()
                resetCountdown = 0
                return
            }
        }
        
        let _ = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: false) { [self] _ in
            resetGrid()
            player = .cross
            locked = false
        }
    }
    
    public func reset(_ option: resetOption) {
        switch option {
        case .grid: resetGrid()
        case .score: resetScore()
        }
    }
    
    /// --Validation Functions--
    /// Takes an array of `squareState`s and determines if it constitutes a win for either player.
    func processSet(_ set: Array<state>) -> Bool {
        if set.count == 1 {
            switch set[0] {
            case .cross: crossScore += 1; animatedResetGrid(); return true
            case .nought: noughtScore += 1; animatedResetGrid(); return true
            case .none: return false
            }
        } else {
            return false
        }
    }
    
    /// Performs a check for winners for the current grid.
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
        if !allSet.contains(.none) { drawScore += 1; animatedResetGrid(); return }
        
        return
    }
    
    /// Singleton
    static let global = Tesseract()
    private init() {}
}
