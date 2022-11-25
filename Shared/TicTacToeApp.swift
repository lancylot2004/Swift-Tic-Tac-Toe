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
        WindowGroup {
            MainView()
                .fixedSize()
                .if(UIDevice.current.userInterfaceIdiom == .pad) { mainView in
                    mainView.scaleEffect(1.3)
                }
        }
    }
}
