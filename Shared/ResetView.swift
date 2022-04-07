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
    
    init(_ text: String, _ direction: LayoutDirection, _ image: String, _ call: resetOption) {
        self.text = text
        self.direction = direction
        self.image = image
        self.call = call
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 150, height: 35)
                .foregroundColor(.primary.opacity(0.05))
                .cornerRadius(10)
            
            HStack(spacing: 0) {
                ZStack {
                    Text(String(self.text))
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                    
                    Rectangle()
                        .frame(width: 115, height:35)
                        .foregroundColor(.primary.opacity(0.1))
                        .cornerRadius(10)
                }
                
                Button {
                    tess.reset(call)
                } label: {
                    Image(systemName: image)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .frame(width: 35, height: 35)
                }

                
            }.environment(\.layoutDirection, self.direction)
        }.frame(width: 150, height: 20)
    }
}

struct ResetView_Previews: PreviewProvider {
    static var previews: some View {
        ResetView("Reset Board", .leftToRight, "goforward", .grid)
    }
}
