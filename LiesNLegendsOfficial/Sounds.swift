import SwiftUI
import AVFoundation

class AudioManager: ObservableObject {
    @Published var isPlaying = true
    var player: AVAudioPlayer?

    init() {
        startBackgroundMusic()
    }

    private func startBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "GAME MUSIC", withExtension: "mp3") else {
            print("Music file not found")
            return
        }

        do {
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.volume = 0.3
            player?.play()
        } catch {
            print("Error starting music: \(error.localizedDescription)")
        }
    }

    func toggleMusic() {
        guard let player = player else { return }
        isPlaying.toggle()
        
        if isPlaying {
            player.play()
        } else {
            player.pause()
        }
    }
}

struct Haptics___Sound: View {
    @State private var player: AVAudioPlayer?

    var body: some View {
        Button("Tap Me") {
            playSound(named: "CARD FLIP")

            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
        .padding()
    }

    private func playSound(named soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("Sound file not found")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Error playing sound \(error.localizedDescription)")
        }
    }
}

#Preview {
    Haptics___Sound()
}
