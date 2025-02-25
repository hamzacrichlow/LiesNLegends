//
//  StartScreen.swift
//  LiesNLegendsOfficial
//
//  Created by Derald Blessman on 2/25/25.
//

import SwiftUI
import AVFoundation

struct StartScreen: View {
    @State private var showRules = false
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack{
                    MusicView()
                        .padding(.top, -60)
                        .padding(.leading, 250)
                }
                Image("LogoDark")
                    .resizable()
                    .frame(width: 296, height: 80)
                    .padding()
                    .padding()
//                CardFlipView()
                    .padding(.bottom, 30)
                
                ContFlipView()
                    .padding(.bottom, 30)
                
                NavigationLink{
                  ListOfPlayers()
                    
                } label: {
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(.black, lineWidth: 6)
                            .font(.headline)
                            .frame(width: 200, height: 40)
                            .background(Color.white)
                            .cornerRadius(50)
                        Text("START GAME")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                    }
                }
                .padding(.bottom, 10)
                
                Button(action: {showRules.toggle()}){
                    ZStack{
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(.black, lineWidth: 6)
                            .font(.headline)
                            .frame(width: 200, height: 40)
                            .background(Color.white)
                            .cornerRadius(50)
                        Text("RULES")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                                }
                                .sheet(isPresented: $showRules) {
                                    RulesScreen()
                                }
                
                }
            
            }
        
            .background(Color.gray.frame(width: 4100, height: 9000))
            
        }
    
    }


#Preview {
   StartScreen()
        .modelContainer(for: Player.self, inMemory: true)
}
