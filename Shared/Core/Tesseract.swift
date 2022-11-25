//
//  Tesseract.swift
//  Simple TicTacToe
//
//  Created by lancylot2004 on 04/04/2022.
//

import SwiftUI
import UIKit

enum CellState {
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

enum AIState {
    case noob
    case expert
}

enum resetOption {
    case grid
    case score
}

// Corner Radius Extensions
struct CornerRadiusShape: Shape {
    var radius = CGFloat.infinity
    var corners = UIRectCorner.allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner

    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
    
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

class Tesseract: ObservableObject {
    /// Variables
    @Published var grid: Array<Array<CellState>> = [[.none, .none, .none],[.none, .none, .none],[.none, .none, .none]]
    @Published var player: CellState = .cross
    
    @Published var crossScore: Int = 0
    @Published var noughtScore: Int = 0
    @Published var drawScore: Int = 0
    @Published var winningPair: (Int, Int, Int, Int, CellState) = (-1 ,-1, -1, -1, .none)
    @Published var winning: Bool = false
    
    @Published var locked: Bool = false
    @Published var resetCountdown: Double = 0
    @Published var resetCountdownFull: Double = 0 {
        didSet {
            resetCountdown = resetCountdownFull
        }
    }
    
    @Published var AIPlayer: CellState = .none
    @Published var AIDifficulty: AIState = .noob
    
    /// Haptics
    private let generator = UIImpactFeedbackGenerator(style: .heavy)
    
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
    
    public func animatedResetGrid() {
        player = .none
        locked = true
        winning = true
        resetCountdownFull = 3.5
        
        let _ = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [self] timer in
            resetCountdown -= 0.01
            if resetCountdown <= 0 {
                timer.invalidate()
                resetCountdown = 0
                return
            }
        }
        
        let _ = Timer.scheduledTimer(withTimeInterval: resetCountdownFull, repeats: false) { [self] _ in
            resetGrid()
            winningPair = (-1, -1, -1, -1, .none)
            player = .cross
            locked = false
            winning = false
            AIProcess()
        }
    }
    
    public func reset(_ option: resetOption) {
        switch option {
            case .grid:
                resetGrid()
                AIProcess()
            case .score: resetScore()
        }
    }
    
    /// --Validation Functions--
    /// Takes an array of `squareState`s and determines if it constitutes a win for either player. Will only change game state if `touch` is true.
    private func processSet(_ set: Array<CellState>, touch: Bool = true) -> CellState {
        if set.count == 1 {
            switch set[0] {
                case .cross: crossScore += 1; if touch { animatedResetGrid() }; return .cross
                case .nought: noughtScore += 1; if touch { animatedResetGrid() }; return .nought
                case .none: return .none
            }
        } else {
            return .none
        }
    }
    
    /// Performs a check for winners for the current grid.
    @discardableResult
    public func checkGrid(_ grid: Array<Array<CellState>>, touch: Bool = true) -> CellState {
        // Horizontal Checks
        for i in 0..<3 {
            let rowSet = Array(Set(grid[i]))
            winningPair = (i, 0, i, 2, winningPair.4)
            winningPair.4 = processSet(rowSet, touch: touch)
            if winningPair.4 != .none { return winningPair.4 }
        }
        
        // Vertical Checks
        for i in 0..<3 {
            let columnSet = Array(Set([grid[0][i], grid[1][i], grid[2][i]]))
            winningPair = (0, i, 2, i, winningPair.4)
            winningPair.4 = processSet(columnSet, touch: touch)
            if winningPair.4 != .none { return winningPair.4 }
        }
        
        // Diagonal Checks
        let leftToRightSet = Array(Set([grid[0][0], grid[1][1], grid[2][2]]))
        winningPair = (0, 0, 2, 2, winningPair.4)
        winningPair.4 = processSet(leftToRightSet, touch: touch)
        if winningPair.4 != .none { return winningPair.4 }
        
        let rightToLeftSet = Array(Set([grid[2][0], grid[1][1], grid[0][2]]))
        winningPair = (2, 0, 0, 2, winningPair.4)
        winningPair.4 = processSet(rightToLeftSet, touch: touch)
        if winningPair.4 != .none { return winningPair.4 }
        
        let allSet = Array(grid[0] + grid[1] + grid[2])
        if !allSet.contains(.none) { drawScore += 1; animatedResetGrid(); return .none }
        
        return .none
    }
    
    /// Toggles `player`
    public func togglePlayer() { player = player == .cross ? .nought : .cross }
    
    /// (*not*) ARTIFICIAL INTELLIGENCE
    func AIProcess() {
        if locked == true { return }
        if AIPlayer == .none { return }
        if player != AIPlayer { return }
        
        locked = true
        resetCountdownFull = 0.7
        
        let _ = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [self] timer in
            resetCountdown -= 0.01
            if resetCountdown <= 0 {
                timer.invalidate()
                resetCountdown = 0
                return
            }
        }
        
        let _ = Timer.scheduledTimer(withTimeInterval: resetCountdownFull, repeats: false) { [self] _ in
            switch AIDifficulty {
                case .noob: noobTurn()
                case .expert: expertTurn()
            }
            
            checkGrid(self.grid)
            locked = false
        }
    }
    
    private func noobTurn() {
        while true {
            let i: Int = Int.random(in: 0...2)
            let j: Int = Int.random(in: 0...2)
            if grid[i][j] == .none {
                grid[i][j] = player
                togglePlayer()
                return
            }
        }
    }
    
    /// Uses minimax to completely over-engineer tic-tac-toe.
    private func expertTurn() {
        noobTurn()
//        let bestSolution = minimax(grid: self.grid)
//
//        if bestSolution.1 != -1 && bestSolution.2 != -1 {
//            self.grid[bestSolution.1][bestSolution.2] = player
//            togglePlayer()
//        }
    }
    
    /// Singleton
    static let global = Tesseract()
    private init() {}
}
