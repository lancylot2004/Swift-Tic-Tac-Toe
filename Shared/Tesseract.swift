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

enum AIState {
    case noob
    case human
    case ai
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
}

class Tesseract: ObservableObject {
    /// Variables
    @Published var grid: Array<Array<state>> = [[.none, .none, .none],[.none, .none, .none],[.none, .none, .none]]
    @Published var player: state = .cross
    
    @Published var crossScore: Int = 0
    @Published var noughtScore: Int = 0
    @Published var drawScore: Int = 0
    @Published var winningPair: Array<Int>? = nil
    @Published var winning: Bool = false
    
    @Published var locked: Bool = false
    @Published var resetCountdown: Double = 0
    @Published var resetCountdownFull: Double = 0 {
        didSet {
            resetCountdown = resetCountdownFull
        }
    }
    
    @Published var AIPlayer: state = .nought
    @Published var AIDifficulty: AIState = .noob
    
    /// Constants
    public let constTransition: AnyTransition =
        .opacity.animation(.easeInOut(duration: 0.1))
        .combined(with: .scale.animation(.easeInOut(duration: 0.1)))
    
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
        
        let _ = Timer.scheduledTimer(withTimeInterval: 3.5, repeats: false) { [self] _ in
            resetGrid()
            winningPair = nil
            player = .cross
            locked = false
            winning = false
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
    private func processSet(_ set: Array<state>) -> Bool {
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
    public func checkGrid() {
        // Horizontal Checks
        for i in 0..<3 {
            let rowSet = Array(Set(grid[i]))
            winningPair = [i, 0, i, 2]
            if processSet(rowSet) { return }
        }
        
        // Vertical Checks
        for i in 0..<3 {
            let columnSet = Array(Set([grid[0][i], grid[1][i], grid[2][i]]))
            winningPair = [0, i, 2, i]
            if processSet(columnSet) { return }
        }
        
        // Diagonal Checks
        let leftToRightSet = Array(Set([grid[0][0], grid[1][1], grid[2][2]]))
        winningPair = [0, 0, 2, 2]
        if processSet(leftToRightSet) { return }
        
        let rightToLeftSet = Array(Set([grid[2][0], grid[1][1], grid[0][2]]))
        winningPair = [2, 0, 0, 2]
        if processSet(rightToLeftSet) { return }
        
        let allSet = Array(grid[0] + grid[1] + grid[2])
        if !allSet.contains(.none) { drawScore += 1; animatedResetGrid(); return }
        
        return
    }
    
    /// Toggles `player`
    public func togglePlayer() { player = player == .cross ? .nought : .cross }
    
    /// (*not*) ARTIFICIAL INTELLIGENCE
    func AIProcess() {
        if AIPlayer == .none { return }
        if player != AIPlayer { return }
        
        locked = true
        resetCountdownFull = 1
        
        let _ = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [self] timer in
            resetCountdown -= 0.01
            if resetCountdown <= 0 {
                timer.invalidate()
                resetCountdown = 0
                return
            }
        }
        
        let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [self] _ in
            switch AIDifficulty {
                case .noob: noobTurn()
                case .human: return
                case .ai: return
            }
            
            checkGrid()
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
    
    private func humanTurn() {
        noobTurn()
    }
    
    private func AITurn() {
        noobTurn()
    }
    
    /// Singleton
    static let global = Tesseract()
    private init() {}
}
