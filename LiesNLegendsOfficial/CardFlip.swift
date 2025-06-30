//
//  ContentView.swift
//  LiesNLegendsOfficial
//
//  Created by Derald Blessman on 2/25/25.
//

import SwiftUI
import AVFoundation

struct GlossyButton: View {
    let text: String
    let backgroundColor: Color
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    private func getTextColor(for backgroundColor: Color, scheme: ColorScheme) -> Color {
        let isBW = backgroundColor == .black || backgroundColor == .white

        if isBW {
            return scheme == .dark ? .black : .white
        } else {
            return scheme == .dark ? .black : .white
        }
    }
    var body: some View {
        Button(action: action) {
            Text(text).textCase(.uppercase)
                .font(.title)
                .bold()
                .foregroundColor(getTextColor(for: backgroundColor, scheme: colorScheme))
                .frame(minWidth: 150, maxWidth: 225, minHeight: 60, maxHeight: 60)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [backgroundColor, backgroundColor.opacity(0.66), backgroundColor]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.clear, backgroundColor.opacity(0.3), Color.clear]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 3
                        )
                )
                .shadow(color: .black.opacity(0.5), radius: 1, x: 2, y: 2)
        }
        
    }
}


struct DisabledGlossyButton: View {
    let text: String
    let backgroundColor: Color
    let action: () -> Void
    let disabled: Bool
    @Environment(\.colorScheme) var colorScheme
    
    private func getTextColor(for backgroundColor: Color, scheme: ColorScheme, isDisabled: Bool) -> Color {
        if isDisabled {
            return .gray
        }
        let isBW = backgroundColor == .black || backgroundColor == .white
        return isBW
            ? (scheme == .dark ? .black : .white)
            : (scheme == .dark ? .black : .white)
    }
    var body: some View {
        Button(action: action) {
            Text(text).textCase(.uppercase)
                .font(.title)
                .bold()
                .foregroundColor(getTextColor(for: backgroundColor, scheme: colorScheme, isDisabled: disabled))

                .frame(minWidth: 150, maxWidth: 225, minHeight: 60, maxHeight: 60)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: disabled
                            ? [Color.gray.opacity(0.4), Color.gray.opacity(0.2)]
                            : [backgroundColor, backgroundColor.opacity(0.66), backgroundColor]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )

                )
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.clear, backgroundColor.opacity(0.3), Color.clear]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 3
                        )
                )
                .shadow(color: .black.opacity(disabled ? 0 : 0.5), radius: disabled ? 0 : 1, x: 2, y: 2)

        }
        
    }
}
struct GlossyButtonView: View {
    let text: String
    let backgroundColor: Color
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Text(text)
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(colorScheme == .dark ? .black : .white) // White text in light mode, black text in dark mode
            .frame(width: 175, height: 50)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [backgroundColor, backgroundColor.opacity(0.66), backgroundColor]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.clear, backgroundColor.opacity(0.3), Color.clear]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth: 3
                    )
            )
            .shadow(color: .black.opacity(0.5), radius: 1, x: 2, y: 2)
    }
}



// MARK: - Card Flip Flow States
enum CardFlipState {
    case passPhone(to: String)
    case confirmPlayer(name: String)
    case showCard(player: Player)
    case allPlayersComplete
}



struct CardFlipView: View {
    @EnvironmentObject var audioManager: AudioManager
    @State private var cardFlipState: CardFlipState
    @State private var currentPlayerIndex = 0
    @State private var shuffledPlayers: [Player]
    @State private var playersWhoViewed: Set<UUID> = []
    @State private var imposter: Player?
    @State private var legitimates: [Player] = []
    @State private var navigateToHints = false
    @State private var showRules = false

    let word: String
    var players: [Player]

    init(players: [Player], word: String) {
        self.players = players
        self.word = word
        

        let shuffled = players.shuffled()
        _shuffledPlayers = State(initialValue: shuffled)

        if let first = shuffled.first {
            _cardFlipState = State(initialValue: .passPhone(to: first.name))
        } else {
            _cardFlipState = State(initialValue: .allPlayersComplete)
        }
    }

    var currentPlayer: Player {
        shuffledPlayers[currentPlayerIndex]
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray5).ignoresSafeArea()

