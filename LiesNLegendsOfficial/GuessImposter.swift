//
//  Untitled.swift
//  LiesNLegendsOfficial
//
//  Created by Derald Blessman on 2/25/25.
//

import SwiftUI
import AVFoundation

//This is supposed to be the inbetweeen screen before they guess the imposter
struct Question: View {
    
    let roundPlayers: [Player]
    let imposter: Player
    let legitimates: [Player]
    
  
    var body: some View {
        ZStack{
            Color.rulesSheet.ignoresSafeArea(edges: .all)
           VStack {
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
            NavigationLink(destination: GuessTheImposter(roundPlayers: roundPlayers, imposter: imposter, legitimates: legitimates)) {
                ZStack{
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(.black, lineWidth: 6)
                        .font(.headline)
                        .frame(width: 200, height: 40)
                        .background(Color.black)
                        .cornerRadius(50)
                    Text("START ROUND")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
            }
        }
        
    }
    }
}


struct GuessTheImposter: View {
    @State private var currentPlayerIndex = 0
    @State private var isFlipped = false
    @State private var selectedImposter: Player? // Store selected imposter for each player
    @State private var playerSelections: [Player: Player?] = [:] // Track the selections for each player
    
    let roundPlayers: [Player]
    let imposter: Player
    let legitimates: [Player]
    
    var currentPlayer: Player {
        roundPlayers[currentPlayerIndex]
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
    
    var body: some View {
        ZStack {
            Color(.background)
                .ignoresSafeArea(edges: .all)
            VStack {
                Text(currentPlayer.name)
                    .font(.title)
                    .padding()
                
                ZStack {
                    // Card Back
                    Image("CardBack")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 400)
                        .shadow(color: .black, radius: 15, x: 5, y: 5)
                        .opacity(isFlipped ? 0 : 1)
                    
                    // Players' names when flipped
                    if isFlipped {
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .frame(width: 300, height: 400)
                               
                            VStack {
                                Text("Select the Imposter")
                                    .font(.title2)
                                    .padding(.top)
                                
                                ForEach(roundPlayers, id: \.id) { player in
                                    Button(action: {
                                        // Handle selection of imposter
                                        selectedImposter = player
                                        playerSelections[currentPlayer] = player
                                        moveToNextPlayer()
                                    }) {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 50)
                                                 .stroke(.black, lineWidth: 6)
                                                 .font(.headline)
                                                 .frame(width: 200, height: 40)
                                                 .background(Color.white)
                                                 .cornerRadius(50)
                                            Text(player.name)
                                                .font(.headline)
                                                .background(selectedImposter == player ? Color.gray.opacity(0.5) : Color.clear)
                                                .cornerRadius(10)
                                                .foregroundColor(.black)
                                        }
                                    }
                                    .padding(2)
                                }
                            }
                            .padding()
                        }
                    }
                }
                
                // Flip Button
                Button {
                    playSound(named: "CARD FLIP")
                    // Create haptic generator
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    // trigger haptic feedback
                    generator.impactOccurred()
                    flipCard()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(.black, lineWidth: 6)
                            .font(.headline)
                            .frame(width: 200, height: 40)
                            .background(Color.white)
                            .cornerRadius(50)
                        Text("FLIP CARD")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                    }
                    
                }
                .padding()
                
                // Show "Next Player" button after the selection
                if let _ = playerSelections[currentPlayer], currentPlayerIndex < roundPlayers.count - 1 {
                    Button {
                        moveToNextPlayer()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.black, lineWidth: 6)
                                .font(.headline)
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
                
                // Once all players have selected, show the results (or proceed to the next stage)
                if playerSelections.count == roundPlayers.count {
                    NavigationLink(destination: RevealImposterView(imposter: imposter, roundPlayers: roundPlayers, playerSelections: playerSelections)) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.black, lineWidth: 6)
                                .font(.headline)
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
        .onAppear {
            // Initialize player selections to nil for each player
            roundPlayers.forEach { player in
                playerSelections[player] = nil
            }
        }
    }
    
    func revealImposter() -> some View {
        VStack {
            Text("The Imposter was:")
                .font(.title)
                .padding()
            
            Text(imposter.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.red)
                .padding()
            
            Text("Players' Guesses:")
                .font(.title2)
                .padding(.top)
            
            ForEach(roundPlayers, id: \.id) { player in
                HStack {
                    Text("\(player.name) guessed: ")
                        .font(.headline)
                    
                    if let guessedImposter = playerSelections[player] {
                        Text(guessedImposter?.name ?? "No Selection")
                            .font(.headline)
                            .foregroundColor(guessedImposter == imposter ? .green : .red)
                    } else {
                        Text("No Selection")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
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
}

import SwiftUI


#Preview {
    Question(roundPlayers: xplayers, imposter: xplayers.last!, legitimates: legetimateplayers)
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

//#Preview {
//    let mockPlayers = [
//        Player(name: "Alice"),
//        Player(name: "Bob"),
//        Player(name: "Charlie")
//    ]
//
//    Question(
//        roundPlayers: mockPlayers,
//        imposter: mockPlayers.last!,
//        legitimates: Array(mockPlayers.dropLast())
//    )
//}
