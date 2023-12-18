//
//  PrevProjects.swift
//  GP_iOS
//
//  Created by FTS on 16/12/2023.
//

import Foundation

struct ProjectResponse: Codable {
    let totalCount: Int
    let currentPage: Int
    let pageSize: Int
    let previousProjects: [PreviousProject]
}

struct PreviousProject: Codable {
    let name: String
    let projectType: String
    let date: String
    let students: String
    let supervisor: String
    let description: String
    let link: String
}
