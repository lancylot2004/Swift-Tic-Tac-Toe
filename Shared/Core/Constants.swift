//
//  Constants.swift
//  Simple TicTacToe
//
//  Created by lancylot2004 on 09/04/2022.
//

import SwiftUI

/// **Constants**
struct Const {
    
    struct Animation {
        static let Fade: AnyTransition =
            .opacity.animation(.easeInOut(duration: 0.1))
            .combined(with: .scale.animation(.easeInOut(duration: 0.1)))
    }
    
    
    /// Dimensions
    struct Dim {
        static let GameWidth: CGFloat = 310
        static let LSpacing: CGFloat = 10
        static let MSpacing: CGFloat = 5
        static let SSpacing: CGFloat = 3
        
        static let GridSize: CGFloat = 265
        static let GridSpacing: CGFloat = 5
        static let SquareSize: CGFloat = 75
        
        static let CornerRadius: CGFloat = 10
        
        static let LViewHeight: CGFloat = 80
        static let SViewHeight: CGFloat = 35
    }
    
    struct Colour {
        static let Indicator: Color = .green.opacity(0.9)
        static let Highlight: Color = .cyan.opacity(0.7)
        static let WinHighlight: Color = .green.opacity(0.7)
        
        static let Background: Color = .primary.opacity(0.05)
        static let Foreground: Color = .primary.opacity(0.1)
    }
}
