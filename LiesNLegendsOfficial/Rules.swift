//
//  Rules.swift
//  LiesNLegendsOfficial
//
//  Created by Derald Blessman on 2/25/25.
//

import SwiftUI

struct RulesScreen: View {
    
    @State private var arrowOffset: CGFloat = 0
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack{
            ZStack {
                
                ScrollView {
                    VStack{
                        
                        Image("Spear")
                              .resizable()
                              .scaledToFit()
                              .padding(.vertical, 10)
                              .padding(.horizontal, 20)
                          
                        
                        Text("Read through these rules carefully to perfect your skills in deception!")
                            .multilineTextAlignment(.center)
                            .font(.title2)
                            .bold()
                            .padding(.vertical, 5)
                            .padding(.horizontal, 20)
                        
                      Divider()
                            .padding(.horizontal, 20)
                        
                     
                        // Setup Section
                        RuleSection(
                            title:"Setup",
                            subtitle:"4-6 Players",
                            content: """
                            Add each player's name, then select a category. (Black History, Motown, Celebrities, etc.)
                            """
                        )
                        Image("Group")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .frame( height: 100)
                        
                        
                        // Roles Section
                        RuleSection(
                            title: "Player Roles",
                            content: """
                            Legitimates: All get the same word from the category (e.g., "Diana Ross").
                            
                            Imposter (Only 1 Player): Doesn't know the secret word but must pretend they do.
                            """
                        )
                        HStack{
                            Image(systemName:"iphone")
                                .foregroundStyle((colorScheme == .dark ? Color.white : .black).opacity(0.8))
                                .font(.system(size: 75))
                                .offset(x: arrowOffset)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                                        arrowOffset = 10
                                    }
                                }
                            Image(systemName:"arrow.right")
                                .foregroundStyle((colorScheme == .dark ? Color.white : .black).opacity(0.8))
                                .font(.system(size: 35))
                                .offset(x: arrowOffset)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                                        arrowOffset = 10
                                    }
                                }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Phone Passing Section
                        RuleSection(
                            title: "Phone Passing",
                            subtitle: "Assign your Roles",
                            content: """
                            Pass the phone around so each player can privately view their role:
                            
                            1. Tap "Flip Card" to see your role and secret word
                            2. Keep your role secret!
                            3. Pass to the next player
                            """
                        )
                        
              
                        
                        // Clue Giving Section
                        RuleSection(
                            title: "Giving Clues",
                            content: """
                            Players take turns giving one word clues clockwise from the last player to view their role:
                            • Clues must relate to your word
                            • Cannot be part of the word itself
                            • Keep it brief (1-2 words max)
                            
                            Example - Secret Word: "Diana Ross"
                            Legitimates: "Girl Group", "Supreme", "Detroit"
                            Imposter: "Music" (more generic)
                            """
                        )
                        
                        // Voting Section
                        RuleSection(
                            title: "Voting",
                            content: """
                            Legitimates: Vote for who you think is the imposter.
                            
                            Imposter: Guess the secret word from multiple choice options based on the clues you heard.
                            """
                        )
                        
                        // Scoring Section
                        RuleSection(
                            title: "Scoring",
                            content: """
                            Legitimates: 1 point for correctly identifying the imposter.
                            
                            Imposter: 2 points for avoiding detection + 1 point for guessing the word correctly.
                            """
                        )
                        
                        // Strategy Section
                        RuleSection(
                            title: "Tips",
                            content: """
                            Legitimates: Don't be too obvious! Watch for vague clues.
                            
                            Imposter: Listen carefully, give generic clues that could apply to multiple things, and pay attention for your final guess!
                            """
                        )
                        
                        // End Game Section
                        RuleSection(
                            title: "End of Round",
                            content: """
                            View results, start new rounds with different categories, and play as many rounds as you'd like! Most points wins!
                            """
                        )
                    }
                    .navigationTitle(Text("Game Rules"))
                    .navigationBarTitleDisplayMode(.large)
                }
            }
        }
    }
    
    
    struct RuleSection: View {
        let title: String
        let subtitle: String?
        let content: String
        
        // Initializer with optional subtitle
        init(title: String, subtitle: String? = nil, content: String) {
            self.title = title
            self.subtitle = subtitle
            self.content = content
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                Text(title)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                Divider()
                
                // Only show subtitle if it exists
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.headline)
                }
                
                Text(content)
                    .font(.body)
                    .lineSpacing(4)
                    .multilineTextAlignment(.leading)
            }
            .padding(.vertical)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(UIColor.systemGray5), Color(UIColor.systemGray5).opacity(0.66), Color(UIColor.systemGray5)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(.gamegreen).opacity(0.9),Color(.gamered).opacity(0.9),Color(.gameyellow).opacity(0.9), Color(.gameyellow).opacity(0.9),Color(.gamegreen).opacity(0.9),Color(.gamered).opacity(0.9),]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth:5
                    ),
            )
            .padding(.horizontal)
            .padding(.vertical)
        }
    }
}

#Preview{
    RulesScreen()
}
