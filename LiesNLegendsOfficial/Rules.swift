//
//  Rules.swift
//  LiesNLegendsOfficial
//
//  Created by Derald Blessman on 2/25/25.
//

import SwiftUI

struct RulesScreen: View {
    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    Text("RULES")
                        .font(.system(size: 36, weight: .black))
                        .foregroundColor(.black)
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                    
                    // Setup Section
                    RuleSection(
                        title: "Setup (4-6 Players)",
                        content: """
                        • Add each player's name to the game
                        • Select a category for the round
                        • Categories include: 
                        Black History 
                        Hip-Hop 
                        R&B/Soul 
                        Entertainment 
                        Sports 
                        Motown 
                        Icons
                        """
                    )
                    // Roles Section
                    RuleSection(
                        title: "Player Roles",
                        content: """
                        Legitimates:
                        All players but one get the same word from the category
                        Example: "Diana Ross"
                        
                        The Imposter (1 player):
                        The remaining player is the imposter and doesnt know what the word is but they have to act like they do.
                        """
                    )

                    // Phone Passing Section
                    RuleSection(
                        title: "Phone Passing Phase",
                        content: """
                        The phone will guide you through each player viewing their role:
                        
                        1. Screen asks "Are you (Player Name)?"
                           • If it's you: Tap "Yes" to continue
                        
                        2. When it's your turn, tap "Flip Card" to see your secret role
                        
                        3. Keep your role secret! Don't let others see your screen
                        
                        4. After viewing, pass the phone to the next player
                        """
                    )
                    
                    
                    // Clue Giving Section
                    RuleSection(
                        title: "Giving Clues",
                        content: """
                        Once everyone has viewed their card:
                        
                        • Players take turns giving one word clues
                        • Clues must be related to your word
                        • Cannot be part of the word itself
                        • Keep it brief - one or two words maximum
                        
                        Example Round:
                        Category: Motown 
                        Secret Word: "Diana Ross"
                        
                        • Player 1 (Legitimate): "Singer"
                        • Player 2 (Legitimate): "Supreme"
                        • Player 3 (Imposter): "Music" *(only knows "Motown Artists")*
                        • Player 4 (Legitimate): "Detroit"
                        • Player 5 (Legitimate): "Diva"
                        
                        Notice how the Imposter's clue "Music" is more generic!
                        """
                    )
                    
                    // Voting Section
                    RuleSection(
                        title: "Voting Phase",
                        content: """
                        After everyone gives their clues:
                        
                        **For Legitimates:**
                        • Pass the phone around for voting
                        • Each Legitimate privately votes for who they think the imposter is
                        • Keep votes secret until everyone has voted
                        
                        **For the Imposter:**
                        • Gets multiple choice options to guess what they think the secret word is
                        • Based on all the clues they heard during the round
                        • This is their chance to win points by figuring out the word
                        """
                    )
                    
                    // Scoring Section
                    RuleSection(
                        title: "Scoring",
                        content: """
                        **Legitimates Win:** 
                        If they correctly identify the imposter, each Legitimate gets 1 point
                        
                        **Imposter Wins:** 
                        If the imposter avoids detection, they get 2 points
                        
                        **Bonus Points:** 
                        The imposter earns an extra point by correctly guessing the secret word from multiple choice options
                        """
                    )
                    
                    // Strategy Section
                    RuleSection(
                        title: "Tips for Success",
                        content: """
                        **For Legitimates:**
                        • Give clues that prove you know the specific word
                        • Pay attention to vague or generic clues - typically from the imposter
                        • Work together to identify suspicious behavior
                        
                        **For the Imposter:**
                        • Listen carefully to all clues to figure out the word
                        • Give clues that could apply to multiple things in the category
                        • Try to blend in with the group's clue-giving style
                        • Pay close attention - you'll need to guess the word at the end!
                        """
                    )
                    
                    // End Game Section
                    RuleSection(
                        title: "End of Round",
                        content: """
                        • View the results and see who won the round
                        • Start a new round with a different category
                        • Play as many rounds as you'd like!
                        • The player with the most points after all rounds wins the game
                        """
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
    }
}

struct RuleSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
            
            Text(content)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)
                .lineSpacing(4)
                .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}
#Preview {
    RulesScreen()
}
