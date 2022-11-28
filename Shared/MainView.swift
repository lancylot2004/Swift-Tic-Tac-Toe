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
                VStack(spacing: 0) {
                    // Reset Indicator
                    IndicatorView()
                    
                    Spacer().frame(height: Const.Dim.LSpacing)
                    
                    // Game Board
                    BoardView()
                    
                    Spacer().frame(height: Const.Dim.LSpacing)
                }
                
                // Score Board
                HStack(spacing: Const.Dim.LSpacing) {
                    PlayerScoreView(.cross)
                    PlayerScoreView(.nought)
                }.frame(height: Const.Dim.LViewHeight)
                
                Spacer().frame(height: Const.Dim.LSpacing)
                
                // Resets
                HStack(spacing: Const.Dim.LSpacing) {
                    ResetView(String(localized: "Reset Board"), .leftToRight, "goforward", .grid)
                    ResetView(String(localized: "Reset Score"), .rightToLeft, "gobackward", .score)
                }.frame(height: Const.Dim.SViewHeight)
                
                Spacer().frame(height: Const.Dim.LSpacing)
                
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
