//
//  Rules.swift
//  LiesNLegendsOfficial
//
//  Created by Derald Blessman on 2/25/25.
//

import SwiftUI

struct RulesScreen: View {
    var body: some View {
        ZStack{
           
        VStack {
            ScrollView {
                Text("RULES")
                    .font(.largeTitle)
                    .padding()
                Text("Add Players")
                    .font(.title)
Text("""
-4-6 players for the game name
-Add each players name to the game
""")
                .padding()
               
            
                Text("Choose a Category")
                    .font(.title)
                Text("""
-Select a category for the round (e.g Motown, Historical Figures, Pop Culture)
""")
                .padding()
                Text("Role Assignment")
                    .font(.title)
                Text("""
-One player will be the Imposter, and everyone else will be Legitimates.
-Keep your roles private!
-The game will prompt players flip their cards to be assigned their role, the phone will have players pass the phone to the next player so they can flip their card privately.
-Legitimates will get the actual category word (e.g., "Diana Ross").
-Imposter get nothing, but they do know the category?
-Hide your phone from others so your role stays secret!
""")
                .padding()
                Text("Clue Sharing")
                    .font(.title)
                Text("""
-After everyone has their role, start the round.
-Players take turns giving a clue related to their category word.
-Clues should be related but not identical to the category word.
-For example if the catergory word is "Diana Ross" a word that a player could say is "Singer", "Celebrity", "Famous"
""")
                .padding()
                Text("Guessing")
                    .font(.title)
                Text("""
-After all players have given their clues, everyone votes on who they think the Imposter is.
-Every Legitimate will privately vote on who they think the Imposter is.
""")
                .padding()
                Text("Points")
                    .font(.title)
                Text("""
-Legitimates earn a point for correctly guessing the Imposter.
""")
                .padding()
                Text("End of Round")
                    .font(.title)
                Text("""
Repeat the process for as many rounds as you want!
""")
                .padding()
            }
            .multilineTextAlignment(.leading)
    
        }
      }
   
    }
}

#Preview {
    RulesScreen()
}
