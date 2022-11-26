//
//  PlayerScoreView.swift
//  Simple TicTacToe
//
//  Created by lancylot2004 on 07/04/2022.
//

import SwiftUI

struct PlayerScoreView: View {
    @StateObject private var tess: Tesseract = Tesseract.global
    
    private var state: Grid.State
    @State private var blinkColour: Color = .clear
    @State private var indicatorColour: Color
    
    init(_ state: Grid.State) {
        self.state = state
        self.indicatorColour = state == Tesseract.global.player ? .cyan.opacity(0.7) : .clear
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 150, height: 70)
                .foregroundColor(blinkColour)
                .cornerRadius(10)
                .onChange(of: self.state == .cross ? tess.crossScore : tess.noughtScore) { _ in
                    withAnimation {
                        blinkColour = .green.opacity(0.5)
                        let _ = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { _ in withAnimation { blinkColour = .clear } }
                    }
                }
            
            Rectangle()
                .frame(width: 150, height: 70)
                .foregroundColor(indicatorColour)
                .cornerRadius(10)
                .onChange(of: tess.player) { newValue in
                    withAnimation {
                        switch tess.player {
                            case .cross, .nought: indicatorColour = self.state == tess.player ? .cyan.opacity(0.7) : .clear
                            case .none: indicatorColour = .clear
                        }
                    }
                }
            
            Rectangle()
                .frame(width: 150, height: 70)
                .foregroundColor(.primary.opacity(0.05))
                .cornerRadius(10)
            
            HStack(spacing: 0) {
                ZStack {
                    Text(String(self.state == .cross ? tess.crossScore : tess.noughtScore))
                        .font(.system(size: 65, weight: .bold, design: .rounded))
                        .minimumScaleFactor(0.1)
                    
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
