//
//  AvailableCourse.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 01/01/2024.
//

import Foundation

struct AvailableCourse: Codable {
    let courseID: String
    let courseName: String
}

struct AvailableSupervisor: Codable {
    let regID: String
    let name: String
    let isFull: Bool
}

struct Request: Codable {
    let senderID: String
    let receiverID: String
    let courseID: String
    let status: String
    let type: String
    let senderName: String
    let receiverName: String
}

struct Skills: Codable {
    let title: String
    var isSelected: Bool
}

struct Category: Codable {
    let title: String
    var skills: [Skills]
}
