//
//  TicTacToeApp.swift
//  Shared
//
//  Created by lancylot2004 on 04/04/2022.
//

import SwiftUI

@main
struct TicTacToeApp: App {
    var body: some Scene {
        #if os(iOS)
        WindowGroup {
            MainView()
                .if(UIDevice.current.userInterfaceIdiom == .pad) { mainView in
                    mainView.scaleEffect(1.3)
                }
        }
        #elseif os(macOS)
        WindowGroup {
            MainView()
                .frame(width: Const.Dim.GameWidth, height: 4 * Const.Dim.LSpacing + Const.Dim.GridSize + Const.Dim.LViewHeight + 2 * Const.Dim.SViewHeight)
                .fixedSize()
        }.windowStyle(.hiddenTitleBar)
        #endif
    }
}
