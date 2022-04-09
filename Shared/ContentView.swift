//
//  ContentView.swift
//  Shared
//
//  Created by lancylot2004 on 04/04/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var tess: Tesseract = Tesseract.global
    
    @State var locked: Bool = false
    @State var indicatorWidth: CGFloat = const.gameWidth
    @State var indicatorColour: Color = .clear

    var body: some View {
        ZStack{
            VStack(spacing: 0) {
                // Reset Indicator
                HStack {
                    Rectangle()
                        .frame(width: indicatorWidth, height: const.indicatorHeight)
                        .foregroundColor(indicatorColour)
                        .cornerRadius(const.cornerRadius)
                        .onChange(of: tess.resetCountdown) { newValue in
                            indicatorWidth = const.gameWidth * (newValue == 0 ? 1 : (tess.resetCountdown / tess.resetCountdownFull))
                            indicatorColour = tess.resetCountdown == 0 ? .clear : const.indicatorColour
                        }
                    
                    Spacer().frame(minWidth: 0)
                }.frame(width: const.gameWidth)
                
                Spacer().frame(height: const.gameSpacing)
                
                // Game Board
                ZStack {
                    Rectangle()
                        .frame(width: const.gameWidth, height: const.gameWidth)
                        .foregroundColor(const.backgroundColour)
                        .cornerRadius(const.cornerRadius)
                    
                    ZStack {
                        GeometryReader { geometry in
                            if tess.winningPair != nil && tess.winning {
                                Path { highlight in
                                    let rect = geometry.frame(in: CoordinateSpace.named("grid"))
                                    // a + bx
                                    let a: CGFloat = (const.squareSize / 2)
                                    let b: CGFloat = const.squareSize + (const.gridSpacing * 3)
                                    highlight.move(to: CGPoint(
                                        x: rect.minX + a + b * CGFloat(tess.winningPair![1]),
                                        y: rect.minY + a + b * CGFloat(tess.winningPair![0]))
                                    )

                                    highlight.addLine(to: CGPoint(
                                        x: rect.minX + a + b * CGFloat(tess.winningPair![3]),
                                        y: rect.minY + a + b * CGFloat(tess.winningPair![2]))
                                    )
                                }
                                .stroke(style: StrokeStyle(lineWidth: const.squareSize, lineCap: .round))
                                .foregroundColor(const.winHighlightColour)
                            }
                        }
                        .coordinateSpace(name: "grid")
                        .frame(width: const.gridSize - const.gameSpacing, height: const.gridSize - const.gameSpacing)
                        
                        VStack {
                            Spacer()
                            Capsule()
                                .frame(width: const.gridSize, height: const.gridSpacing)
                            Spacer()
                            Capsule()
                                .frame(width: const.gridSize, height: const.gridSpacing)
                            Spacer()
                        }.frame(height: const.gridSize, alignment: .center)
                        
                        HStack {
                            Spacer()
                            Capsule()
                                .frame(width: const.gridSpacing, height: const.gridSize)
                            Spacer()
                            Capsule()
                                .frame(width: const.gridSpacing, height: const.gridSize)
                            Spacer()
                        }.frame(width: const.gridSize, alignment: .center)
                        
                        VStack(spacing: const.gridSpacing * 3) {
                            ForEach(0..<3, id: \.self) {i in
                                HStack(spacing: 15) {
                                    ForEach(0..<3, id: \.self) {j in
                                        TicTacView(i, j)
                                    }
                                }.frame(width: const.gridSize - const.gameSpacing)
                            }
                        }.frame(width: const.gridSize - const.gameSpacing, height: const.gridSize - const.gameSpacing)
                    }.frame(width: const.gridSize, height: const.gridSize)
                }
                
                Spacer().frame(height: const.gameSpacing)
                
                // Score Board
                HStack(spacing: const.gameSpacing) {
                    PlayerScoreView(.cross)
                    PlayerScoreView(.nought)
                }.frame(height: const.scoreViewHeight)
                
                Spacer().frame(height: const.gameSpacing)
                
                // Resets
                HStack(spacing: const.gameSpacing) {
                    ResetView("Reset Board", .leftToRight, "goforward", .grid)
                    ResetView("Reset Score", .rightToLeft, "gobackward", .score)
                }.frame(height: const.resetViewHeight)
                
                Spacer().frame(height: const.gameSpacing)
                
                // AI Controls
                ZStack {
                    Rectangle()
                        .foregroundColor(const.backgroundColour)
                        .cornerRadius(const.cornerRadius)
                    
                    HStack(spacing: 0) {
                        Spacer().frame(width: 5)
                        
                        Text("\"AI\"")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .frame(width: 40)
                        
                        Spacer().frame(width: 5)
                            
                        ZStack {
                            HStack(spacing: 0) {
                                Rectangle()
                                    .foregroundColor(tess.AIPlayer == .cross ? const.highlightColour : const.foregroundColour)
                                    .frame(width: 36, height: 35)
                                    .cornerRadius(10, corners: [.topLeft, .bottomLeft])
                                    .transition(const.transition)
                                
                                Spacer().frame(width: 3)
                                
                                Rectangle()
                                    .foregroundColor(tess.AIPlayer == .nought ? const.highlightColour : const.foregroundColour)
                                    .frame(width: 36, height: 35)
                                    .cornerRadius(10, corners: [.topRight, .bottomRight])
                                    .transition(const.transition)
                            }.frame(width: 72)
                            
                            
                            HStack(spacing: 0) {
                                ZStack{
                                    Capsule()
                                        .frame(width: 30, height: 3, alignment: .center)
                                        .rotationEffect(Angle(degrees: 45))
                                        
                                    Capsule()
                                        .frame(width: 30, height: 3, alignment: .center)
                                        .rotationEffect(Angle(degrees: -45))
                                }
                                .frame(width: 35, height: 35)
                                .onTapGesture {
                                    withAnimation {
                                        tess.AIPlayer = (tess.AIPlayer == .none || tess.AIPlayer == .nought) ? .cross : .none
                                    }
                            
                                    tess.AIProcess()
                                }
                                
                                Rectangle()
                                    .frame(width: 3, height: 35)
                                    .foregroundColor(.primary.opacity(0.3))
                                
                                Circle()
                                    .strokeBorder(.primary, lineWidth: 3)
                                    .frame(width: 35, height: 28, alignment: .center)
                                    .onTapGesture {
                                        withAnimation {
                                            tess.AIPlayer = (tess.AIPlayer == .none || tess.AIPlayer == .cross) ? .nought : .none
                                        }
                                        
                                        tess.AIProcess()
                                    }
                            }
                        }
                        
                        Spacer().frame(width: const.gameSpacing)
                        
                        ZStack {
                            HStack(spacing: 0) {
                                Rectangle()
                                    .foregroundColor(tess.AIDifficulty == .noob ? const.highlightColour : const.foregroundColour)
                                    .frame(width: 56, height: 35)
                                    .cornerRadius(const.cornerRadius, corners: [.topLeft, .bottomLeft])
                                    .transition(const.transition)
                                
                                Spacer().frame(width: 3)
                                
                                Rectangle()
                                    .foregroundColor(tess.AIDifficulty == .human ? const.highlightColour : const.foregroundColour)
                                    .frame(width: 56, height: 35)
                                    .transition(const.transition)
                                
                                Spacer().frame(width: 3)
                                
                                Rectangle()
                                    .foregroundColor(tess.AIDifficulty == .ai ? const.highlightColour : const.foregroundColour)
                                    .frame(width: 56, height: 35)
                                    .cornerRadius(const.cornerRadius, corners: [.topRight, .bottomRight])
                                    .transition(const.transition)
                            }.frame(width: 173)
                            
                            HStack(spacing: 0) {
                                Text("Noob")
                                    .font(.system(size: 15, weight: .bold, design: .rounded))
                                    .frame(width: 56, height: 35)
                                    .minimumScaleFactor(0.1)
                                    .onTapGesture { withAnimation { tess.AIDifficulty = .noob } }
                                
                                Rectangle()
                                    .frame(width: 3, height: 35)
                                    .foregroundColor(.primary.opacity(0.3))
                                
                                Text("Human")
                                    .font(.system(size: 15, weight: .bold, design: .rounded))
                                    .frame(width: 56, height: 35)
                                    .minimumScaleFactor(0.1)
                                    .onTapGesture { withAnimation { tess.AIDifficulty = .human } }
                                
                                Rectangle()
                                    .frame(width: 3, height: 35)
                                    .foregroundColor(.primary.opacity(0.3))
                                
                                Text("\"AI\"")
                                    .font(.system(size: 15, weight: .bold, design: .rounded))
                                    .frame(width: 56, height: 35)
                                    .minimumScaleFactor(0.1)
                                    .onTapGesture { withAnimation { tess.AIDifficulty = .ai } }
                            }.frame(width: 173)
                        }
                    }
                    
                    Spacer().frame(width: 5)
                }.frame(width: const.gameWidth, height: 40)
            }
            
            // Locking Cover
            if locked {
                Rectangle()
                    .frame(width: .infinity, height: .infinity)
                    .foregroundColor(.primary.opacity(0))
                    .onChange(of: tess.locked) { newValue in
                        self.locked = newValue
                    }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
