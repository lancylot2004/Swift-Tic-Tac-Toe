//
//  IndicatorView.swift
//  Simple TicTacToe (iOS)
//
//  Created by Lancelot Liu on 25/11/2022.
//

import SwiftUI

struct IndicatorView: View {
    @StateObject private var tess: Tesseract = Tesseract.global
    
    @State var indicatorWidth: CGFloat = Const.Dim.GameWidth
    @State var indicatorColour: Color = .clear
    
    var body: some View {
        HStack {
            Rectangle()
                .frame(width: indicatorWidth, height: Const.Dim.LSpacing)
                .foregroundColor(indicatorColour)
                .cornerRadius(Const.Dim.CornerRadius)
                .onChange(of: tess.resetCountdown) { newValue in
                    indicatorWidth = Const.Dim.GameWidth * (newValue == 0 ? 1 : (tess.resetCountdown / tess.resetCountdownFull))
                    indicatorColour = tess.resetCountdown == 0 ? .clear : Const.Colour.Indicator
                }
            
            Spacer().frame(minWidth: 0)
        }.frame(width: Const.Dim.GameWidth)
    }
}

struct IndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorView()
    }
}
