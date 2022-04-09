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
                            indicatorWidth = 310 * (newValue == 0 ? 1 : (tess.resetCountdown / 3.5))
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
                    }
                }
                
                Spacer().frame(height: 5)
                
                // Score Board
                HStack(spacing: 10) {
                    PlayerScoreView(.cross)
                    PlayerScoreView(.nought)
                }.frame(width: 310, height: 80, alignment: .center)
                
                Spacer().frame(height: 10)
                
                // Resets
                HStack(spacing: 10) {
                    ResetView("Reset Board", .leftToRight, "goforward", .grid)
                    ResetView("Reset Score", .rightToLeft, "gobackward", .score)
                }
            }
            
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
        ContentView()
    }
}
