//
//  Sounds.swift
//  LiesNLegendsOfficial
//
//  Created by Derald Blessman on 2/25/25.
//

import SwiftUI
import AVFoundation

var player : AVAudioPlayer!

struct MusicView: View{
    @State private var isPlaying = false
//Playsound Function
//func playSound(){
//guard let url = Bundle.main.url(forResource: "GAME MUSIC", withExtension: "mp3") else{
//print("url not found")
//return
//}
//do{
//try AVAudioSession.sharedInstance().setActive(true)
//
//        if let player = player, player.isPlaying {
//            player.stop()
//            self.isPlaying = false
//        } else {
//
//            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
//            player!.numberOfLoops = -1
//            player!.play()
//            self.isPlaying = true
//        }
//    } catch let error as NSError {
//        print("error: \(error.localizedDescription)")
//    }
//}

var body: some View {
    VStack {
        
    }
   .padding()
}
}

struct Haptics___Sound: View {
// declare an audio player at the view level
@State private var player: AVAudioPlayer?

var body: some View {
    Button("Tap Me") {
        
        playSound(named: "CARD FLIP")
        // Create haptic generator
        let generator = UIImpactFeedbackGenerator(style: .medium)
        // trigger haptic feedback
        generator.impactOccurred()
    }
}
    
    func playSound(named soundName: String){
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else{
            print("Sound file not found")
            return
        }
        do{
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        }catch {
                        print("Error playing sound \(error.localizedDescription) ")
                    }
                
    }
}
#Preview {
Haptics___Sound()
}
