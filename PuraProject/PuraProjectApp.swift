//
//  PuraProjectApp.swift
//  PuraProject
//
//  Created by Jake Gray on 11/29/23.
//

import SwiftUI
import SwiftData

enum AppMode {
    case none
    case swiftUI
    case uikit
}

class AppState: ObservableObject {
    @Published var mode: AppMode = .none
}

@main
struct PuraProjectApp: App {
    @StateObject var state: AppState = AppState()
    @State var showModeSelection: Bool = false
    var body: some Scene {
        WindowGroup {
            currentView
                .environmentObject(state)
                .onShake {
                    if state.mode != .none {
                        showModeSelection = true
                    }
                }
                .confirmationDialog("Switch Modes?", isPresented: $showModeSelection) {
                    Button("Switch Mode to \(state.mode == .swiftUI ? "UIKit" : "SwiftUI")") {
                        withAnimation {
                            if state.mode == .swiftUI {
                                state.mode = .uikit
                            } else {
                                state.mode = .swiftUI
                            }
                        }
                    }
                }
        }
    }
    
    var currentView: some View {
        Group {
            switch state.mode {
            case .none:
                BaseView()
            case .swiftUI:
                SearchView()
            case .uikit:
                UIKitWrapper()
            }
        }
    }
}
