//
//  ContentView.swift
//  Shared
//
//  Created by lancylot2004 on 04/04/2022.
//

import SwiftUI

let standardSize: CGFloat = 265

struct ContentView: View {
    @StateObject private var tess: Tesseract = Tesseract.global
    
    @State var locked: Bool = false
    @State var indicatorWidth: CGFloat = 310
    @State var indicatorColour: Color = .clear

    var body: some View {
        ZStack{
            VStack(spacing: 0) {
                // Reset Indicator
                HStack {
                    Rectangle()
                        .frame(width: indicatorWidth, height: 10)
                        .foregroundColor(indicatorColour)
                        .cornerRadius(10)
                        .onChange(of: tess.resetCountdown) { newValue in
                            indicatorWidth = 310 * (newValue == 0 ? 1 : (tess.resetCountdown / tess.resetCountdownFull))
                            indicatorColour = tess.resetCountdown == 0 ? .clear : .green.opacity(0.9)
                        }
                    
                    Spacer().frame(minWidth: 0)
                }.frame(width: 310, alignment: .center)
                
                Spacer().frame(height: 10)
                
                // Game Board
                ZStack {
                    Rectangle()
                        .frame(width: 310, height: 310)
                        .foregroundColor(.primary.opacity(0.05))
                        .cornerRadius(10)
                    
                    ZStack {
                        GeometryReader { geometry in
                            if tess.winningPair != nil && tess.winning {
                                Path { highlight in
                                    let rect = geometry.frame(in: CoordinateSpace.named("grid"))
                                    highlight.move(to: CGPoint(
                                        x: rect.minX + 37.5 + CGFloat(90 * tess.winningPair![1]),
                                        y: rect.minY + 37.5 + CGFloat(90 * tess.winningPair![0]))
                                    )

                                    highlight.addLine(to: CGPoint(
                                        x: rect.minX + 37.5 + CGFloat(90 * tess.winningPair![3]),
                                        y: rect.minY + 37.5 + CGFloat(90 * tess.winningPair![2]))
                                    )
                                }
                                .stroke(style: StrokeStyle(lineWidth: 75, lineCap: .round))
                                .foregroundColor(.green.opacity(0.7))
                            }
                        }
                        .coordinateSpace(name: "grid")
                        .frame(width: standardSize - 10, height: standardSize - 10)
                        
                        VStack {
                            Spacer()
                            Capsule()
                                .frame(width: standardSize, height: 5, alignment: .center)
                            Spacer()
                            Capsule()
                                .frame(width: standardSize, height: 5)
                            Spacer()
                        }.frame(height: standardSize, alignment: .center)
                        
                        HStack {
                            Spacer()
                            Capsule()
                                .frame(width: 5, height: standardSize)
                            Spacer()
                            Capsule()
                                .frame(width: 5, height: standardSize)
                            Spacer()
                        }.frame(width: standardSize, alignment: .center)
                        
                        VStack(spacing: 15) {
                            ForEach(0..<3, id: \.self) {i in
                                HStack(spacing: 15) {
                                    ForEach(0..<3, id: \.self) {j in
                                        TicTacView(i, j)
                                    }
                                }.frame(width: standardSize - 10)
                            }
                        }.frame(width: standardSize - 10, height: standardSize - 10)
                    }.frame(width: standardSize, height: standardSize)
                }
                
                Spacer().frame(height: 5)
                
                // Score Board
                HStack(spacing: 10) {
                    PlayerScoreView(.cross)
                    PlayerScoreView(.nought)
                }.frame(height: 80)
                
                Spacer().frame(height: 10)
                
                // Resets
                HStack(spacing: 10) {
                    ResetView("Reset Board", .leftToRight, "goforward", .grid)
                    ResetView("Reset Score", .rightToLeft, "gobackward", .score)
                }.frame(height: 35)
                
                Spacer().frame(height: 10)
                
                // AI Controls
                ZStack {
                    Rectangle()
                        .foregroundColor(.primary.opacity(0.05))
                        .cornerRadius(10)
                    
                    HStack(spacing: 0) {
                        Spacer().frame(width: 5)
                        
                        Text("\"AI\"")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .frame(width: 40)
                        
                        Spacer().frame(width: 5)
                            
                        ZStack {
                            HStack(spacing: 0) {
                                Rectangle()
                                    .foregroundColor(tess.AIPlayer == .cross ? .cyan.opacity(0.7) : .primary.opacity(0.1))
                                    .frame(width: 36, height: 35)
                                    .cornerRadius(10, corners: [.topLeft, .bottomLeft])
                                    .transition(tess.constTransition)
                                
                                Spacer().frame(width: 3)
                                
                                Rectangle()
                                    .foregroundColor(tess.AIPlayer == .nought ? .cyan.opacity(0.7) : .primary.opacity(0.1))
                                    .frame(width: 36, height: 35)
                                    .cornerRadius(10, corners: [.topRight, .bottomRight])
                                    .transition(tess.constTransition)
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
                        
                        Spacer().frame(width: 10)
                        
                        ZStack {
                            HStack(spacing: 0) {
                                Rectangle()
                                    .foregroundColor(tess.AIDifficulty == .noob ? .cyan.opacity(0.7) : .primary.opacity(0.1))
                                    .frame(width: 56, height: 35)
                                    .cornerRadius(10, corners: [.topLeft, .bottomLeft])
                                    .transition(tess.constTransition)
                                
                                Spacer().frame(width: 3)
                                
                                Rectangle()
                                    .foregroundColor(tess.AIDifficulty == .human ? .cyan.opacity(0.7) : .primary.opacity(0.1))
                                    .frame(width: 56, height: 35)
                                    .transition(tess.constTransition)
                                
                                Spacer().frame(width: 3)
                                
                                Rectangle()
                                    .foregroundColor(tess.AIDifficulty == .ai ? .cyan.opacity(0.7) : .primary.opacity(0.1))
                                    .frame(width: 56, height: 35)
                                    .cornerRadius(10, corners: [.topRight, .bottomRight])
                                    .transition(tess.constTransition)
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
                }.frame(width: 310, height: 40)
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
