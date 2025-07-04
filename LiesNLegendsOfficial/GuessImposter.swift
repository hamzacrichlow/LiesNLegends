//
//  Untitled.swift
//  LiesNLegendsOfficial
//
//  Created by Derald Blessman on 2/25/25.
//

import SwiftUI
import AVFoundation

//This is supposed to be the inbetweeen screen before they guess the imposter


// This is the screen before players guess the imposter
struct Question: View {
    let roundPlayers: [Player]
    let imposter: Player
    let legitimates: [Player]
    @EnvironmentObject var audioManager: AudioManager
    @State private var showRules = false
    
    var body: some View {
        NavigationStack {
          
               
                
            VStack(spacing: 20) {
                    Text("""
                    Start 
                    Giving 
                    Hints
                    """)
                    .bold()
                    .font(.system(size: 80))
                    .multilineTextAlignment(.center)
                    .padding(50)
                    
                    Text("When you are done giving hints...")
                        .bold()
                
                NavigationLink {
                    GuessTheImposter(
                        roundPlayers: roundPlayers,
                        imposter: imposter,
                        legitimates: legitimates
                    )
                } label: {
                    GlossyButtonView(text: "START ROUUND", backgroundColor: .primary)
                }
                }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showRules.toggle() }) {
                        Image(systemName: "text.page.badge.magnifyingglass")
                            .font(.title3)
                            .foregroundStyle(.primary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { audioManager.toggleMusic() }) {
                        Image(systemName: audioManager.isPlaying ? "speaker.wave.2" : "speaker.slash")
                            .font(.title2)
                            .foregroundStyle(audioManager.isPlaying ? .primary : .secondary)
                    }
                }
            }
            .sheet(isPresented: $showRules) {
                RulesScreen()
            
           
        }
            }
         
    }
}



struct GuessTheImposter: View {
    @EnvironmentObject var audioManager: AudioManager
    @State private var currentPlayerIndex = 0
    @State private var isFlipped = false
    @State private var selectedImposter: Player?
    @State private var playerSelections: [Player: Player?] = [:]
    @State private var soundPlayer: AVAudioPlayer?
    @State private var showRules = false
    
    let roundPlayers: [Player]
    let imposter: Player
    let legitimates: [Player]
    
    var currentPlayer: Player {
        roundPlayers[currentPlayerIndex]
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.background).ignoresSafeArea()
                
                VStack {
                    Text(currentPlayer.name)
                        .font(.title)
                        .padding()
                    
                    ZStack {
                        Image("CardBack")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 400)
                            .shadow(color: .black, radius: 15, x: 5, y: 5)
                            .opacity(isFlipped ? 0 : 1)
                        
                        if isFlipped {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .frame(width: 300, height: 400)
                                
                                VStack {
                                    Text("Select the Imposter")
                                        .font(.title2)
                                        .padding(.top)
                                    
                                    ForEach(roundPlayers, id: \.id) { player in
                                        Button {
                                            selectedImposter = player
                                            playerSelections[currentPlayer] = player
                                            moveToNextPlayer()
                                        } label: {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 50)
                                                    .stroke(.black, lineWidth: 6)
                                                    .frame(width: 200, height: 40)
                                                    .background(Color.white)
                                                    .cornerRadius(50)
                                                Text(player.name)
                                                    .font(.headline)
                                                    .foregroundColor(.black)
                                                    .background(selectedImposter == player ? Color.gray.opacity(0.5) : Color.clear)
                                                    .cornerRadius(10)
                                            }
                                        }
                                        .padding(2)
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                    
                    Button {
                        playSound(named: "CARD FLIP")
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        flipCard()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.black, lineWidth: 6)
                                .frame(width: 200, height: 40)
                                .background(Color.white)
                                .cornerRadius(50)
                            Text("FLIP CARD")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                    }
                    .padding()
                    
                    if let _ = playerSelections[currentPlayer], currentPlayerIndex < roundPlayers.count - 1 {
                        Button {
                            moveToNextPlayer()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(.black, lineWidth: 6)
                                    .frame(width: 200, height: 40)
                                    .background(Color.white)
                                    .cornerRadius(50)
                                Text("NEXT PLAYER")
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                        }
                        .padding()
                    }
                    
                    if playerSelections.count == roundPlayers.count {
                        NavigationLink {
                            RevealImposterView(
                                imposter: imposter,
                                roundPlayers: roundPlayers,
                                playerSelections: playerSelections
                            )
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(.black, lineWidth: 6)
                                    .frame(width: 200, height: 40)
                                    .background(Color.white)
                                    .cornerRadius(50)
                                Text("REVEAL IMPOSTER")
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Guess the Imposter")
            .navigationBarBackButtonHidden(true)
            .onAppear {
                roundPlayers.forEach { player in
                    playerSelections[player] = nil
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showRules.toggle() } label: {
                        Image(systemName: "text.page.badge.magnifyingglass")
                            .font(.title3)
                            .foregroundStyle(.primary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { audioManager.toggleMusic() } label: {
                        Image(systemName: audioManager.isPlaying ? "speaker.wave.2" : "speaker.slash")
                            .font(.title2)
                            .foregroundStyle(audioManager.isPlaying ? .primary : .secondary)
                    }
                }
            }
            .sheet(isPresented: $showRules) {
                RulesScreen()
            }
        }
    }
    
    func flipCard() {
        withAnimation(.easeInOut(duration: 0.4)) {
            isFlipped.toggle()
        }
    }
    
    func moveToNextPlayer() {
        if currentPlayerIndex < roundPlayers.count - 1 {
            currentPlayerIndex += 1
            isFlipped = false
        }
    }
    
    func playSound(named soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("Sound file not found")
            return
        }
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: url)
            soundPlayer?.play()
        } catch {
            print("Error playing sound \(error.localizedDescription)")
        }
    }
}

import SwiftUI


#Preview {
    Question(roundPlayers: xplayers, imposter: xplayers.last!, legitimates: legetimateplayers)
        .environmentObject(AudioManager())
    
}

let xplayers: [Player] = [
    Player(name: "Alice", status: "True",  score: 0, isImposter: false),
    Player(name: "Bob", status: "True",  score: 0, isImposter: false),
    Player(name: "Charlie", status: "True",  score: 0, isImposter: true),
    Player(name: "David", status: "True",  score: 0, isImposter: false)
]

let legetimateplayers: [Player] = [
    Player(name: "Alice", status: "True", score: 0, isImposter: false),
    Player(name: "Bob", status: "True",  score: 0, isImposter: false),
    Player(name: "David", status: "True", score: 0, isImposter: false)
]
