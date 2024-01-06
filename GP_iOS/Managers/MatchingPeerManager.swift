//
//  MatchingPeerManager.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 03/01/2024.
//

import Foundation

class MatchingPeerManager {
    static let shared = MatchingPeerManager()

    func createVector(from categories: [Category]) -> String {
        var vectorString = ""

        for category in categories {
            for skill in category.skills {
                vectorString += skill.isSelected ? "1" : "0"
            }
        }

        return vectorString
    }
}
