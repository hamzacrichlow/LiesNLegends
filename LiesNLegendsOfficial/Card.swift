//
//  Card.swift
//  LiesNLegendsOfficial
//
//  Created by Derald Blessman on 2/25/25.
//

import SwiftUI
import Foundation

struct LegitCard: View {
    var body: some View {
        ZStack {
            Image("LegitCard")
            
            VStack {
                Text("The Game Category")
                    .font(.custom("", size: 24))
            }
        }
    }
}
#Preview {
    LegitCard()
}
