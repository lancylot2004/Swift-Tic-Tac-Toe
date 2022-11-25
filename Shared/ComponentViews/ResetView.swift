//
//  ResetView.swift
//  Simple TicTacToe
//
//  Created by lancylot2004 on 07/04/2022.
//

import SwiftUI

struct ResetView: View {
    @StateObject private var tess: Tesseract = Tesseract.global
    
    private var text: String
    private var direction: LayoutDirection
    private var image: String
    private var call: resetOption
    
    @GestureState private var ext: CGFloat = .zero
    private var extTrack: CGFloat = .zero
    
    init(_ text: String, _ direction: LayoutDirection, _ image: String, _ call: resetOption) {
        self.text = text
        self.direction = direction
        self.image = image
        self.call = call
    }
    
    private func processTap() {
        tess.haptic()
        if !tess.locked {
            tess.reset(call)
        }
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 150, height: 35)
                .foregroundColor(.primary.opacity(0.05))
                .cornerRadius(10)
            
            HStack(spacing: 0) {
                ZStack {
                    Rectangle()
                        .frame(width: 115 + ext, height: 35)
                        .foregroundColor(.primary.opacity(0.1 + (ext / 500)))
                        .cornerRadius(10)
                        .gesture(DragGesture(minimumDistance: 0)
                        .updating(self.$ext) { value, state, _ in
                            let modifier: CGFloat = direction == .leftToRight ? 1 : -1
                            let tempWidth: CGFloat = value.translation.width * modifier * 1.5
                            
                            
                            switch tempWidth {
                                case ..<0: state = 0
                                case 0...35: state = tempWidth * modifier
                                default: state = 35 * modifier
                            }
                            
                            if direction == .rightToLeft { state = -state }
                        }
                        .onEnded({ value in
                            let modifier: CGFloat = direction == .leftToRight ? 1 : -1
                            let tempWidth: CGFloat = value.translation.width * modifier
                            if tempWidth > 70 { processTap() }
                        })
                        )
                        .animation(.spring(response: 0.2, dampingFraction: 0.4, blendDuration: 1))
                }
                
                Spacer().frame(minWidth: 0)
            }.environment(\.layoutDirection, self.direction)
            
            // Text + Symbol
            HStack(spacing: 0) {
                Text(String(self.text))
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .frame(width: 115, height: 35)
                
                Image(systemName: image)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .accentColor(.primary)
                    .frame(width: 35, height: 35)
                    .onTapGesture { processTap() }
                    .rotationEffect(Angle(degrees: 2 * self.ext))
                    .animation(.spring(response: 0.2, dampingFraction: 0.4, blendDuration: 1))
            }.environment(\.layoutDirection, self.direction)
        }
        .frame(width: 150, height: 20)
    }
}

struct ResetView_Previews: PreviewProvider {
    static var previews: some View {
        ResetView("Reset Board", .leftToRight, "goforward", .grid)
    }
}
