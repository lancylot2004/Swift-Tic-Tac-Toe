//
//  CellView.swift
//  Simple TicTacToe
//
//  Created by lancylot2004 on 04/04/2022.
//

import SwiftUI

struct CellView: View {
    @StateObject private var tess: Tesseract = Tesseract.global
    
    private var row: Int
    private var column: Int
    @State private var state: Grid.State
    @State private var locked: Bool = false
    
    init(_ row: Int, _ column: Int) {
        self.row = row
        self.column = column
        self.state = Tesseract.global.grid[row, column]
    }
    
    var body: some View {
        ZStack {
            // Nought or Cross
            if self.state == .cross {
                ZStack {
                    Capsule()
                        .frame(width: 70, height: 5, alignment: .center)
                        .rotationEffect(Angle(degrees: 45))
                        .transition(Const.Animation.Fade)
                        
                    Capsule()
                        .frame(width: 70, height: 5, alignment: .center)
                        .rotationEffect(Angle(degrees: -45))
                        .transition(Const.Animation.Fade)
                }
            } else if self.state == .nought {
                Circle()
                    .strokeBorder(.primary, lineWidth: 5)
                    .frame(width: 60, height: 60, alignment: .center)
                    .transition(Const.Animation.Fade)
            }
            
            // Ze Button
            if !self.locked {
                Rectangle()
                    .frame(width: Const.Dim.SquareSize, height: Const.Dim.SquareSize)
                    .foregroundColor(Const.Colour.Background)
                    .cornerRadius(Const.Dim.CornerRadius)
                    .transition(Const.Animation.Fade)
                    .onTapGesture {
                        if self.locked { return }
                        self.locked = true
                        
                        withAnimation(Animation.easeInOut(duration: 0.3)) {
                            self.state = tess.player
                            tess.grid[row, column] = self.state
                            tess.processTurn()
                        }
                    }
            }
        }
        .frame(width: Const.Dim.SquareSize, height: Const.Dim.SquareSize)
        .onChange(of: tess.grid[row, column]) { _ in
            self.state = tess.grid[row, column]
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
        CellView(0, 0)
    }
}
