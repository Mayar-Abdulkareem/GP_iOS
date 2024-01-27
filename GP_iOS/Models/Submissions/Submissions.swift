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
