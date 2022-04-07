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
    @State private var state: squareState = .none
    
    init(_ row: Int, _ column: Int) {
        self.row = row
        self.column = column
        self.state = Tesseract.global.grid[row][column]
    }
    
    private func squareLocked() -> Bool {
        return self.state == .cross || self.state == .nought
    }
    
    var body: some View {
        ZStack {
            // Nought or Cross
            if self.state == .cross {
                ZStack{
                    Capsule()
                        .frame(width: 70, height: 5, alignment: .center)
                        .rotationEffect(Angle(degrees: 45))
                        
                    Capsule()
                        .frame(width: 70, height: 5, alignment: .center)
                        .rotationEffect(Angle(degrees: -45))
                }
            } else if self.state == .nought {
                Circle()
                    .strokeBorder(.primary, lineWidth: 5)
                    .frame(width: 60, height: 60, alignment: .center)
            }
            
            // Ze Button
            if !squareLocked() {
                Button(action: {
                    switch tess.player {
                    case .cross: self.state = .cross
                    case .nought: self.state = .nought
                    }
                    
                    tess.grid[row][column] = self.state
                    tess.player = tess.player == .cross ? .nought : .cross
                }) {
                    Rectangle()
                        .frame(width: 75, height: 75)
                        .foregroundColor(.primary.opacity(0.05))
                        .cornerRadius(10)
                    
                }
            }
        }
        .frame(width: 75, height: 75)
        .onChange(of: tess.grid[row][column]) { _ in
            self.state = tess.grid[row][column]
        }
    }
}

struct TicTacView_Previews: PreviewProvider {
    static var previews: some View {
        TicTacView(0, 0)
    }
}
