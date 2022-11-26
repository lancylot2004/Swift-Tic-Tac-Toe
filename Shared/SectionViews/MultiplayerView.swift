//
//  MultiplayerView.swift
//  Simple TicTacToe (iOS)
//
//  Created by Lancelot Liu on 26/11/2022.
//

import SwiftUI

struct MultiplayerView: View {
    @StateObject private var tess: Tesseract = Tesseract.global
    
    // @State var opponentName: String = "Ridiculously long name for a soijpiorg"
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Const.Colour.Background)
                .cornerRadius(Const.Dim.CornerRadius)
            
            HStack(spacing: 0) {
                Spacer().frame(width: Const.Dim.MSpacing)
                
                if tess.multiplayerEnabled {
                    HStack {
                        Text("Against: ")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .frame(width: 65)
                            .foregroundColor(.red)
                        Text("asdf")
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .frame(maxWidth: 100, alignment: .leading)
                            .minimumScaleFactor(0.01)
                            .scaledToFill()
                            .lineLimit(1)
                    }
                    
                } else {
                    Text("Singleplayer")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .frame(width: 100)
                        .foregroundColor(.green)
                }
                
                Spacer().frame(minWidth: Const.Dim.LSpacing)
                
                Rectangle()
                    .frame(width: Const.Dim.SSpacing, height: Const.Dim.SViewHeight + 3)
                    .foregroundColor(.primary.opacity(0.3))
                
                Spacer().frame(width: Const.Dim.MSpacing)
                
                /// Computer-Side Settings
                ZStack {
                    HStack(spacing: 0) {
                        Rectangle()
                            .foregroundColor(tess.AIPlayer == .cross ? Const.Colour.Highlight : Const.Colour.Foreground)
                            .frame(width: 36, height: Const.Dim.SViewHeight)
                            .cornerRadius(Const.Dim.CornerRadius, corners: [.topLeft, .bottomLeft])
                            .transition(Const.Animation.Fade)
                        
                        Spacer().frame(width: Const.Dim.SSpacing)
                        
                        Rectangle()
                            .foregroundColor(tess.AIPlayer == .nought ? Const.Colour.Highlight : Const.Colour.Foreground)
                            .frame(width: 36, height: Const.Dim.SViewHeight)
                            .cornerRadius(Const.Dim.CornerRadius, corners: [.topRight, .bottomRight])
                            .transition(Const.Animation.Fade)
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
                        .frame(width: 35, height: Const.Dim.SViewHeight)
                        .onTapGesture {
                            // ask for cross
                        }
                        
                        Rectangle()
                            .frame(width: 3, height: Const.Dim.SViewHeight)
                            .foregroundColor(.primary.opacity(0.3))
                        
                        Circle()
                            .strokeBorder(.primary, lineWidth: 3)
                            .frame(width: 35, height: 28, alignment: .center)
                            .onTapGesture {
                                // ask for nought
                            }
                    }
                }
                
                Spacer().frame(width: Const.Dim.MSpacing)
                
                ZStack {
                    Rectangle()
                        .foregroundColor(Const.Colour.Foreground)
                        .frame(width: 36, height: Const.Dim.SViewHeight)
                        .cornerRadius(Const.Dim.CornerRadius)
                        .transition(Const.Animation.Fade)
                    
                    Image(systemName: "gear")
                        .font(.system(size: 25))
                }.onTapGesture {
                    tess.settingsOpened = true
                }
                
                Spacer().frame(width: Const.Dim.SSpacing)
            }
            
            Spacer().frame(width: Const.Dim.MSpacing)
        }.frame(width: Const.Dim.GameWidth, height: 40)
    }
}

struct MultiplayerView_Previews: PreviewProvider {
    static var previews: some View {
        MultiplayerView()
    }
}
