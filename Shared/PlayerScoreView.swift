//
//  PlayerScoreView.swift
//  Simple TicTacToe
//
//  Created by lancylot2004 on 07/04/2022.
//

import SwiftUI

struct PlayerScoreView: View {
    @StateObject private var tess: Tesseract = Tesseract.global
    private var state: squareState
    
    init(_ state: squareState) { self.state = state }
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 150, height: 70)
                .foregroundColor(.primary.opacity(0.05))
                .cornerRadius(10)
            
            HStack(spacing: 0) {
                ZStack {
                    Text(String(tess.crossScore))
                        .font(.system(size: 65, weight: .bold, design: .rounded))
                    
                    Rectangle()
                        .frame(width: 80, height: 70)
                        .foregroundColor(.primary.opacity(0.1))
                        .cornerRadius(10)
                }
                
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
                        .padding(5)
                }
            }.environment(\.layoutDirection, state == .cross ? .leftToRight : .rightToLeft)
        }.frame(width: 150, height: 80)
    }
}

struct PlayerScoreView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerScoreView(.nought)
    }
}