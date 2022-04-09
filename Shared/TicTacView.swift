//
//  TicTacView.swift
//  Simple TicTacToe
//
//  Created by lancylot2004 on 04/04/2022.
//

import SwiftUI

struct TicTacView: View {
    @StateObject private var tess: Tesseract = Tesseract.global
    
    private var row: Int
    private var column: Int
    @State private var state: state = .none
    @State private var locked: Bool = false
    
    init(_ row: Int, _ column: Int) {
        self.row = row
        self.column = column
        self.state = Tesseract.global.grid[row][column]
    }
    
    var body: some View {
        ZStack {
            // Nought or Cross
            if self.state == .cross {
                ZStack {
                    Capsule()
                        .frame(width: 70, height: 5, alignment: .center)
                        .rotationEffect(Angle(degrees: 45))
                        .transition(const.transition)
                        
                    Capsule()
                        .frame(width: 70, height: 5, alignment: .center)
                        .rotationEffect(Angle(degrees: -45))
                        .transition(const.transition)
                }
            } else if self.state == .nought {
                Circle()
                    .strokeBorder(.primary, lineWidth: 5)
                    .frame(width: 60, height: 60, alignment: .center)
                    .transition(const.transition)
            }
            
            // Ze Button
            if !self.locked {
                Rectangle()
                    .frame(width: const.squareSize, height: const.squareSize)
                    .foregroundColor(const.backgroundColour)
                    .cornerRadius(const.cornerRadius)
                    .transition(.opacity.animation(.easeIn(duration: 0.1)).combined(with: .scale.animation(.easeIn(duration: 0.1))))
                    .onTapGesture {
                        self.locked.toggle()
                        withAnimation(Animation.easeInOut(duration: 0.3)) {
                            switch tess.player {
                            case .cross: self.state = .cross
                            case .nought: self.state = .nought
                            case .none: break
                            }
                            
                            tess.grid[row][column] = self.state
                            tess.togglePlayer()
                            tess.checkGrid()
                            tess.AIProcess()
                        }
                    }
            }
        }
        .frame(width: const.squareSize, height: const.squareSize)
        .onChange(of: tess.grid[row][column]) { _ in
            self.state = tess.grid[row][column]
            self.locked = self.state == .cross || self.state == .nought
        }
        .onChange(of: tess.locked) { newValue in
            if newValue {
                self.locked = newValue
            } else {
                self.locked = self.state == .cross || self.state == .nought
            }
        }
    }
}

struct TicTacView_Previews: PreviewProvider {
    static var previews: some View {
        TicTacView(0, 0)
    }
}
