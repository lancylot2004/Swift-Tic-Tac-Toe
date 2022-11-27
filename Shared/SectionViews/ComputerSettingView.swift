//
//  ComputerSettingView.swift
//  Simple TicTacToe (iOS)
//
//  Created by Lancelot Liu on 25/11/2022.
//

import SwiftUI

struct ComputerSettingView: View {
    @StateObject private var tess: Tesseract = Tesseract.global
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Const.Colour.Background)
                .cornerRadius(Const.Dim.CornerRadius)
            
            HStack(spacing: 0) {
                Spacer().frame(width: 5)
                
                Text("Computer Plays: ")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .frame(width: 105)
                
                Spacer().frame(width: 5)
                
                /// Computer-Side Settings
                ZStack {
                    HStack(spacing: 0) {
                        Rectangle()
                            .foregroundColor(tess.AIPlayer == .cross ? Const.Colour.Highlight : Const.Colour.Foreground)
                            .frame(width: 36, height: Const.Dim.SViewHeight)
                            .cornerRadius(Const.Dim.CornerRadius, corners: [.topLeft, .bottomLeft])
                            .transition(Const.Animation.Fade)
                        
                        Spacer().frame(width: 3)
                        
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
                            if tess.locked { return }
                            withAnimation {
                                tess.AIPlayer = (tess.AIPlayer == .none || tess.AIPlayer == .nought) ? .cross : .none
                            }
                    
                            tess.AIProcess()
                        }
                        
                        Rectangle()
                            .frame(width: 3, height: Const.Dim.SViewHeight)
                            .foregroundColor(.primary.opacity(0.3))
                        
                        Circle()
                            .strokeBorder(.primary, lineWidth: 3)
                            .frame(width: 35, height: 28, alignment: .center)
                            .onTapGesture {
                                if tess.locked { return }
                                withAnimation {
                                    tess.AIPlayer = (tess.AIPlayer == .none || tess.AIPlayer == .cross) ? .nought : .none
                                }
                                
                                tess.AIProcess()
                            }
                    }
                }
                
                Spacer().frame(width: Const.Dim.LSpacing)
                
                /// Difficulty Settings
                ZStack {
                    HStack(spacing: 0) {
                        Rectangle()
                            .foregroundColor(tess.AIDifficulty == .noob ? Const.Colour.Highlight : Const.Colour.Foreground)
                            .frame(width: 48, height: Const.Dim.SViewHeight)
                            .cornerRadius(Const.Dim.CornerRadius, corners: [.topLeft, .bottomLeft])
                            .transition(Const.Animation.Fade)
                        
                        Spacer().frame(width: Const.Dim.SSpacing)
                        
                        Rectangle()
                            .foregroundColor(tess.AIDifficulty == .expert ? Const.Colour.Highlight : Const.Colour.Foreground)
                            .frame(width: 48, height: Const.Dim.SViewHeight)
                            .cornerRadius(Const.Dim.CornerRadius, corners: [.topRight, .bottomRight])
                            .transition(Const.Animation.Fade)
                    }.frame(width: 100)
                    
                    HStack(spacing: 0) {
                        Text("Noob")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .frame(width: 45, height: Const.Dim.SViewHeight)
                            .minimumScaleFactor(0.01)
                            .scaledToFill()
                            .lineLimit(1)
                            .padding(.leading, 3)
                            .onTapGesture { withAnimation { tess.AIDifficulty = .noob } }
                        
                        Rectangle()
                            .frame(width: Const.Dim.SSpacing, height: Const.Dim.SViewHeight)
                            .foregroundColor(.primary.opacity(0.3))
                        
                        Text("Expert")
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .frame(width: 45, height: Const.Dim.SViewHeight)
                            .minimumScaleFactor(0.01)
                            .scaledToFill()
                            .lineLimit(1)
                            .padding(.trailing, 3)
                            .onTapGesture { withAnimation { tess.AIDifficulty = .expert } }
                    }.frame(width: 100)
                }
            }
            
            Spacer().frame(width: 5)
        }.frame(width: Const.Dim.GameWidth, height: 40)
    }
}

struct ComputerSettingView_Previews: PreviewProvider {
    static var previews: some View {
        ComputerSettingView()
    }
}
