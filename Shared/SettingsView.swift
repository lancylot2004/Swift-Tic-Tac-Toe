//
//  SettingsView.swift
//  Simple TicTacToe (iOS)
//
//  Created by Lancelot Liu on 26/11/2022.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Spacer().frame(height: Const.Dim.LSpacing * 2)
            
            ZStack {
                Rectangle()
                    .frame(width: Const.Dim.GameWidth, height: 55)
                    .foregroundColor(Const.Colour.Foreground)
                    .cornerRadius(Const.Dim.CornerRadius, corners: .allCorners)
                
                Text("Settings")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
            }
            
            
            Spacer()
        }
        .foregroundColor(.primary)
        .frame(width: Const.Dim.GameWidth + 10 * Const.Dim.LSpacing)
        .background(
            LinearGradient(gradient: Gradient(colors: [
                Const.Colour.Highlight,
                Const.Colour.Background,
                Const.Colour.Foreground,
                Const.Colour.Highlight
            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .opacity(0.5)
        )
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
