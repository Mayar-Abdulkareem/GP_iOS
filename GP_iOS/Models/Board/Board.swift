//
//  Board.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 06/01/2024.
//

import Foundation

struct Column: Codable {
    var title: String
    var tasks: [Task]?
}

struct Task: Codable {
    var title: String
    var description: String
}

struct Board: Codable {
    let regID: String
    let courseID: String
    var columns: [Column]?
    let supervisorID: String
}
