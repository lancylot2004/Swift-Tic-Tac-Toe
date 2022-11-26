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
        if winInfo.winner != .none {
            switch winInfo.winner {
                case .cross: crossScore += 1
                case .nought: noughtScore += 1
                case .none: break
            }
            
            player = .none
            locked = true
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
                locked = false
                AIProcess()
            }
        }
        
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
            
            processTurn()
            locked = false
        }
    }
    
    private func noobTurn() {
        while true {
            let i: Int = Int.random(in: 0...2)
            let j: Int = Int.random(in: 0...2)
            if grid[i, j] == .none {
                grid[i, j] = player
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
