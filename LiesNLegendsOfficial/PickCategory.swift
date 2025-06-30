//
//  PickCategory.swift
//  LiesNLegendsOfficial
//
//  Created by Derald Blessman on 2/25/25.
//

import SwiftUI


import SwiftUI


//Historical figures
var blackHistory: [String] = ["Dr. MLK", "Malcolm X", "Harriet Tubman", "Thurgood Marshall", "Nat Turner", "Garret Morgan", "Madame CJ Walker", "Mary Ellen Pleasant", "Ronald McNair", "Mae Jemison", "George Floyd", "Trayvon Martin", "Montgomery Bus Boycott", "March on Washington", "Bloody Sunday", "Million Man March"]

// Hip Hop and R&B
var musicArtists: [String] = ["Kendrick Lamar", "Drake", "Tupac Shakur", "Biggie Smalls", "Jay-Z", "Nas", "Aretha Franklin", "Stevie Wonder", "Prince", "Whitney Houston", "Marvin Gaye", "Al Green", "Diana Ross", "Mary J. Blige", "Alicia Keys", "John Legend", "Usher", "Tina Turner", "Gladys Knight", "Lauryn Hill", "Queen Latifah"]

// Celebrities
var celebrities: [String] = ["Dave Chappelle", "Eddie Murphy", "Oprah Winfrey", "Tyler Perry", "Spike Lee", "Quincy Jones", "James Earl Jones", "Lena Horne", "Diahann Carroll", "Phylicia Rashad", "Debbie Allen", "Clarence Avant", "Don Cornelius", "Whoopi Goldberg", "Chris Rock", "Michael Jordan", "Magic Johnson", "Kobe Bryant", "LeBron James", "Serena Williams", "Muhammad Ali"]

//Motown Artists
var motownArtists: [String] = ["Diana Ross", "The Supremes", "The Temptations", "Stevie Wonder", "Marvin Gaye", "The Jackson 5", "Smokey Robinson", "The Miracles", "Martha Reeves", "The Isley Brothers", "Gladys Knight", "The Four Tops", "Mary Wells", "The Marvelettes", "Berry Gordy"]

// Category Enum
enum GameCategory: String, CaseIterable {
    case blackHistory1 = "BLACK HISTORY"
    case music1 = "MUSIC"
    case celebrities2 = "CELEBRITIES"
    case motown2 = "MOTOWN"
    
    var words: [String] {
        switch self {
        case .blackHistory1:
            return blackHistory
        case .music1:
            return musicArtists
        case .celebrities2:
            return celebrities
        case .motown2:
            return motownArtists
        }
    }
}


struct PickACategory: View {
    @EnvironmentObject var audioManager: AudioManager
    let players: [Player]
    
    @State private var selectedCategory: GameCategory?
    @State private var navigateToGame = false
    @State private var showRules = false
    
    func getRandomWord(from category: [String]) -> String {
        return category.randomElement() ?? "No word found"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray5)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Text("Pick a Category")
                        .font(.title)
                        .bold()
                    
                    
                    
                    ForEach(GameCategory.allCases, id: \.self) { category in
                        CategoryButton(
                            title: category.rawValue,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                        }
                    }
                    
                    
                    
                    
                    StartGameButton(isEnabled: selectedCategory != nil) {
                        if selectedCategory != nil {
                            navigateToGame = true
                        }
                    }
                    .padding()
                    .navigationDestination(isPresented: $navigateToGame) {
                        if let selectedCategory {
                            CardFlipView(
                                players: players,
                                word: getRandomWord(from: selectedCategory.words)
                            )
                        }
                    }
                    
                    
                }
            }
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
        }
    }
}


struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    var backgroundColor: Color {
        isSelected ? .primary : .gray
    }
    
    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            withAnimation(.easeInOut(duration: 0.2)) {
                action()
            }
        }) {
            HStack(spacing: 8) {
                Text(title)
                    .textCase(.uppercase)
                    .font(.headline)
                    .bold()
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(colorScheme == .dark ? .black : .white)
                        .transition(.scale)
                }
            }
            .frame(width: 200, height: 50)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        backgroundColor,
                        backgroundColor.opacity(0.7),
                        backgroundColor
                    ]),
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
            .shadow(color: .black.opacity(isSelected ? 0.6 : 0.3), radius: isSelected ? 4 : 1, x: 2, y: 2)
        }
        .buttonStyle(.plain)
        .padding(5)
    }
}


struct StartGameButton: View {
    @Environment(\.colorScheme) private var colorScheme
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            if isEnabled {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                action()
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .stroke(isEnabled ? .green : .gray, lineWidth: 6)
                    .frame(width: 200, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 50)
                            .fill(isEnabled ? Color.green : Color.gray.opacity(0.3))
                            .shadow(color: .black.opacity(0.3), radius: isEnabled ? 5 : 0, x: 0, y: 2)
                    )
                
                Text("START GAME")
                    .fontWeight(.bold)
                    .foregroundColor(isEnabled ? (colorScheme == .dark ? .black : .white)
                                         : .gray)
                    .font(.system(size: 16))
            }
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.6)
        .animation(.easeInOut(duration: 0.2), value: isEnabled)
    }
}

#Preview {
    PickACategory(
        players: xplayers
    )
    .environmentObject(AudioManager())
}
