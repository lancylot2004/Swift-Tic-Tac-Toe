//
//  Tesseract.swift
//  Simple TicTacToe
//
//  Created by lancylot2004 on 04/04/2022.
//

import SwiftUI

class Tesseract: ObservableObject {
    /// Variables
    @Published var grid: Grid = Grid()
    @Published var player: Grid.State = .cross
    
    @Published var crossScore: Int = 0
    @Published var noughtScore: Int = 0
    @Published var winInfo: Grid.WinInfo = Grid.emptyWinInfo()
    
    @Published var locked: Bool = false
    @Published var resetCountdown: Double = 0
    @Published var resetCountdownFull: Double = 0 {
        didSet {
            resetCountdown = resetCountdownFull
        }
    }
    
    @Published var AIPlayer: Grid.State = .none
    @Published var AIDifficulty: AIState = .noob
    
    @Published var multiplayerEnabled = false
    @Published var settingsOpened = false
    
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
        self.grid.reset()
        player = .cross
        winInfo = Grid.emptyWinInfo()
    }
    
    public func reset(_ option: resetOption) {
        switch option {
            case .grid:
                resetGrid()
                AIProcess()
            case .score: resetScore()
        }
    }
    
    public func processTurn() {
        winInfo = grid.check()
        if grid.isFull() || winInfo.winner != .none {
            switch winInfo.winner {
                case .cross: crossScore += 1
                case .nought: noughtScore += 1
                case .none: break
            }
            
            player = .none
            locked = true
            resetCountdownFull = 2.5
            
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
                locked = false
                AIProcess()
            }
        }
        
        self.togglePlayer()
        AIProcess()
    }
    
    /// Toggles `player`
    public func togglePlayer() { player = player == .cross ? .nought : .cross }
    
    /// (*not*) ARTIFICIAL INTELLIGENCE
    func AIProcess() {
        if locked == true { return }
        if AIPlayer == .none { return }
        if player != AIPlayer { return }
        
        locked = true
        resetCountdownFull = AIDifficulty == .expert ? 0.7 : 0.3
        
        let _ = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [self] timer in
            resetCountdown -= 0.01
            if resetCountdown <= 0 {
                timer.invalidate()
                resetCountdown = 0
                return
            }
        }
        
        let _ = Timer.scheduledTimer(withTimeInterval: resetCountdownFull * 0.4, repeats: false) { [self] _ in
            DispatchQueue.main.async { [self] in
                switch AIDifficulty {
                    case .noob: noobTurn()
                    case .expert: expertTurn()
                }
                
                processTurn()
                locked = false
            }
        }
    }
    
    private func noobTurn() {
        if grid.isFull() { return }
        
        while true {
            let i: Int = Int.random(in: 0...2)
            let j: Int = Int.random(in: 0...2)
            if grid[i, j] == .none {
                grid[i, j] = player
                return
            }
        }
    }
    
    /// Uses minimax to completely over-engineer tic-tac-toe.
    private func expertTurn() {
        if grid.isFull() { return }
        
        // Cheating: Pre-programme first move as cross.
        if grid.isEmpty() && player == .cross {
            grid[0, 0] = player
            return
        }
        
        var bestScore = -1000
        var bestMove = (-1, -1)
        
        for row in 0..<3 {
            for column in 0..<3 {
                if grid[row, column] == .none {
                    grid[row, column] = player
                    let moveScore = minimax(board: grid, isMax: false, player: player, depth: 0, alpha: -1000, beta: 1000)
                    grid[row, column] = .none
                    if moveScore > bestScore {
                        bestScore = moveScore
                        bestMove = (row, column)
                    }
                }
            }
        }
        
        if bestMove != (-1, -1) {
            grid[bestMove.0, bestMove.1] = player
        }
    }
    
    private func minimax(board: Grid, isMax: Bool, player: Grid.State, depth: Int, alpha: Int, beta: Int) -> Int {
        let winner = board.check().winner
        if winner != .none { return board.check().winner == player ? 10 - depth : -10 + depth}
        if board.isFull() { return 0 }
        
        var bestScore = 1000 * (isMax ? -1 : 1)
        
        outerLoop: for row in 0..<3 {
            for column in 0..<3 {
                if board[row, column] == .none {
                    board[row, column] = isMax ? player : player.other()
                    let minimaxResult = minimax(board: board, isMax: !isMax, player: player, depth: depth + 1, alpha: alpha, beta: beta)
                    bestScore = isMax ? max(bestScore, minimaxResult) : min(bestScore, minimaxResult)
                    if (!isMax ? min(beta, bestScore) : beta) <= (isMax ? max(alpha, bestScore) : alpha) { break outerLoop }
                    board[row, column] = .none
                }
            }
        }
        
        return bestScore
    }
    
    /// Singleton
    static let global = Tesseract()
    private init() {}
}
