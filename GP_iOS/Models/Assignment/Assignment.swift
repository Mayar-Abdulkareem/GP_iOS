//
//  Assignment.swift
//  GP_iOS
//
//  Created by Mayar Abdulkareem on 21/01/2024.
//

import Foundation

struct File: Codable {
    let fileName: String?
    let content: String?
    let contentType: String?
}

struct MyFile: Codable {
    let fileName: String
    let fileURL: String?
    let contentType: String
}

struct Assignment: Codable {
    let id: String
    let title: String
    let file: File?
    let opened: String
    let deadline: String

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case file
        case opened
        case deadline
    }
}
