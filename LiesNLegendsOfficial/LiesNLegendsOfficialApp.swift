//
//  LiesNLegendsOfficialApp.swift
//  LiesNLegendsOfficial
//
//  Created by Derald Blessman on 2/25/25.
//
import SwiftUI

@main
struct LiesNLegendsApp: App {
    @StateObject private var audioManager = AudioManager()

    var body: some Scene {
        WindowGroup {
            StartScreen()
                .environmentObject(audioManager)
                .modelContainer(for: Player.self, inMemory: true)
                .tint(.primary)
        }
    }
}
