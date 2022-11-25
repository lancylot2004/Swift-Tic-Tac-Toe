//
//  ContentView.swift
//  Shared
//
//  Created by lancylot2004 on 04/04/2022.
//

import SwiftUI

struct MainView: View {
    @StateObject private var tess: Tesseract = Tesseract.global
    
    @State var locked: Bool = false

    var body: some View {
        ZStack{
            VStack(spacing: 0) {
                // Reset Indicator
                IndicatorView()
                
                Spacer().frame(height: Const.Dim.GameSpacing)
                
                // Game Board
                BoardView()
                
                Spacer().frame(height: Const.Dim.GameSpacing)
                
                // Score Board
                HStack(spacing: Const.Dim.GameSpacing) {
                    PlayerScoreView(.cross)
                    PlayerScoreView(.nought)
                }.frame(height: Const.Dim.LViewHeight)
                
                Spacer().frame(height: Const.Dim.GameSpacing)
                
                // Resets
                HStack(spacing: Const.Dim.GameSpacing) {
                    ResetView("Reset Board", .leftToRight, "goforward", .grid)
                    ResetView("Reset Score", .rightToLeft, "gobackward", .score)
                }.frame(height: Const.Dim.SViewHeight)
                
                Spacer().frame(height: Const.Dim.GameSpacing)
                
                // AI Controls
                ComputerSettingView()
            }
            
            // Locking Cover
            if self.locked {
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
            MainView()
        }
    }
}
