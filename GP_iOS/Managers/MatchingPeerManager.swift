//
//  MatchingPeerManager.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 03/01/2024.
//

import UIKit.UIColor

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

    func getMySkillsAttributedString() -> NSAttributedString {
        let categories = AppManager.shared.categories
        let skillsVector = AppManager.shared.profile?.skillsVector ?? ""

        let attributedResult = NSMutableAttributedString()
        var index = 0

        for category in categories {
            let categoryTitle = NSAttributedString(string: category.title + ": ",
                                                   attributes: [.foregroundColor: UIColor.black])
            attributedResult.append(categoryTitle)

            var categorySkills = [String]()
            for skill in category.skills {
                let char = skillsVector.index(skillsVector.startIndex, offsetBy: index)
                if skillsVector[char] == "1" {
                    categorySkills.append(skill.title)
                }
                index += 1
            }
            let skillsString = categorySkills.joined(separator: ", ")
            let skillsAttributedString = NSAttributedString(string: skillsString,
                                                            attributes: [.foregroundColor: UIColor.gray])
            attributedResult.append(skillsAttributedString)

            let newline = NSAttributedString(string: "\n")
            attributedResult.append(newline)
        }
        return attributedResult
    }

    func getSelectedSkills(categories: [Category]) -> [Category] {
        var mutableCategories = categories
        let skillsVector = AppManager.shared.profile?.skillsVector ?? ""

        var accIndex = 0

        for (index, category) in mutableCategories.enumerated() {
            for (skillsIndex, skill) in category.skills.enumerated() {
                let charIndex = skillsVector.index(skillsVector.startIndex, offsetBy: accIndex)
                if skillsVector[charIndex] == "1" {
                    mutableCategories[index].skills[skillsIndex].isSelected = true
                }
                accIndex += 1
            }
        }
        return mutableCategories
    }
}
