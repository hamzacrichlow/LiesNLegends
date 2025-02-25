//
//  LiesNLegendsOfficialApp.swift
//  LiesNLegendsOfficial
//
//  Created by Derald Blessman on 2/25/25.
//

import SwiftUI
import AVFoundation


@main
struct LiesNLegendsApp: App {
    @State private var player : AVAudioPlayer?
    @State private var isPlaying : Bool = false
    
    var body: some Scene {
        WindowGroup {
            ZStack{
                StartScreen()
                    .modelContainer(for: Player.self, inMemory: true)
                    .onAppear{
                        playSound()
                    }
               
                
            }
        }
        
    }
    func playSound(){
    guard let url = Bundle.main.url(forResource: "GAME MUSIC", withExtension: "mp3") else{
    print("url not found")
    return
    }
    do{
    try AVAudioSession.sharedInstance().setActive(true)

            if let player = player, player.isPlaying {
                player.stop()
                self.isPlaying = false
            } else {
                
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                player!.numberOfLoops = -1
                player!.play()
                self.isPlaying = true
            }
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
}

