//
//  Player.swift
//  LiesNLegendsOfficial
//
//  Created by Derald Blessman on 2/25/25.
//

import Foundation
import SwiftData

@Model
class Player: Identifiable {
    var name: String
    var status: String
    var id = UUID()
    var score: Int
    var isImposter: Bool
    var isLegitimate: Bool
    
    init(name: String, status: String, score: Int, isImposter: Bool = false, isLegitimate: Bool = true) {
        self.name = name
        self.status = status
        self.score = score
        self.isImposter = isImposter
        self.isLegitimate = isLegitimate
    }
    
    var isTurn: Bool {
        status == "True"
    }
   
   
}
