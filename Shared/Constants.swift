//
//  Constants.swift
//  Simple TicTacToe
//
//  Created by lancylot2004 on 09/04/2022.
//

import SwiftUI

/// **Constants**
class const {
    // Transitions
    static let transition: AnyTransition =
        .opacity.animation(.easeInOut(duration: 0.1))
        .combined(with: .scale.animation(.easeInOut(duration: 0.1)))
    
    // Dimensions
    
    
    static let gameWidth: CGFloat = 310
    static let gameSpacing: CGFloat = 10
    static let indicatorHeight: CGFloat = gameSpacing
    
    static let gridSize: CGFloat = 265
    static let gridSpacing: CGFloat = 5
    static let squareSize: CGFloat = 75
    
    static let cornerRadius: CGFloat = 10
    
    static let scoreViewHeight: CGFloat = 80
    static let resetViewHeight: CGFloat = 35
    
    // Colours
    static let indicatorColour: Color = .green.opacity(0.9)
    static let highlightColour: Color = .cyan.opacity(0.7)
    static let winHighlightColour: Color = .green.opacity(0.7)
    
    static let backgroundColour: Color = .primary.opacity(0.05)
    static let foregroundColour: Color = .primary.opacity(0.1)
}
