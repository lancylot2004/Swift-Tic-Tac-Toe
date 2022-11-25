//
//  BoardView.swift
//  Simple TicTacToe (iOS)
//
//  Created by Lancelot Liu on 25/11/2022.
//

import SwiftUI

struct BoardView: View {
    @StateObject private var tess: Tesseract = Tesseract.global
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: Const.Dim.GameWidth, height: Const.Dim.GameWidth)
                .foregroundColor(Const.Colour.Background)
                .cornerRadius(Const.Dim.CornerRadius)
            
            ZStack {
                GeometryReader { geometry in
                    if tess.winning && tess.winningPair.4 != .none {
                        Path { highlight in
                            let rect = geometry.frame(in: CoordinateSpace.named("grid"))
                            // a + bx
                            let a: CGFloat = (Const.Dim.SquareSize / 2)
                            let b: CGFloat = Const.Dim.SquareSize + (Const.Dim.GridSpacing * 3)
                            highlight.move(to: CGPoint(
                                x: rect.minX + a + b * CGFloat(tess.winningPair.1),
                                y: rect.minY + a + b * CGFloat(tess.winningPair.0))
                            )

                            highlight.addLine(to: CGPoint(
                                x: rect.minX + a + b * CGFloat(tess.winningPair.3),
                                y: rect.minY + a + b * CGFloat(tess.winningPair.2))
                            )
                        }
                        .stroke(style: StrokeStyle(lineWidth: Const.Dim.SquareSize, lineCap: .round))
                        .foregroundColor(Const.Colour.WinHighlight)
                    }
                }
                .coordinateSpace(name: "grid")
                .frame(width: Const.Dim.GridSize - Const.Dim.GameSpacing, height: Const.Dim.GridSize - Const.Dim.GameSpacing)
                
                VStack {
                    Spacer()
                    Capsule()
                        .frame(width: Const.Dim.GridSize, height: Const.Dim.GridSpacing)
                    Spacer()
                    Capsule()
                        .frame(width: Const.Dim.GridSize, height: Const.Dim.GridSpacing)
                    Spacer()
                }.frame(height: Const.Dim.GridSize, alignment: .center)
                
                HStack {
                    Spacer()
                    Capsule()
                        .frame(width: Const.Dim.GridSpacing, height: Const.Dim.GridSize)
                    Spacer()
                    Capsule()
                        .frame(width: Const.Dim.GridSpacing, height: Const.Dim.GridSize)
                    Spacer()
                }.frame(width: Const.Dim.GridSize, alignment: .center)
                
                VStack(spacing: Const.Dim.GridSpacing * 3) {
                    ForEach(0..<3, id: \.self) {i in
                        HStack(spacing: 15) {
                            ForEach(0..<3, id: \.self) {j in
                                CellView(i, j)
                            }
                        }.frame(width: Const.Dim.GridSize - Const.Dim.GameSpacing)
                    }
                }.frame(width: Const.Dim.GridSize - Const.Dim.GameSpacing, height: Const.Dim.GridSize - Const.Dim.GameSpacing)
            }.frame(width: Const.Dim.GridSize, height: Const.Dim.GridSize)
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}
