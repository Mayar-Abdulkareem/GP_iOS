//
//  Submissions.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 22/01/2024.
//

import Foundation

struct Submission: Codable {
    let id: String?
    let file: File?
    let text: String?
    let supervisorComment: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case file
        case text
        case supervisorComment
    }
}

struct MySubmission: Codable {
    let assignmentID: String
    let studentID: String
    let courseID: String
    let text: String?
}

struct SupervisorSubmissoins: Codable {
    let id: String?
    let file: File?
    let text: String?
    let studentID: String
    let studentName: String
    let peerID: String?
    let peerName: String?
    let supervisorID: String?
    let supervisorName: String?
    let supervisorComment: String?
    let assignmentID: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case file
        case text
        case studentID
        case studentName
        case peerID
        case peerName
        case supervisorID
        case supervisorName
        case supervisorComment
        case assignmentID
    }
}
