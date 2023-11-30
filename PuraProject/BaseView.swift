//
//  ContentView.swift
//  PuraProject
//
//  Created by Jake Gray on 11/29/23.
//

import SwiftUI
import SwiftData

struct BaseView: View {
    @EnvironmentObject var state: AppState
    
    var body: some View {
        NavigationStack {
            VStack {
               headerView
            }
        }
    }

    var headerView: some View {
        VStack {
            Spacer()
            VStack(spacing: 12) {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
                Text("Welcome to LexiVerse, your ultimate language companion!")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                Text("Select your preferred experience and delve into a world of definitions and synonyms. Let the wordplay begin!")
                    .font(.system(size: 18, design: .rounded))
            }
            Spacer()
            VStack {
                Text("Learn your words in your style")
                    .font(.subheadline)
                Button {
                    state.mode = .swiftUI
                } label: {
                    Label("Swiftly with SwiftUI", systemImage: "figure.run")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(LexiVerseButtonStyle())
                .foregroundStyle(.blue)
                Text("or")
                Button {
                    state.mode = .uikit
                } label: {
                    Label("Classic with UIKit", systemImage: "dumbbell.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(LexiVerseButtonStyle())
                .foregroundStyle(.black)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(RoundedRectangle(cornerRadius: 12).foregroundStyle(Color(UIColor.systemGray5)))
            Spacer()
            Text("You can switch between modes later by shaking your device.")
                .font(.callout)
            Spacer()
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, 12)
    }
}

struct LexiVerseButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.quinary, in: Capsule())
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

#Preview {
    Button(action: { print("Pressed") }) {
        Label("Press Me", systemImage: "star")
    }
    .buttonStyle(LexiVerseButtonStyle())
}

#Preview {
    BaseView()
}