                VStack(spacing: 30) {
                    switch cardFlipState {
                    case .passPhone(let name):
                        PassPhoneView(playerName: name) {
                            cardFlipState = .confirmPlayer(name: name)
                        }

                    case .confirmPlayer(let name):
                        ConfirmPlayerView(playerName: name) { confirmed in
                            cardFlipState = confirmed ? .showCard(player: currentPlayer) : .passPhone(to: name)
                        }

                    case .showCard(let player):
                        ShowCardView(
                            player: player,
                            word: word,
                            imposter: imposter
                        ) {
                            playersWhoViewed.insert(player.id)
                            moveToNextPlayer()
                        }

                    case .allPlayersComplete:
                        AllCompleteView {
                            navigateToHints = true
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showRules.toggle() }) {
                        Image(systemName: "book.closed")
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
            .navigationDestination(isPresented: $navigateToHints) {
                Question(
                    roundPlayers: shuffledPlayers,
                    imposter: imposter ?? Player(name: "Unknown", status: "N/A", score: 0, isImposter: false),
                    legitimates: legitimates
                )
            }
            .onAppear {
                setupGame()
            }
        }
    }

    func moveToNextPlayer() {
        if currentPlayerIndex < shuffledPlayers.count - 1 {
            currentPlayerIndex += 1
            cardFlipState = .passPhone(to: shuffledPlayers[currentPlayerIndex].name)
        } else {
            cardFlipState = .allPlayersComplete
        }
    }

    func setupGame() {
        var assigned = shuffledPlayers.map { player in
            var updated = player
            updated.isLegitimate = true
            return updated
        }

        let result = assignImposter(from: &assigned)
        imposter = result.imposter
        legitimates = result.legitimates
        shuffledPlayers = assigned
    }

    func assignImposter(from players: inout [Player]) -> (imposter: Player, legitimates: [Player]) {
        let eligible = players.filter { !$0.isImposter }

        guard !eligible.isEmpty else {
            return (Player(name: "No players", status: "None", score: 0, isImposter: false), [])
        }

        let index = Int.random(in: 0..<eligible.count)
        var impost = eligible[index]
        impost.isImposter = true

        players = players.map { p in
            var copy = p
            copy.isImposter = (p.id == impost.id)
            return copy
        }

        let legit = players.filter { !$0.isImposter }
        return (imposter: impost, legitimates: legit)
    }
}

// MARK: - Pass Phone View
struct PassPhoneView: View {
    let playerName: String
    let onContinue: () -> Void
    @State private var arrowOffset: CGFloat = 0
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            Text("PASS THE PHONE TO")
                .font(.title)
                .bold()
               
            
            Text(playerName.uppercased())
                .font(.system(size: 60, weight: .bold))
                .padding(.horizontal, 20)
               
          Spacer()
            
            HStack{
                // Phone Icon
                Image(systemName: "iphone")
                    .font(.system(size: 200))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.primary.opacity(0.6),
                                Color.primary.opacity(0.4),
                                Color.primary.opacity(0.6),
                                Color.primary.opacity(0.3)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                   
                    .shadow(color: .primary.opacity(0.3), radius: 1, x: 2, y: 2)
                   
                    .offset(x: arrowOffset)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                            arrowOffset = 30
                        }
                    }
                
                // Arrow pointing right
                Image(systemName: "arrow.right")
                    .font(.system(size: 50))
                    .foregroundStyle(.primary.opacity(0.6))
                    .bold()
                    .offset(x: arrowOffset)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                            arrowOffset = 30
                        }
                    }
            }
            Spacer()
           
                GlossyButton(text: "OK", backgroundColor: .primary, action: { UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    onContinue()})
                .padding(.bottom, 50)
            
        }
    }
}

// MARK: - Confirm Player View
struct ConfirmPlayerView: View {
    let playerName: String
    let onResponse: (Bool) -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            Text("ARE YOU")
                .font(.title)
                .bold()
           
            HStack{
                Text(playerName.uppercased())
                    .font(.system(size: 60, weight: .bold))
                  
                
                Text("?")
                    .font(.system(size:60, weight: .bold))
                  
            }
            .padding(.horizontal, 20)
            Spacer()
           
                // YES Button
                    GlossyButton(text: "YES", backgroundColor: .green, action: {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        onResponse(true)
                    })
                
                // NO Button
            GlossyButton(text: "NO", backgroundColor: .red, action: {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                onResponse(false)
            })
            }
        }
    }


