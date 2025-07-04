//
//  ListOfPlayers.swift
//  LiesNLegendsOfficial
//
//  Created by Derald Blessman on 2/25/25.
//

import SwiftUI
import SwiftData

struct ListOfPlayers: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Player.id) private var players: [Player]
    
    @EnvironmentObject var audioManager: AudioManager
    
    @State private var newName = ""
    @State private var playerScore = 0
    @State private var showRules = false
    @State private var navigateToCategory = false
    @State private var editingSlot: Int? = nil
    @State private var tempName = ""
    @FocusState private var isTextFieldFocused: Bool
    
    let minPlayers = 4
    let maxPlayers = 6
    
    // Calculate how many slots to show (existing players + 1 add slot, up to maxPlayers)
    var slotsToShow: Int {
        if players.count == 0 {
            return 1 // Show one empty slot when no players
        } else if players.count < maxPlayers {
            return players.count + 1 // Show existing players + 1 empty slot
        } else {
            return maxPlayers // Show only filled slots when at max
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray5)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Add Players")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top,20)
                    Text("4 - 6 Players")
                        .font(.subheadline)
                    
                    // Player Slots - Single Column
                    VStack(spacing: 12) {
                        ForEach(0..<slotsToShow, id: \.self) { index in
                            PlayerSlotView(
                                slotNumber: index + 1,
                                player: getPlayerForSlot(index),
                                isEditing: editingSlot == index,
                                tempName: $tempName,
                                isTextFieldFocused: _isTextFieldFocused,
                                onTap: {
                                    if let player = getPlayerForSlot(index) {
                                        // Edit existing player
                                        editingSlot = index
                                        tempName = player.name
                                        isTextFieldFocused = true
                                    } else {
                                        // Add new player
                                        editingSlot = index
                                        tempName = ""
                                        isTextFieldFocused = true
                                    }
                                },
                                onSave: {
                                    savePlayer(at: index)
                                },
                                onDelete: {
                                    deletePlayer(at: index)
                                },
                                onCancel: {
                                    editingSlot = nil
                                    tempName = ""
                                    isTextFieldFocused = false
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                //Choose Category Button navigates so the user can choose the category
                    NavigationLink(destination: PickACategory(players: players), isActive: $navigateToCategory) {
                        EmptyView()
                    }
                    
                    StartGameButton(
                        isEnabled: players.count >= minPlayers,
                        text: "CHOOSE CATEGORY",
                        action: {
                            navigateToCategory = true
                        }
                    )
                    .padding(.bottom, 20)
                    
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
            .onTapGesture {
                // Dismiss keyboard when tapping outside
                if editingSlot != nil {
                    editingSlot = nil
                    tempName = ""
                    isTextFieldFocused = false
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func getPlayerForSlot(_ index: Int) -> Player? {
        return index < players.count ? players[index] : nil
    }
    
    private func savePlayer(at index: Int) {
        let trimmedName = tempName.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }
        
        if let existingPlayer = getPlayerForSlot(index) {
            // Update existing player
            existingPlayer.name = trimmedName
        } else {
            // Create new player
            let newPlayer = Player(name: trimmedName, status: "alive", score: playerScore)
            context.insert(newPlayer)
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save player: \(error)")
        }
        
        editingSlot = nil
        tempName = ""
        isTextFieldFocused = false
    }
    
    private func deletePlayer(at index: Int) {
        guard let player = getPlayerForSlot(index) else { return }
        
        do {
            context.delete(player)
            try context.save()
        } catch {
            print("Failed to delete player: \(error)")
        }
        
        editingSlot = nil
        tempName = ""
        isTextFieldFocused = false
    }
    
    private func clearAllPlayers() {
        do {
            try context.delete(model: Player.self)
            try context.save()
        } catch {
            print("Failed to clear players.")
        }
        
        editingSlot = nil
        tempName = ""
        isTextFieldFocused = false
    }
}

struct PlayerSlotView: View {
    let slotNumber: Int
    let player: Player?
    let isEditing: Bool
    @Binding var tempName: String
    @FocusState var isTextFieldFocused: Bool
    let onTap: () -> Void
    let onSave: () -> Void
    let onDelete: () -> Void
    let onCancel: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var backgroundColor: Color {
        return colorScheme == .dark ? .white : .black
    }
    
    var body: some View {
       
        ZStack {
            
            RoundedRectangle(cornerRadius: 25)
                .fill(
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
                .frame(width: 350,height: 60)
                            .shadow(color: .black.opacity(player != nil ? 0.6 : 0.3), radius: player != nil ? 4 : 1, x: 2, y: 2)
            
            if isEditing {
                // Editing Mode
                HStack(spacing: 15) {
                    TextField("", text: $tempName)
                        .background(Color.gray)
                        .frame(maxWidth:.infinity)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($isTextFieldFocused)
                        .onSubmit {
                            onSave()
                        }
                    
                    Button(action: {
                                         onSave()
                                     }) {
                                         Image(systemName: "plus")
                                             .font(.headline)
                                             .bold()
                                             .foregroundColor(colorScheme == .dark ? .blue : .blue).opacity(0.8)
                                             
                                     }
                }
                .padding(.horizontal, 30)
            } else {
                // Display Mode
                VStack {
                    if let player = player {
                        ZStack {
                            VStack(spacing: 4) {
                                Text(player.name).textCase(.uppercase)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(colorScheme == .dark ? .black : .white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                                
                            }
                            
                            
                            HStack {
                                Spacer()
                                Button(action: {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    onDelete()
                                }) {
                                    Image(systemName: "x.circle")
                                        .font(.headline)
                                        .foregroundColor(colorScheme == .dark ? .gray: .white).opacity(0.5)
                                        .padding(.horizontal,30)
                                    
                                }
                            }
                            
                            
                        }
                    } else {
                        ZStack{
                            Text("ADD PLAYER")
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor((colorScheme == .dark ? Color.black : .white).opacity(0.8))
                            HStack{
                               Spacer()
                                Image(systemName: "plus")
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(colorScheme == .dark ? .black : .white).opacity(0.4)
                                    .padding(.horizontal,30)
                             
                                
                                                        
                            }
                        }
                    }
                    
                }
            }
        }
        .onTapGesture {
            if !isEditing {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                withAnimation(.easeInOut(duration: 0.2)) {
                    onTap()
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isEditing)
    
}
}

#Preview {
    ListOfPlayers()
        .modelContainer(for: Player.self, inMemory: true)
        .environmentObject(AudioManager())
}