// MARK: - Show Card View
struct ShowCardView: View {
    let player: Player
    let word: String
    let imposter: Player?
    let onDone: () -> Void
    
    @State private var isFlipped = false
    @State private var angle: Double = 0
    @State private var hasFlippedOnce = false // Track if card has been flipped at least once
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            Text("FLIP YOUR CARD TO REVEAL YOUR ROLE")
                .multilineTextAlignment(.center)
                .bold()
                .font(.title3)
                .padding(.horizontal, 30)
                
            Spacer()
            // Card Stack
            ZStack {
                if player.isImposter {
                    // Imposter Card
                    CardView(
                        backImage: "CardBack",
                        frontImage: "ImposCard",
                        text: nil,
                        isFlipped: isFlipped,
                        angle: angle
                    )
                } else {
                    // Legitimate Card
                    CardView(
                        backImage: "CardBack",
                        frontImage: "LegitCard",
                        text: word,
                        isFlipped: isFlipped,
                        angle: angle
                    )
                }
            }
            
            Spacer()
        
                // Flip Card Button
               
                    GlossyButton(text: "FLIP CARD", backgroundColor: .primary, action: {
                        flipCard()
                        playSound(named: "CARD FLIP")
                        if !hasFlippedOnce {
                            hasFlippedOnce = true
                        }
                    })
               
                
                // Done Button (disabled until first flip)
            DisabledGlossyButton(
                text: "DONE",
                backgroundColor: .green,
                action: {
                    if hasFlippedOnce {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        onDone()
                    }
                },
                disabled: !hasFlippedOnce
            )
            .disabled(!hasFlippedOnce)

            
            
            Spacer()
        }
    }
    
    func flipCard() {
        withAnimation(.easeInOut(duration: 1.2)) { // Slower animation
            angle += 180
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            isFlipped.toggle()
        }
    }
    
    func playSound(named soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("Sound file not found")
            return
        }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.play()
        } catch {
            print("Error playing sound \(error.localizedDescription)")
        }
    }
}

// MARK: - Card View Component
struct CardView: View {
    let backImage: String
    let frontImage: String
    let text: String?
    let isFlipped: Bool
    let angle: Double
    
    var body: some View {
        ZStack {
            // Card Back
            Image(backImage)
                .resizable()
                .scaledToFit()
                .shadow(color: .black.opacity(0.3), radius: 8, x: 4, y: 4)
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(.degrees(angle), axis: (x: 0, y: 1, z: 0))
            
            // Card Front
            ZStack {
                Image(frontImage)
                    .resizable()
                    .scaledToFit()
                    .shadow(color: .black.opacity(0.3), radius: 8, x: 4, y: 4)
                
                // Text overlay for legitimate players
                if let text = text {
                    Text(text)
                        .font(.system(size: 18, weight: .bold))
                        .multilineTextAlignment(.center)
                        .frame(width: 120, height: 180)
                        .background(Color.clear)
                }
            }
            .opacity(isFlipped ? 1 : 0)
            .rotation3DEffect(.degrees(angle + 180), axis: (x: 0, y: 1, z: 0))
        }
    }
}

// MARK: - All Complete View
struct AllCompleteView: View {
    @State private var wiggle = false
    let onStartRound: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Text("Everyone has viewed their card and knows their role")
                .multilineTextAlignment(.center)
                .font(.title)
                .bold()
              
                .padding(.horizontal, 20)
            
            Text("Who is the imposter?")
                .font(.title2)
                .bold()
            
          
            Spacer()
            Image("Group")
                .resizable()
                .scaledToFit()
                .rotationEffect(.degrees(wiggle ? 5 : -5))
                .animation(
                    Animation.easeInOut(duration: 0.6)
                        .repeatForever(autoreverses: true),
                    value: wiggle
                )
                .onAppear {
                    wiggle = true
                }
            
            Spacer()
           
            Button(action: {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                onStartRound()
            }) {
                GlossyButton(text: "START ROUND", backgroundColor: .green, action: {
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    onStartRound()
                })
            }
            
            Spacer()
        }
    }
}

//example
#Preview {
    CardFlipView(
        players: xplayers,
        word: """
Michael 
Jackson
"""
    )
    .environmentObject(AudioManager())
}


//example players

      
